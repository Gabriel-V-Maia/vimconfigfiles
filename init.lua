
-- ========================
-- Base
-- ========================

vim.g.mapleader = " "
vim.g.have_nerd_font = false

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.mouse = "a"

vim.opt.signcolumn = "yes"
vim.opt.showmode = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.laststatus = 3

-- ========================
-- Lazy.nvim
-- ========================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- UI
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "akinsho/bufferline.nvim", version = "*" },

  -- Core
  { "nvim-tree/nvim-tree.lua" },
  { "nvim-lualine/lualine.nvim" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- LSP / Completion
  { "williamboman/mason.nvim", build = ":MasonUpdate" },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lsp-signature-help" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
})

-- ========================
-- Theme (Dark)
-- ========================

require("catppuccin").setup({
  flavour = "mocha",
  integrations = {
    bufferline = true,
    lualine = true,
    nvimtree = true,
    telescope = true,
    cmp = true,
    treesitter = true,
  },
})

vim.cmd.colorscheme("catppuccin")

-- ========================
-- Bufferline (Tabs, sem ícones)
-- ========================

require("bufferline").setup({
  options = {
    mode = "buffers",
    diagnostics = false,
    show_buffer_icons = false,
    show_buffer_close_icons = false,
    show_close_icon = false,
    separator_style = "slant",
    always_show_bufferline = true,
  },
})

vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>")
vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>")

-- ========================
-- Lualine (sem ícones)
-- ========================

require("lualine").setup({
  options = {
    theme = "catppuccin",
    icons_enabled = false,
    section_separators = "",
    component_separators = "",
    globalstatus = true,
  },
})

-- ========================
-- NvimTree (sem ícones)
-- ========================

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  renderer = {
    group_empty = true,
    icons = {
      show = {
        file = false,
        folder = false,
        folder_arrow = false,
        git = false,
      },
    },
  },
  filters = { dotfiles = false },
})

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>t", ":NvimTreeFocus<CR>")

-- ========================
-- Terminal
-- ========================

vim.keymap.set("n", "<leader>th", function() vim.cmd("belowright split | terminal") end)
vim.keymap.set("n", "<leader>tv", function() vim.cmd("vsplit | terminal") end)

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]])
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]])
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]])
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]])

-- ========================
-- Telescope (sem ícones)
-- ========================

require("telescope").setup({
  defaults = {
    prompt_prefix = "> ",
    selection_caret = "> ",
  },
})

vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>lg", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")

-- ========================
-- CMP + LuaSnip
-- ========================

local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "nvim_lsp_signature_help" },
  },
})

-- ========================
-- LSP
-- ========================

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "pyright",
    "lua_ls",
    "html",
    "cssls",
    "ts_ls",
    "jdtls",
    "clangd",
  },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
})

vim.lsp.enable({
  "lua_ls",
  "pyright",
  "html",
  "cssls",
  "ts_ls",
  "jdtls",
  "clangd",
})

-- ========================
-- Clipboard (Wayland)
-- ========================

vim.opt.clipboard = "unnamedplus"
vim.g.clipboard = {
  name = "wl-clipboard",
  copy = { ["+"] = "wl-copy", ["*"] = "wl-copy" },
  paste = { ["+"] = "wl-paste", ["*"] = "wl-paste" },
  cache_enabled = 1,
}


