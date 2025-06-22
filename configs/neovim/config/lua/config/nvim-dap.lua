local dap = require('dap')

local dapui = require("dapui")

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    -- 💀 Make sure to update this path to point to your installation
    args = {"/path/to/js-debug/src/dapDebugServer.js", "${port}"},
  }
}

dap.configurations.javascript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
  },
}
-- dap.adapters.node = {
--   type = "executable",
--   command = "node",
--   args = {
--     os.getenv("HOME") .. "/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
--     "--port=8123"  -- Auto-select a free port
--   }
-- }

dap.configurations.typescript = {
  {
    type = "node",
    request = "launch",
    name = "Debug TS File",
    program = "${file}",
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal",
    outFiles = { "${workspaceFolder}/dist/**/*.js" },
    skipFiles = { "<node_internals>/**" },
    trace = true,
    runtimeExecutable = "node",
    runtimeArgs = {
      "--inspect-brk",
      "--preserve-symlinks"  -- Important for some TypeScript setups
    },
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**"
    },
    smartStep = true,  -- Skip uninteresting code
    showAsyncStacks = true
  }
}
