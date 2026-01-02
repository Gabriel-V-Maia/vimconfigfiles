return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  config = function()
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
      filters = {
        dotfiles = false,
      },
      actions = {
        open_file = {
          quit_on_open = false,
        },
      },
      on_attach = function(bufnr)
        local api = require('nvim-tree.api')
        
        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        
        api.config.mappings.default_on_attach(bufnr)
        
        vim.keymap.set('n', '<CR>', function()
          local node = api.tree.get_node_under_cursor()
          if node.type == 'file' then
            vim.cmd('badd ' .. node.absolute_path)
            local new_buf = vim.fn.bufnr(node.absolute_path)
            vim.api.nvim_set_current_buf(new_buf)
          else
            api.node.open.edit()
          end
        end, opts('Open in new buffer'))
      end,
    })
    vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
  end,
}
