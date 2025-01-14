local dap = require "dap"

dap.adapters = {}
dap.configurations = {}

dap.adapters.codelldb = {
  type = "executable",
  command = "/home/guillermo/.local/share/nvim/mason/bin/codelldb",
  name = "codelldb",
}

local function get_executable_from_input()
  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
end

--- Get the executable name from the CMakeLists.txt file
local function get_executable_name()
  local cmake_file = io.open(vim.fn.getcwd() .. "/CMakeLists.txt", "r")
  if not cmake_file then
    return get_executable_from_input()
  end

  local executable_name = nil
  for line in cmake_file:lines() do
    local match = line:match "project%((%S+)%)"
    if match then
      executable_name = match
      break
    end
  end

  if not executable_name then
    executable_name = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
  end

  cmake_file:close()
  return executable_name
end

dap.configurations.cpp = {
  {
    name = "Debug",
    type = "codelldb",
    request = "launch",
    program = function()
      local build_file_name = get_executable_name()
      return vim.fn.getcwd() .. "/build/" .. build_file_name
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}

-- dap.configurations.c = dap.configurations.cpp
-- dap.configurations.rust = dap.configurations.cpp

