local DEBUGGER_PATH = vim.fn.stdpath "data" .. "/lazy/js-debug/src/dapDebugServer.js"

local M = {}
function M.setup()
    local dap = require("dap")
    local utils = require("dap.utils")
    dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
            command = "node",
            -- 💀 Make sure to update this path to point to your installation
            args = { DEBUGGER_PATH, "${port}" },
        }
    }

    dap.configurations.javascript = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch JS file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            skipFiles = {
                "<node_internals>/**",                -- Skip Node core
                "${workspaceFolder}/node_modules/**", -- Skip project's node_modules
            }
        }
    }
    dap.configurations.typescript = {
        {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch Current File (Typescript)',
            cwd = "${workspaceFolder}",
            runtimeArgs = { '-r', 'ts-node/register' },
            program = "${file}",
            runtimeExecutable = 'node',
            sourceMaps = true,
            protocol = 'inspector',
            skipFiles = {
                "<node_internals>/**",                -- Skip Node core
                "${workspaceFolder}/node_modules/**", -- Skip project's node_modules
            },
            resolveSourceMapLocations = {
                "${workspaceFolder}/**",
                "!**/node_modules/**",
            },
        },
    }
end

return M
