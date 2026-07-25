local M = {}

local session = require("custom.session")


--------------------------------------------------
-- Config
--------------------------------------------------

local SCHEMA_FILE = "graphql-schema.json"
local MAX_DEPTH = 5

--------------------------------------------------
-- Helpers
--------------------------------------------------

local function read_json(path)
  local content = table.concat(vim.fn.readfile(path), "\n")

  local ok, decoded = pcall(vim.json.decode, content)

  if not ok then
    vim.notify(
      "Failed to parse " .. path,
      vim.log.levels.ERROR
    )

    return nil
  end

  return decoded
end

local function load_schema()
  local path = vim.fn.getcwd() .. "/" .. SCHEMA_FILE

  if vim.fn.filereadable(path) == 0 then
    vim.notify(
      "Could not find " .. SCHEMA_FILE,
      vim.log.levels.ERROR
    )

    return nil
  end

  local schema = read_json(path)

  if not schema or not schema.__schema then
    vim.notify(
      "Invalid GraphQL introspection schema",
      vim.log.levels.ERROR
    )

    return nil
  end

  return schema.__schema
end

local function build_type_map(schema)
  local types = {}

  for _, t in ipairs(schema.types or {}) do
    if t.name then
      types[t.name] = t
    end
  end

  return types
end

--------------------------------------------------
-- GraphQL type helpers
--------------------------------------------------

local function has_ofType(type_ref)
  return type_ref.ofType ~= nil
    and type_ref.ofType ~= vim.NIL
end

local function unwrap_type(type_ref)
  while type_ref and has_ofType(type_ref) do
    type_ref = type_ref.ofType
  end

  return type_ref
end

local function render_type_ref(type_ref)
  if not type_ref or type_ref == vim.NIL then
    return "Unknown"
  end

  if type_ref.kind == "NON_NULL" then
    return render_type_ref(type_ref.ofType) .. "!"
  end

  if type_ref.kind == "LIST" then
    return "[" .. render_type_ref(type_ref.ofType) .. "]"
  end

  return type_ref.name or "Unknown"
end

local function is_scalar(kind)
  return kind == "SCALAR"
    or kind == "ENUM"
end

local function is_input_object(kind)
  return kind == "INPUT_OBJECT"
end

local function get_fields(type_map, type_name)
  local t = type_map[type_name]

  if not t then
    return nil
  end

  if t.fields then
    return t.fields
  end

  if t.kind == "INTERFACE" then
    return t.fields
  end

  return nil
end

local function get_scalar_fields(type_map, type_name)
  local fields = get_fields(type_map, type_name)

  if not fields then
    return {}
  end

  local scalars = {}

  for _, field in ipairs(fields) do
    local field_type = unwrap_type(field.type)

    if is_scalar(field_type.kind) then
      table.insert(scalars, { name = field.name })
    end
  end

  return scalars
end

--------------------------------------------------
-- Queries / Mutations
--------------------------------------------------

local function collect_operations(schema, type_map)
  local operations = {}

  local roots = {
    {
      kind = "query",
      name = schema.queryType
        and schema.queryType.name,
    },

    {
      kind = "mutation",
      name = schema.mutationType
        and schema.mutationType.name,
    },
  }

  for _, root in ipairs(roots) do
    if root.name then
      local root_type = type_map[root.name]

      if root_type and root_type.fields then
        for _, field in ipairs(root_type.fields) do
          table.insert(operations, {
            kind = root.kind,
            name = field.name,
            field = field,

            label = string.format(
              "%-8s %s",
              root.kind:upper(),
              field.name
            ),
          })
        end
      end
    end
  end

  table.sort(operations, function(a, b)
    return a.label < b.label
  end)

  return operations
end

local function render_fields(fields, indent)
  indent = indent or 4

  local lines = {}

  for _, field in ipairs(fields) do
    if field.children and #field.children > 0 then
      table.insert(
        lines,
        string.rep(" ", indent) .. field.name .. " {"
      )

      vim.list_extend(
        lines,
        render_fields(field.children, indent + 2)
      )

      table.insert(
        lines,
        string.rep(" ", indent) .. "}"
      )
    else
      table.insert(
        lines,
        string.rep(" ", indent) .. field.name
      )
    end
  end

  return lines
end

--------------------------------------------------
-- Telescope multi-select
--------------------------------------------------

local function telescope_multi_select(
  title,
  items,
  format_fn,
  callback
)
  local fzf_items = {}
  local item_map = {}
  
  for _, item in ipairs(items) do
    local display = format_fn and format_fn(item) or item.name
    table.insert(fzf_items, display)
    item_map[display] = item
  end

  require("fzf-lua").fzf_exec(fzf_items, {
    prompt = title .. "> ",
    fzf_opts = {
      ["--multi"] = true,
    },
    actions = {
      ["default"] = function(selected)
        local result = {}
        for _, display in ipairs(selected) do
          table.insert(result, item_map[display])
        end
        callback(result)
      end,
    },
  })
end


--------------------------------------------------
-- Recursive field picker
--------------------------------------------------

local function pick_fields(
  type_map,
  type_name,
  callback,
  depth,
  visited
)
  depth = depth or 0
  visited = visited or {}

  if depth >= MAX_DEPTH then
    vim.notify(
      "Max depth reached for " .. type_name,
      vim.log.levels.WARN
    )

    local scalars = get_scalar_fields(type_map, type_name)
    callback(scalars)
    return
  end

  if visited[type_name] then
    local scalars = get_scalar_fields(type_map, type_name)
    callback(scalars)
    return
  end

  local fields = get_fields(type_map, type_name)

  if not fields then
    callback({})
    return
  end

  local format_fn = function(item)
    local field_type = unwrap_type(item.type)
    local type_str = render_type_ref(item.type)

    if is_scalar(field_type.kind) then
      return item.name .. "  →  " .. type_str
    end

    return item.name .. "  →  " .. type_str .. "  {…}"
  end

  telescope_multi_select(
    "Select fields for " .. type_name,
    fields,
    format_fn,

    function(selected_fields)
      local result = {}
      local index = 1

      local function process_next()
        if index > #selected_fields then
          callback(result)
          return
        end

        local field = selected_fields[index]
        index = index + 1

        local field_type = unwrap_type(field.type)

        if is_scalar(field_type.kind) then
          table.insert(result, {
            name = field.name,
          })

          process_next()
          return
        end

        local branch_visited = vim.tbl_extend(
          "force",
          {},
          visited
        )

        branch_visited[type_name] = true

        pick_fields(
          type_map,
          field_type.name,

          function(children)
            if #children == 0 then
              children = get_scalar_fields(
                type_map,
                field_type.name
              )
            end

            if #children > 0 then
              table.insert(result, {
                name = field.name,
                children = children,
              })
            end

            process_next()
          end,

          depth + 1,
          branch_visited
        )
      end

      process_next()
    end
  )
end

--------------------------------------------------
-- Variables
--------------------------------------------------

local function parse_variable_value(raw)
  if raw == "" then
    return raw
  end

  local as_num = tonumber(raw)

  if as_num then
    return as_num
  end

  if raw == "true" then
    return true
  end

  if raw == "false" then
    return false
  end

  if raw == "null" then
    return vim.NIL
  end

  local first = raw:sub(1, 1)

  if first == "{" or first == "[" then
    local ok, decoded = pcall(vim.json.decode, raw)

    if ok then
      return decoded
    end
  end

  return raw
end

local function default_for_scalar(type_name)
  if type_name == "Int" or type_name == "Float" then
    return 0
  elseif type_name == "Boolean" then
    return false
  elseif type_name == "ID" then
    return ""
  else
    return ""
  end
end

local function build_input_template(type_map, type_ref, depth)
  depth = depth or 0

  if depth > MAX_DEPTH then
    return {}
  end

  local unwrapped = unwrap_type(type_ref)

  if is_scalar(unwrapped.kind) then
    return default_for_scalar(unwrapped.name)
  end

  if unwrapped.kind == "INPUT_OBJECT" then
    local t = type_map[unwrapped.name]

    if not t or not t.inputFields then
      return {}
    end

    local template = {}

    for _, field in ipairs(t.inputFields) do
      local field_unwrapped = unwrap_type(field.type)

      if is_scalar(field_unwrapped.kind) then
        template[field.name] =
          default_for_scalar(field_unwrapped.name)
      elseif field_unwrapped.kind == "INPUT_OBJECT" then
        template[field.name] =
          build_input_template(
            type_map,
            field.type,
            depth + 1
          )
      else
        template[field.name] = vim.NIL
      end
    end

    return template
  end

  return vim.NIL
end

local function open_json_popup(title, template, callback)
  local json_str = vim.fn.system(
    { "python3", "-m", "json.tool" },
    vim.json.encode(template)
  )

  local lines = vim.split(json_str, "\n", { trimempty = true })

  local width = 60
  local height = math.min(#lines + 2, 30)

  for _, line in ipairs(lines) do
    width = math.max(width, #line + 4)
  end

  width = math.min(width, 100)

  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = "json"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].modifiable = true

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor(
      (vim.o.lines - height) / 2
    ),
    col = math.floor(
      (vim.o.columns - width) / 2
    ),
    style = "minimal",
    border = "rounded",
    title = " " .. title .. " ",
    title_pos = "center",
    footer = " <C-s> confirm | q quit ",
    footer_pos = "center",
  })

  vim.wo[win].wrap = false

  local function submit()
    local content = table.concat(
      vim.api.nvim_buf_get_lines(buf, 0, -1, false),
      "\n"
    )

    vim.api.nvim_win_close(win, true)

    local ok, decoded = pcall(vim.json.decode, content)

    if not ok then
      vim.notify(
        "Invalid JSON: " .. tostring(decoded),
        vim.log.levels.ERROR
      )

      callback(nil)
      return
    end

    callback(decoded)
  end

  local function cancel()
    vim.api.nvim_win_close(win, true)
    callback(nil)
  end

  vim.keymap.set("n", "<C-s>", submit, { buffer = buf })
  vim.keymap.set("i", "<C-s>", submit, { buffer = buf })
  vim.keymap.set("n", "q", cancel, { buffer = buf })
end

local function prompt_variables(args, type_map, callback)
  local variables = {}
  local declarations = {}
  local assignments = {}
  local index = 1

  local function process_next()
    if index > #(args or {}) then
      callback({
        variables = variables,

        declarations =
          table.concat(declarations, ", "),

        assignments =
          table.concat(assignments, ", "),
      })

      return
    end

    local arg = args[index]
    index = index + 1

    local name = arg.name
    local type_str = render_type_ref(arg.type)
    local unwrapped = unwrap_type(arg.type)

    table.insert(
      declarations,
      string.format("$%s: %s", name, type_str)
    )

    table.insert(
      assignments,
      string.format("%s: $%s", name, name)
    )

    if is_input_object(unwrapped.kind) then
      local template =
        build_input_template(type_map, arg.type)

      open_json_popup(
        name .. " (" .. type_str .. ")",
        template,

        function(value)
          if value == nil then
            return
          end

          variables[name] = value
          process_next()
        end
      )
    else
      local prompt_label =
        name .. " (" .. type_str .. "): "

      local value = vim.fn.input(prompt_label)

      variables[name] = parse_variable_value(value)
      process_next()
    end
  end

  process_next()
end

--------------------------------------------------
-- Query generation
--------------------------------------------------

local function build_query(op, vars, fields)
  local operation_type =
    op.kind == "mutation"
      and "mutation"
      or "query"

  local declaration_part = ""

  if vars.declarations ~= "" then
    declaration_part =
      "(" .. vars.declarations .. ")"
  end

  local assignment_part = ""

  if vars.assignments ~= "" then
    assignment_part =
      "(" .. vars.assignments .. ")"
  end

  local body =
    table.concat(render_fields(fields), "\n")

  return string.format(
    "%s %s%s {\n  %s%s {\n%s\n  }\n}",
    operation_type,
    op.name,
    declaration_part,
    op.name,
    assignment_part,
    body
  )
end

--------------------------------------------------
-- HTTP buffer
--------------------------------------------------

local function create_request_buffer(
  url,
  token,
  query,
  variables
)
  vim.cmd("botright vnew")

  local buf = vim.api.nvim_get_current_buf()

  vim.api.nvim_buf_set_name(buf, "graphql-request.http")
  vim.bo.filetype = "http"
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false

  if not next(variables) then
    variables = vim.empty_dict()
  end

  local payload = {
    query = query,
    variables = variables,
  }

  local body = vim.json.encode(payload)

  local pretty = vim.split(
    vim.fn.system({
      "python3",
      "-m",
      "json.tool",
    }, body),
    "\n",
    { trimempty = true }
  )

  local lines = {
    "POST " .. url,
    "x-jwt-assertion: " .. token,
    "Content-Type: application/json",
    "",
  }

  vim.list_extend(lines, pretty)

  vim.api.nvim_buf_set_lines(
    buf,
    0,
    -1,
    false,
    lines
  )

  vim.cmd("normal! gg")
end

--------------------------------------------------
-- Operation picker (Telescope)
--------------------------------------------------

local function pick_operation(operations, callback)
  local fzf_items = {}
  local item_map = {}
  
  for _, item in ipairs(operations) do
    table.insert(fzf_items, item.label)
    item_map[item.label] = item
  end

  require("fzf-lua").fzf_exec(fzf_items, {
    prompt = "GraphQL Operations> ",
    actions = {
      ["default"] = function(selected)
        if selected and #selected > 0 then
          callback(item_map[selected[1]])
        end
      end,
    },
  })
end

--------------------------------------------------
-- Main
--------------------------------------------------

function M.run()
  local schema = load_schema()

  if not schema then
    return
  end

  local type_map = build_type_map(schema)

  local operations =
    collect_operations(schema, type_map)

  if #operations == 0 then
    vim.notify(
      "No GraphQL operations found",
      vim.log.levels.ERROR
    )

    return
  end

  pick_operation(operations, function(selection)
    if not selection then
      return
    end

    local port = session.get_port()

    if not port then
      return
    end

    local token = session.get_token()

    if not token then
      return
    end

    local endpoint = session.get_graphql_endpoint()

    if not endpoint then
      return
    end

    prompt_variables(
      selection.field.args,
      type_map,

      function(vars)
        local return_type =
          unwrap_type(selection.field.type)

        pick_fields(
          type_map,
          return_type.name,

          function(fields)
            local query =
              build_query(selection, vars, fields)

            local url =
              string.format(
                "http://localhost:%s%s",
                port,
                endpoint
              )

            create_request_buffer(
              url,
              token,
              query,
              vars.variables
            )

            vim.notify(
              "GraphQL request ready. Press <leader>kr to execute."
            )
          end
        )
      end
    )
  end)
end

return M
