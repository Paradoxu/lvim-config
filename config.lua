require('plugins')
require('keybindings').setup()

-- general
vim.lsp.set_log_level("off") -- or debug
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

lvim.format_on_save = true;
lvim.builtin.alpha.dashboard.section.header.val = require('ascii').get_random("animals", "cats");
lvim.autocommands = {
  autowrite = true,
  laststatus = 2,
}


-- vim specific
vim.diagnostic.config({
  virtual_text = false,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = false,
})
