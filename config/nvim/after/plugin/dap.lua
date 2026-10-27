local dap = require("dap")
local dapui = require("dapui")

dapui.setup()
require("nvim-dap-virtual-text").setup({})

require("dap-go").setup({
  dlv_path = function()
    local mason_dlv = vim.fn.stdpath("data") .. "/mason/bin/dlv"
    return vim.fn.executable(mason_dlv) == 1 and mason_dlv or "dlv"
  end,
})

dap.listeners.before.attach.dapui_config = dapui.open
dap.listeners.before.launch.dapui_config = dapui.open
dap.listeners.before.event_terminated.dapui_config = dapui.close
dap.listeners.before.event_exited.dapui_config = dapui.close

local function map(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { desc = "Debug: " .. desc })
end

map("<F5>", dap.continue, "continue")
map("<F10>", dap.step_over, "step over")
map("<F11>", dap.step_into, "step into")
map("<F12>", dap.step_out, "step out")
map("<F2>", function()
  dap.terminate()
  dapui.close()
end, "stop")
map("<F6>", dap.repl.open, "open REPL")
map("<F7>", dap.run_to_cursor, "run to cursor")
map("<leader>db", dap.toggle_breakpoint, "toggle breakpoint")
map("<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "conditional breakpoint")
map("<leader>du", dapui.toggle, "toggle UI")
-- <leader>td (debug Go test) is set in after/ftplugin/go.lua
