-- Enhanced buffer navigation
return {
  name = 'buffer-navigation',
  dir = vim.fn.stdpath('config'),
  event = 'VeryLazy',
  config = function()
    -- Function to get a list of valid listed buffers
    local function get_valid_buffers()
      local buffers = {}
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
          table.insert(buffers, buf)
        end
      end
      return buffers
    end

    -- Function to switch to next buffer
    local function next_buffer()
      local buffers = get_valid_buffers()
      if #buffers <= 1 then
        return
      end

      local current_buf = vim.api.nvim_get_current_buf()
      local current_index = 1

      for i, buf in ipairs(buffers) do
        if buf == current_buf then
          current_index = i
          break
        end
      end

      local next_index = current_index + 1
      if next_index > #buffers then
        next_index = 1
      end

      vim.api.nvim_set_current_buf(buffers[next_index])
    end

    -- Function to switch to previous buffer
    local function prev_buffer()
      local buffers = get_valid_buffers()
      if #buffers <= 1 then
        return
      end

      local current_buf = vim.api.nvim_get_current_buf()
      local current_index = 1

      for i, buf in ipairs(buffers) do
        if buf == current_buf then
          current_index = i
          break
        end
      end

      local prev_index = current_index - 1
      if prev_index < 1 then
        prev_index = #buffers
      end

      vim.api.nvim_set_current_buf(buffers[prev_index])
    end

    -- Function to close current buffer and switch to previous one
    local function close_buffer()
      local buffers = get_valid_buffers()
      if #buffers <= 1 then
        vim.cmd 'bd'
        return
      end

      local current_buf = vim.api.nvim_get_current_buf()

      -- Switch to next buffer before closing current one
      next_buffer()

      -- Close the previous buffer
      vim.api.nvim_buf_delete(current_buf, { force = false })
    end

    -- Alternative buffer switching (like Ctrl+6 but more reliable)
    local function alternate_buffer()
      local alt_buf = vim.fn.bufnr '#'
      if alt_buf ~= -1 and vim.api.nvim_buf_is_loaded(alt_buf) then
        vim.api.nvim_set_current_buf(alt_buf)
      else
        -- If no alternate buffer, just switch to previous in list
        prev_buffer()
      end
    end

    -- Key mappings for buffer navigation
    vim.keymap.set('n', ']b', next_buffer, { desc = 'Next buffer' })
    vim.keymap.set('n', '[b', prev_buffer, { desc = 'Previous buffer' })
    vim.keymap.set('n', '<leader>bd', close_buffer, { desc = '[B]uffer [D]elete' })
    vim.keymap.set('n', '<leader>ba', alternate_buffer, { desc = '[B]uffer [A]lternate' })

    -- Tab for next buffer, Shift+Tab for previous (common in many editors)
    vim.keymap.set('n', '<Tab>', next_buffer, { desc = 'Next buffer' })
    vim.keymap.set('n', '<S-Tab>', prev_buffer, { desc = 'Previous buffer' })

    -- Alternative mappings that are similar to tmux/vim splits
    vim.keymap.set('n', '<C-n>', next_buffer, { desc = 'Next buffer' })
    vim.keymap.set('n', '<C-p>', prev_buffer, { desc = 'Previous buffer' })

    -- Fix the Ctrl+6 issue by remapping it explicitly
    vim.keymap.set('n', '<C-6>', alternate_buffer, { desc = 'Alternate buffer' })
    vim.keymap.set('n', '<C-^>', alternate_buffer, { desc = 'Alternate buffer' })

    -- Quick buffer switching by number (1-9)
    for i = 1, 9 do
      vim.keymap.set('n', '<leader>' .. i, function()
        local buffers = get_valid_buffers()
        if buffers[i] then
          vim.api.nvim_set_current_buf(buffers[i])
        end
      end, { desc = 'Switch to buffer ' .. i })
    end

    -- Add to which-key if available
    local ok, wk = pcall(require, 'which-key')
    if ok then
      wk.add {
        { '<leader>b', group = '[B]uffer' },
        { '<leader>bd', desc = '[B]uffer [D]elete' },
        { '<leader>ba', desc = '[B]uffer [A]lternate' },
        { ']b', desc = 'Next buffer' },
        { '[b', desc = 'Previous buffer' },
        { '<Tab>', desc = 'Next buffer' },
        { '<S-Tab>', desc = 'Previous buffer' },
        { '<C-n>', desc = 'Next buffer' },
        { '<C-p>', desc = 'Previous buffer' },
        -- Add numbered buffer switches to which-key
        { '<leader>1', desc = 'Buffer 1' },
        { '<leader>2', desc = 'Buffer 2' },
        { '<leader>3', desc = 'Buffer 3' },
        { '<leader>4', desc = 'Buffer 4' },
        { '<leader>5', desc = 'Buffer 5' },
        { '<leader>6', desc = 'Buffer 6' },
        { '<leader>7', desc = 'Buffer 7' },
        { '<leader>8', desc = 'Buffer 8' },
        { '<leader>9', desc = 'Buffer 9' },
      }
    end

    -- Show buffer info in statusline (if you want to see buffer numbers)
    -- This is optional and works with mini.statusline
    local function enhance_statusline()
      local ok_mini, mini_statusline = pcall(require, 'mini.statusline')
      if ok_mini then
        -- Add buffer number to statusline
        local original_section_location = mini_statusline.section_location
        mini_statusline.section_location = function()
          local buf_nr = vim.api.nvim_get_current_buf()
          local buffers = get_valid_buffers()
          local buf_index = 1

          for i, buf in ipairs(buffers) do
            if buf == buf_nr then
              buf_index = i
              break
            end
          end

          return string.format('[%d/%d] %s', buf_index, #buffers, original_section_location())
        end
      end
    end

    -- Enhance statusline after a short delay to ensure mini.statusline is loaded
    vim.defer_fn(enhance_statusline, 100)
  end,
}
