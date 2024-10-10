local M = {}

function M.setup()
  local wk = require("which-key")
  wk.setup()
  wk.register({
    ["f"] = {
      name = "Flutter",
      d = { "<cmd>FlutterVisualDebug<cr>", "Visual debug" },
      h = { "<cmd>FlutterRestart<cr>", "Hot reload" },
      q = { "<cmd>FlutterQuit<cr>", "Quit" },
      r = { "<cmd>FlutterRun<cr>", "Run app" },
      R = { "<cmd>FlutterRestart<cr>", "Hot restart" },
      pg = { "<cmd>FlutterPubGet<cr>", "Pub Get" },
      pu = { "<cmd>FlutterPubUpgrade<cr>", "Pub Upgrade" },
    },
    ["<leader>"] = {
      b = {
        name = "Buffer",
        f = { "<cmd>Neoformat<cr><cmd>w<cr>", "Format" },
        n = { "<cmd>bnext<cr>", "Next Buffer" },
        p = { "<cmd>bprev<cr>", "Previous Buffer" },
        u = { "<cmd>undo<cr>", "Undo" },
        r = { "<cmd>redo<cr>", "Redo" },
        h = { "<C-w>h", "Go to the window to the left" },
        l = { "<C-w>l", "Go to the window to the right" },
        j = { "<C-w>j", "Go to the window below" },
        k = { "<C-w>k", "Go to the window above" },
        ["<"] = { "15<C-w><", "Decrease buffer width" },
        [">"] = { "15<C-w>>", "Increase buffer width" },
        ["-"] = { "15<C-w>-", "Decrease buffer height" },
        ["+"] = { "15<C-w>+", "Increase buffer height" },
      },
      d = {
        name = "Debug",
        b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle breakpoint" },
        l = {
          "<cmd>lua require'dap.ext.vscode'.load_launchjs()<cr><cmd>lua require'dap'.continue()<cr>",
          "Launch debug session",
        },
        t = { "<cmd>lua require'dap'.terminate()<cr><cmd>lua require'dapui'.close()<cr>", "Terminate debug session" },
      },
      f = {
        name = "Fuzzy finder",
        f = { "<cmd>Telescope find_files hidden=true<cr>", "Find files" },
        g = { "<cmd>Telescope live_grep<cr>", "Live grep" },
        b = { "<cmd>Telescope buffers<cr>", "Buffers" },
        h = { "<cmd>Telescope help_tags<cr>", "Help tags" },
        o = { "<cmd>Telescope oldfiles<cr>", "Recent files" },
      },
      g = {
        name = "git",
        g = { "<cmd>Lazygit<cr>", "Open LazyGit" },
        P = { "<cmd>Copilot panel<cr>", "Copilot Panel" },
      },
      h = {
        name = "Hover",
        h = { "<cmd>lua require'hover'.hover()<cr>", "Hover" },
        s = { "<cmd>lua require'hover'.hover_select()<cr>", "Hover select" }
      },
      l = {
        name = "LSP",
        a = { "<cmd>Lspsaga code_action<cr>", "Code actions" },
        d = { "<cmd>Trouble lsp_definitions<cr>", "Go to definition" },
        h = { "<cmd>ClangdSwitchSourceHeader<cr>", "Toggle header/source" },
        p = { "<cmd>Lspsaga peek_definition<cr>", "Peek definition" },
        u = { "<cmd>Trouble lsp_references<cr>", "Show usages" },
        r = { "<cmd>Lspsaga rename<cr>", "Rename" },
        x = { "<cmd>Lspsaga show_line_diagnostics<cr>", "Show line diagnostics" },
      },
      r = {
        name = "Rust",
        h = { "<cmd>lua require'rust-tools'.hover_actions.hover_actions()<cr>", "Hover actions" },
        a = { "<cmd>lua require'rust-tools'.code_action_group.code_action_group()<cr>", "Code actions" },
        r = { "<cmd>wa<cr><cmd>lua require'rust-tools'.runnables.runnables()<cr>", "Runnables" },
        d = { "<cmd>wa<cr><cmd>lua require'rust-tools'.debuggables.debuggables()<cr>", "Debuggables" },
      },
      s = {
        name = "Search",
        s = { "<cmd>lua require('searchbox').incsearch()<cr>", "Incremental Search" },
        a = { "<cmd>lua require('searchbox').match_all()<cr>", "Match all" },
        r = { "<cmd>lua require('searchbox').replace()<cr>", "Replace" },
        o = { "<cmd>lua require('spectre').open()<cr>", "Open search dialogue" },
        w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "Search current word" },
        f = { "<cmd>lua require('spectre').open_file_search()<cr>", "Search in current file" },
      },
      x = {
        name = "Trouble",
        d = { "<cmd>Trouble workspace_diagnostics<cr>", "Diagnostics" },
        q = { "<cmd>Trouble quickfix<cr>", "Quickfix" },
        e = {
          "<cmd>lua require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.ERROR })<cr>",
          "Jump to next error",
        },
        E = {
          "<cmd>lua require('lspsaga.diagnostic'):goto_prev({ severity = vim.diagnostic.severity.ERROR })<cr>",
          "Jump to previous error",
        },
      },
    },
    ["<F5>"] = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
    ["<F6>"] = { "<cmd>lua require'dap'.step_out()<cr>", "Step out" },
    ["<F10>"] = { "<cmd>lua require'dap'.step_over()<cr>", "Step over" },
    ["<F11>"] = { "<cmd>lua require'dap'.step_into()<cr>", "Step into" },
    ["<S-Up>"] = { "<cmd>:m-2<cr>", "Move line up" },
    ["<S-Down>"] = { "<cmd>:m+<cr>", "Move line down" },
  })

  -- Keybidings configs override defaults
  lvim.leader = "space";

  lvim.builtin.which_key.mappings["e"] = { "<cmd>NeoTreeFloatToggle<CR>", "Neotree" }
  lvim.builtin.which_key.mappings["f"] = { "<cmd>Telescope find_files hidden=true<CR>", "Telescope find files" }

  -- Codeium
  vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
  vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end,
    { expr = true, silent = true })
  vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end,
    { expr = true, silent = true })
  vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })

  -- Fold
  vim.opt.fillchars = { fold = " " }
  vim.opt.foldmethod = "indent"
  vim.opt.foldenable = false
  vim.opt.foldlevel = 99
end

return M
