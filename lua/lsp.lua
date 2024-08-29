
-- Mason configuration
require('mason').setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require('mason-lspconfig').setup({
    ensure_installed = { 'pylsp', 'lua_ls', 'rust_analyzer', 'clangd' },
})


-- Set different settings for different languages' LSP
local lspconfig = require('lspconfig')

-- Customized on_attach function
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    -- vim.keymap.set('n', 'ge', vim.lsp.diagnostic.show_line_diagnostics, bufopts) -- seems not to work
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<space>f", function()
        vim.lsp.buf.format({ async = true })
    end, bufopts)

    -- Format on save
    if client.server_capabilities.documentFormattingProvider then
        vim.cmd([[
            augroup LspAutocommands
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = true })
            augroup END
        ]])
    end
end

-- Configure pylsp for Python with black formatter
lspconfig.pylsp.setup({
    on_attach = on_attach,
    settings = {
        pylsp = {
            plugins = {
                black = {
                    enabled = true,
                    line_length = 88,
                },
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
            },
        },
    },
})

lspconfig.clangd.setup({
    on_attach = on_attach,
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cppm" },
    root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
})

-- treesitter stuff

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "cpp" },
  highlight = {
    enable = true,
  },
  refactor = {
    highlight_definitions = {
      enable = true,
    },
    highlight_current_scope = {
      enable = true,
    },
  },
}
