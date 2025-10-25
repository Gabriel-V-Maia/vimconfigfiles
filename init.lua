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
-- Plugin manager: lazy.nvim
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

-- ========================
-- Plugins
-- ========================
require("lazy").setup({
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" }
})


-- ========================
-- File Tree (NvimTree)
-- ========================

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 35,
  },
  renderer = {
    icons = {
      show = {
        file = false,
        folder = false,
        folder_arrow = false,
        git = true,
      },
      glyphs = {
        default = ".",
        symlink = ".",
        folder = {
          default = "~",
          open = "~>",
          empty = "~",
          empty_open = "~/",
          symlink = ".",
        },
      },
    },
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- ========================
-- Terminal shit
-- ========================

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>th", function()
  vim.cmd("belowright split | terminal")
end, { desc = "Open terminal horizontal" })

vim.keymap.set("n", "<leader>tv", function()
  vim.cmd("vsplit | terminal")
end, { desc = "Open terminal vertical" })

function _G.TerminalWidth(width)
  local wins = vim.api.nvim_list_wins()
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "terminal" then
      vim.api.nvim_win_set_width(win, tonumber(width))
    end
  end
end

vim.api.nvim_create_user_command("TerminalWidth", function(opts)
  TerminalWidth(opts.args)
end, { nargs = 1 })

-- ========================
-- NvimTree keybinds 
-- ========================

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })

vim.keymap.set("n", "<leader>t", ":NvimTreeFocus<CR>", { desc = "Focus NvimTree" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "NvimTree",
  callback = function()
    local api = require("nvim-tree.api")
    vim.keymap.set("n", "n", api.fs.create, { buffer = true })
  end,
})


vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>lg", ":Telescope live_grep<CR>", { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "List Buffers" })



vim.cmd("colorscheme desert")
