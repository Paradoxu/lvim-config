-- local DEBUGGER_PATH = "/Users/leandro/.config/dap/js-debug/src"
local DEBUGGER_PATH = "/Users/leandro/.local/share/lunarvim/site/pack/lazy/opt/vscode-js-debug"

local M = {}

M.js_based_languages = {
  "typescript",
  "javascript",
  "typescriptreact",
  "javascriptreact",
  "vue"
}

function M.setup()
  local dap = require("dap")

  require("dap-vscode-js").setup {
    node_path = "node",
    debugger_path = DEBUGGER_PATH,
    adapters = { 'chrome', 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost', 'node', 'chrome' }, -- which adapters to register in nvim-dap
  }

  for _, language in ipairs(M.js_based_languages) do
    dap.configurations[language] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach",
        processId = require('dap.utils').pick_process,
        skipFiles = { '<node_internals>/**', 'node_modules/**' },
        cwd = "${workspaceFolder}",
        sourceMaps = true,
      },
      {
        name = 'Launch',
        type = 'pwa-node',
        request = 'launch',
        program = '${file}',
        rootPath = '${workspaceFolder}',
        cwd = '${workspaceFolder}',
        sourceMaps = true,
        skipFiles = { '<node_internals>/**' },
        protocol = 'inspector',
        console = 'integratedTerminal',
      },
      {
        type = "pwa-chrome",
        request = "launch",
        name = "Launch & Debug chrome",
        url = function()
          local co = coroutine.running()
          return coroutine.create(function()
            vim.ui.input({
              prompt = "Enter url",
              default = "http://localhost:3000",
            }, function(url)
              if url == nil or url == "" then
                return
              else
                coroutine.resume(co, url)
              end
            end)
          end)
        end,
        webRoot = "${workspaceFolder}",
        userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir"
      },
      -- Divider for launch.js derived configs
      {
        name = "--- ⬇️  launch.json configs ⬇️ ---",
        type = "",
        request = "launch"
      },
    }
  end
end

return M
