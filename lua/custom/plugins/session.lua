-- Auto session management
return {
  'rmagatti/auto-session',
  lazy = false,
  init = function()
    -- Add session group to which-key
    local ok, wk = pcall(require, 'which-key')
    if ok then
      wk.register {
        ['<leader>S'] = { name = '[S]ession', _ = 'which_key_ignore' },
      }
    end
  end,
  opts = {
    log_level = 'error',
    auto_session_enable_last_session = true,
    auto_session_root_dir = vim.fn.stdpath 'data' .. '/sessions/',
    auto_session_enabled = true,
    auto_save_enabled = true,
    auto_restore_enabled = true,
    auto_session_use_git_branch = true,
    -- Don't save these items in the session
    auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
    -- Skip saving certain file types
    auto_session_allowed_dirs = nil,

    -- Skip saving if the buffer list only contains certain filetypes
    -- This helps avoid auto-session saving for the file explorer
    pre_save_cmds = {
      function()
        -- Get list of buffer filetypes
        local bufs = vim.api.nvim_list_bufs()
        local filetypes = {}
        local valid_buffers = 0

        -- Check each buffer and its filetype
        for _, bufnr in ipairs(bufs) do
          if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_get_option(bufnr, 'buflisted') then
            valid_buffers = valid_buffers + 1
            local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
            filetypes[ft] = (filetypes[ft] or 0) + 1
          end
        end

        -- Skip saving session if only neo-tree buffers are open
        if (filetypes['neo-tree'] and valid_buffers == filetypes['neo-tree']) or valid_buffers == 0 then
          return false -- Returning false prevents session saving
        end

        return true
      end,
    },
  },
  keys = {
    -- Add key mappings for manual session management
    { '<leader>Ss', '<cmd>SessionSave<CR>', desc = 'Save Session' },
    { '<leader>Sl', '<cmd>SessionRestore<CR>', desc = 'Load Session' },
    { '<leader>Sd', '<cmd>SessionDelete<CR>', desc = 'Delete Session' },
  },
}
