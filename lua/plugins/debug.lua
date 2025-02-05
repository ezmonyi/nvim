return {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      dependencies = {
        "nvim-neotest/nvim-nio"
      }
    },
    'jay-babu/mason-nvim-dap.nvim',
  },
  config = function()
    require("dapui").setup({
      layouts = { {
        elements = {
          {
            id = "scopes",
            size = 0.8
          },
          {
            id = "stacks",
            size = 0.1
          },
          {
            id = "breakpoints",
            size = 0.1
          },
        },
        position = "left",
        size = 40
      }, {
          elements = {
            {
              id = "console",
              size = 1
            }
          },
          position = "bottom",
          size = 10
        } },
    })

    local dap, dapui = require("dap"), require("dapui")

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
    end
    dap.listeners.before.event_exited.dapui_config = function()
    end

    require("dap.ext.vscode").load_launchjs()

    vim.keymap.set("n", "<F1>", dap.continue)
    vim.keymap.set("n", "<F2>", dap.step_over)
    vim.keymap.set("n", "<F3>", dap.step_into)
    vim.keymap.set("n", "<F4>", dap.step_out)
    vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint)
    vim.keymap.set("n", "<Leader>dq", dapui.close)
    vim.keymap.set("n", "<Leader>dc", dap.clear_breakpoints)
    vim.keymap.set("n", "<Leader>ds", dap.disconnect)
    vim.fn.sign_define('DapBreakpoint', {
      text = '⬤',
      texthl = 'ErrorMsg',
      linehl = '',
      numhl = 'ErrorMsg'
    })

    vim.fn.sign_define('DapBreakpointCondition', {
      text = '⬤',
      texthl = 'ErrorMsg',
      linehl = '',
      numhl = 'SpellBad'
    })

    local pythonEnv = require('utils.python_env')
    local masonpath = vim.fn.stdpath('data') .. '/mason'
    dap.adapters.python = {
      type = 'executable',
      command = masonpath .. '/packages/debugpy/venv/' .. pythonEnv.getVenvSuffix(),
      args = { '-m', 'debugpy.adapter' },
      options = {
        detached = true,
      },
    }

    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        justMyCode = false,
        program = '${file}',
        cwd = vim.fn.getcwd(),
        pythonPath = pythonEnv.getPythonEnv,
      },
      {
        type = 'python';
        request = 'launch';
        name = 'Launch file with arguments';
        justMyCode = false,
        program = '${file}';
        args = function()
          local args_string = vim.fn.input('Arguments: ')
          return vim.split(args_string, " +")
        end;
        pythonPath = pythonEnv.getPythonEnv
      },
    }

  end,
}
