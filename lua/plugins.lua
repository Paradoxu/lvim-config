lvim.plugins = {
  -- Package manager for LSP
  {
    "williamboman/mason.nvim",
    dependencies = {
      "simrat39/rust-tools.nvim",
    },
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✅",
            package_pending = "🔴",
            package_uninstalled = "❌"
          }
        }
      })
      require('mason-lspconfig').setup({
        ensure_installed = {
          "lua_ls",
          "rust_analyzer",
          "clangd",
          "cssls",
          "dockerls",
          "docker_compose_language_service",
          "dotls",
          "gopls",
          "gradle_ls",
          "jsonls",
          "tsserver",
          "kotlin_language_server",
          "markdown_oxide",
          "spectral",
          "pyre",
          "yamlls",
          "tsserver",
          "denols",
          "volar", -- vue
        }
      })
      require('config.lsp').setup()
      require('rust-tools').setup()
    end
  },

  { "b0o/schemastore.nvim" },

  -- better notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
    end,
  },

  -- File Explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      lvim.builtin.nvimtree.active = false;

      -- Package ahmedkhalf/project.nvim that comes with lunarvim, setting to manual_mode will avoid changing root directory
      -- when opening folders
      require("project_nvim").setup {
        manual_mode = true,
      }

      require("neo-tree").setup({
        respect_buf_cwd = true,
        sync_root_with_cwd = true,
        close_if_last_window = true,
        enable_git_status = true,
        enable_diagnostics = true,
        enable_git_status = true,
        popup_border_style = "rounded",
        window = {
          position = "right",
          width = 40,
        },
        buffers = {
          follow_current_file = {
            enabled = false,
            leave_dirs_open = false,
          },
        },
        filesystem = {
          follow_current_file = {
            enabled = false,
            leave_dirs_open = false,
          },
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = {
              "node_modules",
              ".DS_Store",
              "thumbs.db",
              ".vscode",
              ".git"
            },
          },
        },
      })
    end
  },

  -- Displaying errors/warnings in a window
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup({})
    end,
  },

  -- csv
  { "mechatroner/rainbow_csv" },

  -- comments
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup({
        ---Add a space b/w comment and the line
        padding = true,
        ---Whether the cursor should stay at its position
        sticky = true,
        ---Lines to be ignored while (un)comment
        ignore = nil,
        ---LHS of toggle mappings in NORMAL mode
        toggler = {
          ---Line-comment toggle keymap
          line = 'gcc',
          ---Block-comment toggle keymap
          block = 'gbc',
        },
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
          ---Line-comment keymap
          line = 'gc',
          ---Block-comment keymap
          block = 'gb',
        },
        ---LHS of extra mappings
        extra = {
          ---Add comment on the line above
          above = 'gcO',
          ---Add comment on the line below
          below = 'gco',
          ---Add comment at the end of line
          eol = 'gcA',
        },
        ---Enable keybindings
        ---NOTE: If given `false` then the plugin won't create any mappings
        mappings = {
          ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
          basic = true,
          ---Extra mapping; `gco`, `gcO`, `gcA`
          extra = true,
        },
        ---Function to call before (un)comment
        pre_hook = nil,
        ---Function to call after (un)comment
        post_hook = nil,
      })
    end,
  },


  -- diffing/merging
  { "sindrets/diffview.nvim", dependencies = "nvim-lua/plenary.nvim" },


  -- debugging
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap",
      "mfussenegger/nvim-dap-python",
      "jbyuki/one-small-step-for-vimkind",
    },
    config = function()
      require("debugging").setup()
    end,
  },
  {
    "thehamsta/nvim-dap-virtual-text"
  },

  -- Debug javascript
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
      "nvim-telescope/telescope-dap.nvim",
      { "leoluz/nvim-dap-go",                module = "dap-go" },
      { "jbyuki/one-small-step-for-vimkind", module = "osv" },
      { "mxsdev/nvim-dap-vscode-js" },
      { "leoluz/nvim-dap-go" }
    },
    config = function()
      require("config.dap").setup()
      require('dap-go').setup()
      require('dap.ext.vscode').load_launchjs(nil, {})
    end,
  },
  {
    'microsoft/vscode-js-debug',
    build = {
      "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
    }
  },

  -- Mason configuration for dap
  {
    "jayp0521/mason-nvim-dap.nvim",
    config = function()
      require("mason-nvim-dap").setup({
        automatic_setup = true,
        automatic_installation = true,
        ensure_installed = { "python", "cppdbg", "codelldb" },
      })
    end,
  },

  -- Tresitter for minimal source code highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "typescript", "javascript" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = true,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        -- List of parsers to ignore installing (or "all")
        ignore_install = {},

        ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
        -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

        highlight = {
          enable = true,

          -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
          -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
          -- the name of the parser)
          -- list of language that will be disabled
          disable = { "c", "rust" },
          -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
      }
    end,
  },

  -- Highlight & search todos
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup()
    end,
  },

  -- UI based search/replace
  {
    "VonHeikemen/searchbox.nvim",
    dependencies = {
      { "MunifTanjim/nui.nvim" },
    },
    config = function()
      require("searchbox").setup()
    end,
  },

  -- Indentation guides
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup()
    end,
  },

  -- camel case or snake case motion
  {
    "chaoren/vim-wordmotion",
    config = function()
    end,
  },

  -- Highlight git changes in statuscol
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Show current code context
  {
    "SmiteshP/nvim-navic",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("nvim-navic").setup()
    end,
  },

  -- Statusline built on navic to show the current code context
  {
    "utilyre/barbecue.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    config = function()
      require("barbecue").setup()
    end,
  },

  -- Autopairs
  {
    "echasnovski/mini.pairs",
    version = false,
    config = function()
      require("mini.pairs").setup()
    end,
  },

  -- Search & replace
  {
    "windwp/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim", "BurntSushi/ripgrep" },
    config = function()
      require("spectre").setup()
    end,
  },

  -- Keybindings configuration / visualisation
  -- Note: Keybindings are configured in keybindings.lua for better self-documentation
  {
    "folke/which-key.nvim"
  },

  -- Git control ui
  {
    "kdheepak/lazygit.nvim"
  },
  -- Git blame
  {
    "f-person/git-blame.nvim"
  },

  -- Hover
  {
    "lewis6991/hover.nvim",
    config = function()
      require("hover").setup({
        init = function()
          -- Require providers
          require("hover.providers.lsp")
          require('hover.providers.jira')
        end,
        preview_opts = {
          border = nil
        },
        -- Whether the contents of a currently open hover window should be moved
        -- to a :h preview-window when pressing the hover keymap.
        preview_window = false,
        title = true
      })
    end
  },

  -- Last place to remember sessions
  {
    "ethanholz/nvim-lastplace",
    config = function()
      require('nvim-lastplace').setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
        lastplace_open_folds = true
      })
    end
  },

  -- Vue
  { "posva/vim-vue" },

  -- Go
  {
    "crispgm/nvim-go",
    config = function()
      require('go').setup({
        -- notify: use nvim-notify
        notify = true,
        -- auto commands
        auto_format = true,
        auto_lint = false,
        -- linters: revive, errcheck, staticcheck, golangci-lint
        linter = 'revive',
        -- linter_flags: e.g., {revive = {'-config', '/path/to/config.yml'}}
        linter_flags = {},
        -- lint_prompt_style: qf (quickfix), vt (virtual text)
        lint_prompt_style = 'qf',
        -- formatter: goimports, gofmt, gofumpt, lsp
        formatter = 'goimports',
        -- maintain cursor position after formatting loaded buffer
        maintain_cursor_pos = false,
        -- test flags: -count=1 will disable cache
        test_flags = { '-v' },
        test_timeout = '30s',
        test_env = {},
        -- show test result with popup window
        test_popup = true,
        test_popup_auto_leave = false,
        test_popup_width = 80,
        test_popup_height = 10,
        -- test open
        test_open_cmd = 'edit',
        -- struct tags
        tags_name = 'json',
        tags_options = { 'json=omitempty' },
        tags_transform = 'snakecase',
        tags_flags = { '-skip-unexported' },
        -- quick type
        quick_type_flags = { '--just-types' },
      })
    end
  },

  -- multi cursor
  {
    'mg979/vim-visual-multi'
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    version = '0.1.6',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('telescope').setup({
        defaults = {
          file_ignore_patterns = {
            "node_modules",
            "gen",
            "\\.g\\e*"
          }
        }
      })
    end
  },

  -- Error diagnostic
  {
    "glepnir/lspsaga.nvim",
    -- event = "LspAttach",
    after = "nvim-lspconfig",
    config = function()
      require("lspsaga").setup({})
    end,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    }
  },

  -- Flutter
  { "dart-lang/dart-vim-plugin" },

  {
    "akinsho/flutter-tools.nvim",
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim',
    },
    config = function()
      require("flutter-tools").setup({
        debugger = {
          enabled = true,
          run_via_dap = false,
        },
        decorations = {
          statusline = {
            device = true,
          }
        },
        widget_guies = {
          enabled = true,
        },
        closing_tags = {
          highlight = "Comment",
          prefix = "> ",
          enabled = true,
        },
      })
    end
  },

  -- CoC
  -- {
  --   'neoclide/coc.nvim',
  --   branch = 'release',
  -- },

  { "kevinhwang91/promise-async" },

  -- Status line / bottom bar
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "mortepau/codicons.nvim" },
    options = {
      theme = 'seoul256'
    },
    config = function()
      require("lualine").setup({})
    end,
  },


  -- Theme
  {
    "tiagovla/tokyodark.nvim",
    opts = {
      -- custom options here
    },
    config = function(_, opts)
      require("tokyodark").setup(opts) -- calling setup is optional
      vim.cmd 'colorscheme tokyodark'
    end,
  },

  -- Dashboard config
  {
    'MaximilianLloyd/ascii.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim'
    }
  },

  -- Rainbow backets
  {
    'hiphish/rainbow-delimiters.nvim',
    config = function()
      -- lvim.builtin.treesitter.rainbow.enable = true;
      require('rainbow-delimiters.setup').setup {
        strategy = {
          [''] = require('rainbow-delimiters').strategy['global'],
          vim = require('rainbow-delimiters').strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        priority = {
          [''] = 110,
          lua = 210,
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      }
    end
  },

  -- Codeium AI suggestions
  {
    "Exafunction/codeium.vim",
    event = 'BufEnter',
    config = function()
    end
  },

  -- DB Management
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod',                     lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
    }
  },

  -- Discord presence
  {
    'andweeb/presence.nvim',
    config = function()
      require("presence").setup {
        -- General options
        auto_update         = true,                 -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
        neovim_image_text   = "Vimming",            -- Text displayed when hovered over the Neovim image
        main_image          = "neovim",             -- Main image display (either "neovim" or "file")
        client_id           = "793271441293967371", -- Use your own Discord application client id (not recommended)
        log_level           = nil,                  -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
        debounce_timeout    = 10,                   -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
        enable_line_number  = false,                -- Displays the current line number instead of the current project
        blacklist           = {},                   -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
        buttons             = true,                 -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
        file_assets         = {},                   -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
        show_time           = true,                 -- Show the timer

        -- Rich Presence text options
        editing_text        = "Editing %s",         -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
        file_explorer_text  = "Browsing %s",        -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
        git_commit_text     = "Committing changes", -- Format string rendered when committing changes in git (either string or function(filename: string): string)
        plugin_manager_text = "Managing plugins",   -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
        reading_text        = "Reading %s",         -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
        workspace_text      = "Working on %s",      -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
        line_number_text    = "Line %s out of %s",  -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
      }
    end
  }
}
