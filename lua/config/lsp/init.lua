local default_node_modules = "/Users/leandro/.config/lvim/node_modules"
local lspconfig = require("lspconfig")
local mason_registry = require("mason-registry")

local M = {}

-- Function to get the TypeScript server path
local function get_typescript_server_path()
  local tsserver_path = mason_registry.get_package('typescript-language-server'):get_install_path()
  return tsserver_path .. '/node_modules/typescript/lib/tsserverlibrary.js'
end

function M.setup()
  -- Give floating windows borders
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

  -- Configure diagnostic display
  vim.diagnostic.config({
    virtual_text = {
      -- Only display errors w/ virtual text
      severity = vim.diagnostic.severity.ERROR,
      -- Prepend with diagnostic source if there is more than one attached to the buffer
      -- (e.g. (eslint) Error: blah blah blah)
      source = "if_many",
      signs = false,
    },
    float = {
      severity_sort = true,
      source = "if_many",
      border = "solid",
      header = {
        "",
        "LspDiagnosticsDefaultWarning",
      },
      prefix = function(diagnostic)
        local diag_to_format = {
          [vim.diagnostic.severity.ERROR] = { "Error", "LspDiagnosticsDefaultError" },
          [vim.diagnostic.severity.WARN] = { "Warning", "LspDiagnosticsDefaultWarning" },
          [vim.diagnostic.severity.INFO] = { "Info", "LspDiagnosticsDefaultInfo" },
          [vim.diagnostic.severity.HINT] = { "Hint", "LspDiagnosticsDefaultHint" },
        }
        local res = diag_to_format[diagnostic.severity]
        return string.format("(%s) ", res[1]), res[2]
      end,
    },
    severity_sort = true,
  })

  -- restricted format
  ---@param bufnr number buffer to format
  ---@param allowed_clients string[] client names to allow formatting
  local format_by_client = function(bufnr, allowed_clients)
    vim.lsp.buf.format({
      bufnr = bufnr,
      filter = function(client)
        if not allowed_clients then return true end
        return vim.tbl_contains(allowed_clients, client.name)
      end,
    })
  end

  ---@param bufnr number
  ---@param allowed_clients string[]
  local register_format_on_save = function(bufnr, allowed_clients)
    local format_group = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = format_group,
      buffer = bufnr,
      callback = function() format_by_client(bufnr, allowed_clients) end,
    })
  end

  ---@param client any the lsp client instance
  ---@param bufnr number buffer we're attaching to
  ---@param format_opts table how to deal with formatting, takes the following keys:
  -- allowed_clients (string[]): names of the lsp clients that are allowed to handle vim.lsp.buf.format() when this client is attached
  -- format_on_save (bool): whether or not to auto format on save
  local custom_attach = function(client, bufnr, format_opts)
    local keymap_opts = { buffer = bufnr, silent = true, noremap = true }
    local with_desc = function(opts, desc) return vim.tbl_extend("force", opts, { desc = desc }) end

    vim.keymap.set("n", "K", vim.lsp.buf.hover, with_desc(keymap_opts, "Hover"))
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, with_desc(keymap_opts, "Goto Definition"))
    vim.keymap.set("n", "<leader>gr", "<cmd>Glance references<CR>", with_desc(keymap_opts, "Find References"))
    vim.keymap.set("n", "gr", vim.lsp.buf.rename, with_desc(keymap_opts, "Rename"))

    -- diagnostics
    vim.keymap.set("n", "<leader>dk", vim.diagnostic.open_float, with_desc(keymap_opts, "View Current Diagnostic")) -- diagnostic(s) on current line
    vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, with_desc(keymap_opts, "Goto next diagnostic"))     -- move to next diagnostic in buffer
    vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, with_desc(keymap_opts, "Goto prev diagnostic"))     -- move to prev diagnostic in buffer
    -- vim.keymap.set("n", "<leader>da", vim.diagnostic.setqflist, with_desc(keymap_opts, "Populate qf list"))         -- show all buffer diagnostics in qflist

    vim.keymap.set("n", "<leader>da", function()
      local javascriptDAP = require("config.dap.javascript")
      if vim.fn.filereadable(".vscode/launch.json") then
        local dap_vscode = require("dap.ext.vscode")
        dap_vscode.load_launchjs(nil, {
          ["pwa-node"] = javascriptDAP.js_based_languages,
          ["node"] = javascriptDAP.js_based_languages,
          ["chrome"] = javascriptDAP.js_based_languages,
          ["pwa-chrome"] = javascriptDAP.js_based_languages,
        })
        require("dap").continue()
      end
    end, with_desc(keymap_opts, "Launch using launch.json with args"))

    vim.keymap.set("n", "H", function()
      -- make sure telescope is loaded for code actions
      require("telescope").load_extension("ui-select")
      vim.lsp.buf.code_action()
    end, with_desc(keymap_opts, "Code Actions")) -- code actions (handled by telescope-ui-select)
    vim.keymap.set(
      "n",
      "<leader>F",
      function() format_by_client(bufnr, format_opts.allowed_clients or { client.name }) end,
      with_desc(keymap_opts, "Format")
    )                                                                                                           -- format
    vim.keymap.set("n", "<Leader>rr", "<cmd>LspRestart<CR>", with_desc(keymap_opts, "Restart all LSP clients")) -- restart clients

    if format_opts and format_opts.format_on_save then
      register_format_on_save(bufnr, format_opts.allowed_clients or { client.name })
    end
  end

  --#region Set up clients
  local vue_typescript_plugin = mason_registry
      .get_package('vue-language-server')
      :get_install_path()
      .. '/node_modules/@vue/language-server'
      .. '/node_modules/@vue/typescript-plugin'

  lspconfig.tsserver.setup {
    on_attach = function(client, bufnr)
      custom_attach(client, bufnr,
        { allowed_clients = { "tsserver" }, format_on_save = true })
    end,
    init_options = {
      plugins = {
        {
          name = "@vue/typescript-plugin",
          location = vue_typescript_plugin,
          languages = { 'vue' }
        },
      },
    },
    -- root_dir = lspconfig.util.root_pattern("turbo.json", "tsconfig.json", "package.json"),
    -- root_dir = function(fname)
    --   return lspconfig.util.root_pattern("turbo.json")(fname)
    --       or lspconfig.util.root_pattern("tsconfig.json")(fname)
    --       or lspconfig.util.root_pattern("package.json")(fname)
    -- end,
    root_dir = function(filename, bufnr)
      local denoRootDir = lspconfig.util.root_pattern("deno.json", "deno.json")(filename);
      if denoRootDir then
        return nil;
      end

      return lspconfig.util.root_pattern("turbo.json", "tsconfig.json", "package.json")(filename);
    end,
    single_file_support = false,
    settings = {},
    filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
      'vue'
    },
  }

  -- Deno config
  lspconfig.denols.setup {
    on_attach = function(client, bufnr)
      custom_attach(client, bufnr, { allowed_clients = { "denols" }, format_on_save = true })
    end,
    root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
    filetypes = {
      "typescript",
      "typescriptreact"
    },
    init_options = {
      lint = true,
      unstable = true,
      suggest = {
        imports = {
          hosts = {
            ["https://deno.land"] = true,
            ["https://cdn.nest.land"] = true,
            ["https://crux.land"] = true,
          },
        },
      },
    },
  }

  -- Vue config
  -- hybridMode is true by default
  lspconfig.volar.setup({
    -- init_options = {
    --   vue = {
    --     hybridMode = false
    --   }
    -- }
  })

  -- yaml
  lspconfig.yamlls.setup({
    autostart = false,
    on_attach = function(client, bufnr)
      custom_attach(client, bufnr, { allowed_clients = { "efm" }, format_on_save = false })
    end,
  })

  -- bash
  lspconfig.bashls.setup({
    on_attach = custom_attach,
    filetypes = { "bash", "sh", "zsh" },
  })

  -- lua
  lspconfig.lua_ls.setup({
    on_attach = function(client, bufnr) custom_attach(client, bufnr, { allowed_clients = { "efm" } }) end,
    on_init = function(client)
      local path = client.workspace_folders[1].name
      if not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc") then
        client.config.settings = vim.tbl_deep_extend("force", client.config.settings.Lua, {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            library = { vim.env.VIMRUNTIME },
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
            -- library = vim.api.nvim_get_runtime_file("", true)
          },
        })

        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
      end
      return true
    end,
    settings = {
      Lua = {
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          checkThirdParty = false,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  })

  -- json w/ common schemas
  lspconfig.jsonls.setup({
    on_attach = custom_attach,
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  })

  -- rust
  lspconfig.rust_analyzer.setup({
    on_attach = function(client, bufnr)
      custom_attach(client, bufnr, { format_on_save = true, allowed_clients = { "rust_analyzer" } })
    end,
  })

  -- go
  lspconfig.gopls.setup({
    on_attach = function(client, bufnr)
      custom_attach(client, bufnr, { allowed_clients = { "gopls" }, format_on_save = false })

      -- Auto organize imports
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          local params = vim.lsp.util.make_range_params()
          params.context = { only = { "source.organizeImports" } }

          -- Request code actions
          local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
          for _, res in pairs(result or {}) do
            for _, action in pairs(res.result or {}) do
              if action.edit or type(action.command) == "table" then
                -- Apply the action if available
                vim.lsp.buf.execute_command(action.command)
              end
            end
          end
        end,
      })
    end,
  })

  -- lspconfig.gopls.setup({
  --   on_attach = function(client, bufnr)
  --     custom_attach(client, bufnr, { allowed_clients = { "gopls" }, format_on_save = false })
  --     -- auto organize imports
  --     vim.api.nvim_create_autocmd("BufWritePre", {
  --       pattern = "*.go",
  --       callback = function()
  --         vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
  --       end,
  --     })
  --   end,
  -- })

  -- dart
  lspconfig.dartls.setup({
    on_attach = function(client, bufnr)
      custom_attach(client, bufnr, { allowed_clients = { "dartls" }, format_on_save = true })
    end,
  })

  -- Prisma
  lspconfig.prismals.setup({
    on_attach = function(client, bufnr)
      custom_attach(client, bufnr, { allowed_clients = { "prismals" }, format_on_save = false })
    end,
  })

  -- angular
  local angularlsCmd = {
    'ngserver',
    '--stdio',
    '--tsProbeLocations',
    default_node_modules,
    '--ngProbeLocations',
    default_node_modules,
    "--experimental-ivy"
  }
  lspconfig.angularls.setup({
    cmd = angularlsCmd,
    on_new_config = function(new_config, new_root_dir)
      new_config.cmd = angularlsCmd
    end,
    on_attach = function(client, bufnr)
      custom_attach(client, bufnr, { allowed_clients = { "angularls" }, format_on_save = false })
    end,
  })
  --#endregion

  return {
    custom_attach = custom_attach,
  }
end

return M
