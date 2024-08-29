local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- LSP manager
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",
    "ahmedkhalf/project.nvim",
      'psf/black', -- optional if you want to manage black with lazy.nvim
      {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
      },
    {
        'numToStr/Comment.nvim',
        opts = {
            -- add any options here
        }
    },
    {
        'nvim-neotest/nvim-nio',
        config = function()

        end
    },
    
    {
      "roobert/search-replace.nvim",
      config = function()
        require("search-replace").setup({
          -- optionally override defaults
          default_replace_single_buffer_options = "gcI",
          default_replace_multi_buffer_options = "egcI",
        })
      end,
    },
	{
		"onsails/lspkind.nvim",
		event = { "VimEnter" },
	},
    {
      "lervag/vimtex",
      lazy = false,     -- we don't want to lazy load VimTeX
      -- tag = "v2.15", -- uncomment to pin to a specific release
      init = function()
        -- VimTeX configuration goes here, e.g.
        vim.g.vimtex_view_method = "zathura"
      end
    },
    {
        'github/copilot.vim',
        config = function()
            -- Optional configuration settings for Copilot
            -- vim.g.copilot_no_tab_map = true
            vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
        end
    },
	-- Auto-completion engine
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"lspkind.nvim",
			"hrsh7th/cmp-nvim-lsp", -- lsp auto-completion
			"hrsh7th/cmp-buffer", -- buffer auto-completion
			"hrsh7th/cmp-path", -- path auto-completion
			"hrsh7th/cmp-cmdline", -- cmdline auto-completion
		},
		config = function()
			require("config.nvim-cmp")
		end,
	},
	-- Code snippet engine
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
	},
    -- theme
    "tanvirtin/monokai.nvim",
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
    -- or                              , branch = '0.1.x',
          dependencies = { 'nvim-lua/plenary.nvim' },
          config = function() 
              require("config.nvim-telescope")
          end,
    },
    -- venv selector
    {
        'linux-cultist/venv-selector.nvim', branch = 'regexp',
        dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap-python' },
        opts = {
            -- Your options go here
            -- name = "venv",
            -- auto_refresh = false
          },
          event = 'VeryLazy', -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
          keys = {
            -- Keymap to open VenvSelector to pick a venv.
            { '<leader>vs', '<cmd>VenvSelect<cr>' },
            -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
            { '<leader>vc', '<cmd>VenvSelectCached<cr>' },
          },
    },

    -- C/C++ Specific Plugins
    'nvim-lua/plenary.nvim', -- Useful Lua functions used by lots of plugins
    'mfussenegger/nvim-dap', -- Debug Adapter Protocol client
    'rcarriga/nvim-dap-ui', -- UI for nvim-dap
    'theHamsta/nvim-dap-virtual-text', -- Virtual text for nvim-dap
    'nvim-telescope/telescope.nvim', -- Fuzzy finder and more
    'nvim-telescope/telescope-dap.nvim', -- DAP integration with Telescope

    -- Git integration
    'tpope/vim-fugitive', -- Git integration
    'lewis6991/gitsigns.nvim', -- Git signs


    'nvim-lualine/lualine.nvim', -- Statusline
})
