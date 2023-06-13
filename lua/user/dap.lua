local M = {
  "mfussenegger/nvim-dap",
  commit = "6b12294a57001d994022df8acbe2ef7327d30587",
  event = "VeryLazy",
}

function M.config()
  local dap = require "dap"

  local dap_ui_status_ok, dapui = pcall(require, "dapui")
  if not dap_ui_status_ok then
    return
  end

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end

  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end

  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end

  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      -- provide the absolute path for `codelldb` command if not using the one installed using `mason.nvim`
      command = "codelldb",
      args = { "--port", "${port}" },
      -- On windows you may have to uncomment this:
      -- detached = false,
    },
  }
  dap.configurations.c = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        local path
        vim.ui.input({ prompt = "Path to executable: ", default = vim.loop.cwd() .. "/build/" }, function(input)
          path = input
        end)
        vim.cmd [[redraw]]
        return path
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    },
  }

  -- PHP
  local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
  dap.adapters.php = {
  	type = "executable",
  	command = "node",
  	args = { mason_path .. "packages/php-debug-adapter/extension/out/phpDebug.js" },
  }
  dap.configurations.php = {
    {
      name = "Listen for Xdebug",
  		type = "php",
  		request = "launch",
  		port = 9003,

      -- look up how to configure these
      serverSourceRoot = 'localhost',
      localSourceRoot = 'C:/xampp/htdocs/',
     -- serverSourceRoot = vim.fn.expand("%:p:h").."/",
     -- localSourceRoot = vim.fn.expand("%:p:h").."/",
    },
    -- {
    --   name = "Debug currently open script",
  		-- type = "php",
  		-- request = "launch",
  		-- port = 9003,
    --   cwd = "${fileDirname}",
    --   program = "${file}",
    --   runtimeExecutable = "php",
    -- },
  }
end

M = {
  "ravenxrz/DAPInstall.nvim",
  commit = "8798b4c36d33723e7bba6ed6e2c202f84bb300de",
  lazy = true,
  config = function()
    require("dap_install").setup {}
    require("dap_install").config("python", {})
  end,
}

return M
