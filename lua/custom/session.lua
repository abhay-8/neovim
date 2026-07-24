local M = {}

--------------------------------------------------
-- Defaults
--------------------------------------------------

local DEFAULT_PORT = "3000"
local DEFAULT_GRAPHQL_ENDPOINT = "/api/graphql"

--------------------------------------------------
-- Persistence
--------------------------------------------------

local function session_dir()
  local dir = vim.fn.stdpath("data") .. "/api-sessions"

  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end

  return dir
end

local function session_file()
  local cwd = vim.fn.getcwd()
  local key = cwd:gsub("/", "%%")

  return session_dir() .. "/" .. key .. ".json"
end

local function load_persisted()
  local path = session_file()

  if vim.fn.filereadable(path) == 0 then
    return {}
  end

  local content = table.concat(vim.fn.readfile(path), "\n")
  local ok, data = pcall(vim.json.decode, content)

  if not ok then
    return {}
  end

  return data
end

local function save_persisted(data)
  local path = session_file()
  local encoded = vim.json.encode(data)

  vim.fn.writefile({ encoded }, path)
end

local function persist(key, value)
  local data = load_persisted()

  data[key] = value
  save_persisted(data)
end

local function load_key(key)
  local data = load_persisted()

  return data[key]
end

--------------------------------------------------
-- Port
--------------------------------------------------

function M.get_port()
  if vim.g.api_runner_port then
    return vim.g.api_runner_port
  end

  local saved = load_key("port")
  local default = saved or DEFAULT_PORT

  local port = vim.fn.input("Port: ", default)

  if port == "" then
    return nil
  end

  vim.g.api_runner_port = port
  persist("port", port)

  return port
end

function M.set_port()
  local current =
    vim.g.api_runner_port or load_key("port") or DEFAULT_PORT

  local port = vim.fn.input("Port: ", current)

  if port ~= "" then
    vim.g.api_runner_port = port
    persist("port", port)

    vim.notify("API port set to " .. port)
  end
end

--------------------------------------------------
-- Bearer token
--------------------------------------------------

function M.get_token()
  if vim.g.api_runner_token then
    return vim.g.api_runner_token
  end

  local saved = load_key("token")

  if saved then
    vim.g.api_runner_token = saved
    return saved
  end

  local token = vim.fn.inputsecret("Bearer token: ")

  if token == "" then
    return nil
  end

  vim.g.api_runner_token = token
  persist("token", token)

  return token
end

function M.set_token()
  local token = vim.fn.inputsecret("Bearer token: ")

  if token ~= "" then
    vim.g.api_runner_token = token
    persist("token", token)

    vim.notify("API token updated")
  end
end

--------------------------------------------------
-- GraphQL endpoint
--------------------------------------------------

function M.get_graphql_endpoint()
  if vim.g.graphql_runner_endpoint then
    return vim.g.graphql_runner_endpoint
  end

  local saved = load_key("graphql_endpoint")
  local default = saved or DEFAULT_GRAPHQL_ENDPOINT

  local endpoint = vim.fn.input("GraphQL endpoint: ", default)

  if endpoint == "" then
    return nil
  end

  if not endpoint:match("^/") then
    endpoint = "/" .. endpoint
  end

  vim.g.graphql_runner_endpoint = endpoint
  persist("graphql_endpoint", endpoint)

  return endpoint
end

function M.set_graphql_endpoint()
  local current =
    vim.g.graphql_runner_endpoint
    or load_key("graphql_endpoint")
    or DEFAULT_GRAPHQL_ENDPOINT

  local endpoint = vim.fn.input("GraphQL endpoint: ", current)

  if endpoint == "" then
    return
  end

  if not endpoint:match("^/") then
    endpoint = "/" .. endpoint
  end

  vim.g.graphql_runner_endpoint = endpoint
  persist("graphql_endpoint", endpoint)

  vim.notify("GraphQL endpoint set to " .. endpoint)
end

--------------------------------------------------
-- Clear session
--------------------------------------------------

function M.clear_session()
  vim.g.api_runner_port = nil
  vim.g.api_runner_token = nil
  vim.g.graphql_runner_endpoint = nil

  local path = session_file()

  if vim.fn.filereadable(path) == 1 then
    vim.fn.delete(path)
  end

  vim.notify("API session cleared")
end

return M
