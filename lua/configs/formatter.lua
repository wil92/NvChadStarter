require("formatter").setup {
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = {
    lua = {
      require("formatter.filetypes.lua").stylua,
      -- function ()
      --   return {
      --     exe = "stylua",
      --     args = {"--assume-filename", vim.api.nvim_buf_get_name(0)},
      --     stdin = true
      --   }
      -- end
    },
    cpp = {
      function()
        return {
          exe = "clang-format",
          args = { "--assume-filename", vim.api.nvim_buf_get_name(0) },
          stdin = true,
        }
      end,
    },
  },
}
