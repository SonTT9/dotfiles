-- vim: set foldmethod=marker:

-- Options {{{

vim.opt.number = true          -- Show line numbers
vim.opt.cursorline = true      -- highlight cursor line underneath the cursor horizontally
vim.opt.splitbelow = true      -- open new vertical split bottom
vim.opt.splitright = true      -- open new horizontal splits right
vim.opt.scrolloff = 8          -- Keep lines above and below cursor

vim.opt.smartindent = true     -- Auto indent new lines
vim.opt.expandtab = true       -- Use spaces instead of tabs
vim.opt.shiftwidth = 2         -- Shift 2 spaces when tab
vim.opt.softtabstop = 2
vim.opt.tabstop = 2            -- 1 tab = 2 spaces

vim.opt.backup = false         -- Do not create backup files
vim.opt.writebackup = false    -- Do not create backup files before writing
vim.opt.swapfile = false       -- Do not create swap files
vim.opt.undofile = true        -- Enable persistent undo
vim.opt.undodir = vim.fn.expand('~/.config/nvim/undo')  -- Set undo directory
vim.cmd('silent !mkdir -p ~/.config/nvim/undo') -- Ensure the undo directory exists

vim.opt.incsearch = true            -- search as characters are entered
vim.opt.hlsearch = true            -- do not highlight matches
vim.opt.ignorecase = true           -- ignore case in searches by default
vim.opt.smartcase = true            -- but make it case sensitive if an uppercase is entered

vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8 


-- }}}

-- Keymaps {{{

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- buffers
vim.keymap.set("n", "<leader>n", ":bn<cr>")
vim.keymap.set("n", "<leader>p", ":bp<cr>")
vim.keymap.set("n", "<leader>x", ":bd<cr>")

-- }}}

-- Plugins {{{

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  { "EdenEast/nightfox.nvim" },
  { "crusoexia/vim-monokai" },

  { 'nvim-telescope/telescope.nvim', tag = '0.1.8', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- nvim-tree and its dependencies
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    config = function()
      require("nvim-tree").setup {
        view = {
          width = 30,
          side = 'left'
        },
        git = {
          enable = true,
        },
        diagnostics = {
          enable = true,
          show_on_dirs = true,
        },
        update_focused_file = {
          enable = true,
          update_cwd = true,
        },
        filters = {
          dotfiles = false,
        },
      }
    end,
  },
})

-- vim.cmd("colorscheme dayfox")
vim.cmd("colorscheme monokai")

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.keymap.set('n', '<leader>e', ":NvimTreeFindFile<cr>")
