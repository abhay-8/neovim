local M = {}

local session = require("custom.session")

--------------------------------------------------
-- OpenAPI loading
--------------------------------------------------

local function find_openapi_file()
  local candidates = {
    vim.fn.getcwd() .. "/docs/openapi.json",
    vim.fn.getcwd() .. "/openapi.json",
  }

  for _, path in ipairs(candidates) do
    if vim.fn.filereadable(path) == 1 then
      return path
    end
  end

  return nil
end

local function load_openapi()
  local path = find_openapi_file()

  if not path then
    vim.notify(
      "Could not find docs/openapi.json or openapi.json",
      vim.log.levels.ERROR
    )

    return {}
  end

  local content = table.concat(
    vim.fn.readfile(path),
    "\n"
  )

  local ok, spec = pcall(vim.json.decode, content)

  if not ok then
    vim.notify(
      "Failed to parse openapi.json",
      vim.log.levels.ERROR
    )

    return {}
  end

  local endpoints = {}

  for route, methods in pairs(spec.paths or {}) do
    for method, _ in pairs(methods) do
      table.insert(endpoints, {
        label = string.format(
          "%-6s %s",
          method:upper(),
          route
        ),

        method = method:upper(),
        path = route,
      })
    end
  end

  table.sort(endpoints, function(a, b)
    return a.label < b.label
  end)

  return endpoints
end

--------------------------------------------------
-- Path params
--------------------------------------------------

local function fill_path_params(path)
  for param in path:gmatch("{([%w_]+)}") do
    local value = vim.fn.input(param .. ": ")

    path = path:gsub(
      "{" .. param .. "}",
      value
    )
  end

  return path
end

--------------------------------------------------
-- HTTP buffer
--------------------------------------------------

local function create_request_buffer(
  method,
  url,
  token
)
  vim.cmd("botright vnew")

  local buf = vim.api.nvim_get_current_buf()

  vim.bo.filetype = "http"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false

  local lines = {
    method .. " " .. url,
    "Authorization: Bearer " .. token,
    "Content-Type: application/json",
    "",
  }

  if method ~= "GET" and method ~= "DELETE" then
    vim.list_extend(lines, {
      "{",
      '  "example": true',
      "}",
    })
  end

  vim.api.nvim_buf_set_lines(
    buf,
    0,
    -1,
    false,
    lines
  )

  vim.cmd("normal! G")
end

--------------------------------------------------
-- Main
--------------------------------------------------

function M.run()
  local endpoints = load_openapi()

  if #endpoints == 0 then
    return
  end

  vim.ui.select(
    endpoints,
    {
      prompt = "Select API endpoint:",

      format_item = function(item)
        return item.label
      end,
    },

    function(selection)
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

      local path =
        fill_path_params(selection.path)

      local url =
        string.format(
          "http://localhost:%s%s",
          port,
          path
        )

      create_request_buffer(
        selection.method,
        url,
        token
      )

      vim.notify(
        "Request ready. Press <leader>kr to execute."
      )
    end
  )
end

return M
