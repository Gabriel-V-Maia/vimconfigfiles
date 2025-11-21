-- ========================
-- Base
-- ========================

vim.g.mapleader = " "
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
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
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
-- NvimTree
-- ========================

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  renderer = {
    icons = {
      show = { file = false, folder = false, folder_arrow = false, git = true },
      glyphs = {
        default = ".", symlink = ".", folder = { default = "~", open = "~>", empty = "~", empty_open = "~/", symlink = "." },
      },
    },
    group_empty = true,
  },
  filters = { dotfiles = false },
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")
    local opts = function(desc)
      return { desc = desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    
    --// coisas futuras
    vim.keymap.set("n", "a", api.fs.create, opts("Create File/Folder"))
    vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
    vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
    vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "<Tab>", api.node.open.preview, opts("Preview"))
    vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
    vim.keymap.set("n", "q", api.tree.close, opts("Close"))
  end,
})

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>t", ":NvimTreeFocus<CR>")

-- ========================
-- Terminal
-- ========================

vim.keymap.set("n", "<leader>th", function() vim.cmd("belowright split | terminal") end)
vim.keymap.set("n", "<leader>tv", function() vim.cmd("vsplit | terminal") end)

function _G.TerminalWidth(width)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "terminal" then
      vim.api.nvim_win_set_width(win, tonumber(width))
    end
  end
end

vim.api.nvim_create_user_command("TerminalWidth", function(opts) TerminalWidth(opts.args) end, { nargs = 1 })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })
vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], { noremap = true, silent = true })
vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], { noremap = true, silent = true })
vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], { noremap = true, silent = true })
vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], { noremap = true, silent = true })

-- ========================
-- Telescope
-- ========================

vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>lg", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")

-- ========================
-- Autocomplete (CMP + LuaSnip)
-- ========================

local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  completion = {
    autocomplete = {
      cmp.TriggerEvent.TextChanged,
      cmp.TriggerEvent.InsertEnter,
    },
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "nvim_lsp_signature_help" },  
  }),
})

-- ========================
-- LSP (Mason + vim.lsp.config)
-- ========================

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "pyright", "lua_ls", "html", "cssls", "ts_ls", "jdtls", "clangd" },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("pyright", { capabilities = capabilities, filetypes = { "python" } })
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  filetypes = { "lua" },
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
})
vim.lsp.config("html", { capabilities = capabilities, filetypes = { "html" } })
vim.lsp.config("cssls", { capabilities = capabilities, filetypes = { "css", "scss", "less" } })
vim.lsp.config("ts_ls", { capabilities = capabilities, filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" } })
vim.lsp.config("jdtls", { capabilities = capabilities, filetypes = { "java" } })
vim.lsp.config("clangd", { capabilities = capabilities, filetypes = { "c", "cpp" } })

vim.lsp.enable({ "pyright", "lua_ls", "html", "cssls", "ts_ls", "jdtls", "clangd" })


-- ========================
-- Wayland Clipboard
-- ========================

vim.opt.clipboard = "unnamedplus"

vim.g.clipboard = {
  name = "wl-clipboard",
  copy = {
    ["+"] = "wl-copy",
    ["*"] = "wl-copy",
  },
  paste = {
    ["+"] = "wl-paste",
    ["*"] = "wl-paste",
  },
  cache_enabled = 1,
}

-- ========================
-- Colorscheme
-- ========================

vim.cmd("colorscheme desert")
