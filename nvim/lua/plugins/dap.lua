return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "leoluz/nvim-dap-go",
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: step into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug: step out" },
      {
        "<F2>",
        function()
          require("dap").terminate()
          require("dapui").close()
        end,
        desc = "Debug: stop",
      },
      { "<F6>", function() require("dap").repl.open() end, desc = "Debug: open REPL" },
      { "<F7>", function() require("dap").run_to_cursor() end, desc = "Debug: run to cursor" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: toggle breakpoint" },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Debug: conditional breakpoint",
      },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: toggle UI" },
    },
    config = function()
      local dap = require("dap")

      require("dapui").setup()
      require("nvim-dap-virtual-text").setup()
      require("dap-go").setup()

      dap.listeners.before.attach.dapui_config = function()
        require("dapui").open()
      end
      dap.listeners.before.launch.dapui_config = function()
        require("dapui").open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        require("dapui").close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        require("dapui").close()
      end

      local group = vim.api.nvim_create_augroup("dotfiles_dap_go", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "go",
        callback = function(ev)
          vim.keymap.set("n", "<localleader>gm", function()
            require("dap-go").debug_test()
          end, { buffer = ev.buf, desc = "Debug nearest Go test" })
        end,
      })
    end,
  },
}
