local dap = require('dap')

dap.adapters.cppdbg = {
    type = 'executable',
    command = 'gdb', -- Path to gdb, usually just 'gdb' if it's in your PATH
    name = "cppdbg",
    -- The GDB executable requires the `mi` argument.
    options = {
        initializationCommands = { "-gdb-set mi-async on", "-gdb-set print thread-events off", "-gdb-set print inferior-events off" },
        consoleCommand = { "gdb" },
        workingDirectory = "${workspaceFolder}",
        commandFile = "${workspaceFolder}/.gdbinit",
    }
}

dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        setupCommands = {
            { text = '-enable-pretty-printing', description = 'enable pretty printing', ignoreFailures = false }
        },
    },
}

-- Optional: use the same configuration for C as well
dap.configurations.c = dap.configurations.cpp

-- Optional: Set up DAP UI (provides better visual feedback)
local dapui = require('dapui')
dapui.setup()

-- Optional: Automatically open DAP UI when starting a debugging session
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end



local dap_opts = { noremap = true, silent = true }

vim.keymap.set('n', '<F5>', require'dap'.continue, dap_opts)
vim.keymap.set('n', '<F10>', require'dap'.step_over, dap_opts)
vim.keymap.set('n', '<F11>', require'dap'.step_into, dap_opts)
vim.keymap.set('n', '<F12>', require'dap'.step_out, dap_opts)
vim.keymap.set('n', '<leader>b', require'dap'.toggle_breakpoint, dap_opts)
vim.keymap.set('n', '<leader>B', function()
    require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, dap_opts)
vim.keymap.set('n', '<leader>lp', function()
    require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
end, dap_opts)
vim.keymap.set('n', '<leader>dr', require'dap'.repl.open, dap_opts)
vim.keymap.set('n', '<leader>dl', require'dap'.run_last, dap_opts)
