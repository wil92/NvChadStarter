require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- GITHUB COPILOT
map("n", "<Leader>co", "<cmd>CopilotChatOpen<CR>", { noremap = true, silent = true })
map("n", "<Leader>cc", "<cmd>CopilotChatClose<CR>", { noremap = true, silent = true })
-- GITHUB COPILOT

-- GO TO IN CODE
map("n", "gd", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
map("n", "gD", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
-- GO TO IN CODE

local function build_project()
  local output =
    vim.fn.system "mkdir -p build;cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON;cp build/compile_commands.json compile_commands.json;cmake --build build;"
  vim.notify(output)

  return output:match "(%S+)%s*$"
end

-- BUILD PROJECT
map("n", "<F8>", function()
  build_project()
end, { noremap = true, silent = false, desc = "Build project" })
map("n", "<F6>", function()
  local scandir = vim.loop.fs_scandir("shaders")
  if scandir then
    while true do
      local name, type = vim.loop.fs_scandir_next(scandir)
      if not name then
        break
      end
      local ext = ".glsl"
      vim.notify(name)
      if type == "file" and name:sub(-#ext) == ext then
        local command = "sokol-shdc --input shaders/" .. name .. " --output shaders/" .. name .. ".h --slang glsl430"
        vim.notify(vim.fn.system(command))
      end
    end
  end
end, { noremap = true, silent = false, desc = "Build shaders" })
-- BUILD PROJECT

-- EXECUTE PROJECT
map("n", "<F5>", function()
  local project_name = build_project()
  vim.notify(vim.fn.system("./build/" .. project_name))
end, { noremap = true, silent = false, desc = "Execute project" })
-- EXECUTE PROJECT

-- DEBUG
map("n", "<F9>", "<cmd>lua require'dap'.continue()<CR>", { silent = true, desc = "Continue debug" })
map("n", "<F7>", function()
  require("dap").step_over()
end)
-- map('n', '<F11>', function() require('dap').step_into() end)
-- map('n', '<F12>', function() require('dap').step_out() end)
map("n", "<Leader>b", function()
  require("dap").toggle_breakpoint()
end, { desc = "Breakpoint" })
map("n", "<Leader>dc", "<cmd>lua require'dapui'.close()<CR>", { desc = "Close debug UI", silent = false })
-- map("n", "<Leader>B", function() require("dap").set_breakpoint() end)
-- map('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
-- map('n', '<Leader>dr', function() require('dap').repl.open() end)
-- map('n', '<Leader>dl', function() require('dap').run_last() end)
-- map({'n', 'v'}, '<Leader>dh', function() require('dap.ui.widgets').hover() end)
-- map({'n', 'v'}, '<Leader>dp', function() require('dap.ui.widgets').preview() end)
-- map('n', '<Leader>df', function() local widgets = require('dap.ui.widgets') widgets.centered_float(widgets.frames) end)
-- map('n', '<Leader>ds', function() local widgets = require('dap.ui.widgets') widgets.centered_float(widgets.scopes) end)
-- DEBUG

-- FORMATTING
map("n", "<C-A-l>", ":Format<CR>", { noremap = true, silent = true })
-- FORMATTING

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
