-- Terminal configuration for Neovim
return {
  'nvim-lua/plenary.nvim', -- Using plenary as dependency to ensure proper plugin spec
  lazy = false,
  config = function()
    -- Function to toggle terminal
    local function toggle_terminal()
      -- Close any existing terminal buffers if they exist
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if buf_name:match 'term://' and vim.api.nvim_buf_is_loaded(buf) then
          local win_ids = vim.fn.win_findbuf(buf)
          if #win_ids > 0 then
            for _, win_id in ipairs(win_ids) do
              vim.api.nvim_win_close(win_id, true)
            end
            return
          end
        end
      end

      -- Split window horizontally with 20 lines height for terminal
      vim.cmd 'botright 20split'

      -- Open terminal in the new split
      vim.cmd 'terminal'

      -- Set the name of the buffer to something recognizable
      vim.api.nvim_buf_set_name(0, 'term://toggleterm')

      -- Go into insert mode automatically
      vim.cmd 'startinsert'

      -- Add a local mapping to easily close or hide the terminal
      vim.api.nvim_buf_set_keymap(0, 't', '<C-\\><C-n>', '<C-\\><C-n>', { noremap = true })
      vim.api.nvim_buf_set_keymap(0, 't', '<Esc><Esc>', '<C-\\><C-n>:q<CR>', { noremap = true, silent = true })
    end

    -- Create terminal keymaps
    vim.keymap.set('n', '<leader>tt', toggle_terminal, { desc = 'Toggle bottom terminal (20 lines)' })

    -- Add to which-key if it's available
    local ok, wk = pcall(require, 'which-key')
    if ok then
      wk.add {
        { '<leader>t', '[T]erminal' },
      }
    end
  end,
}
