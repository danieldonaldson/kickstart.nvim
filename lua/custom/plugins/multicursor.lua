return {
  'jake-stewart/multicursor.nvim',
  branch = '1.0',
  config = function()
    local mc = require 'multicursor-nvim'
    mc.setup()

    local set = vim.keymap.set

    -- Add or skip cursor above/below the main cursor.
    set({ 'n', 'x' }, '<up>', function()
      mc.lineAddCursor(-1)
    end, { desc = 'Add cursor above' })

    set({ 'n', 'x' }, '<down>', function()
      mc.lineAddCursor(1)
    end, { desc = 'Add cursor below' })

    set({ 'n', 'x' }, '<leader><up>', function()
      mc.lineSkipCursor(-1)
    end, { desc = 'Skip cursor above' })

    set({ 'n', 'x' }, '<leader><down>', function()
      mc.lineSkipCursor(1)
    end, { desc = 'Skip cursor below' })

    set({ 'n', 'x' }, '<leader>n', function()
      mc.matchAddCursor(1)
    end, { desc = 'Add cursor to next match' })

    set({ 'n', 'x' }, '<leader>s', function()
      mc.matchSkipCursor(1)
    end, { desc = 'Skip next match' })

    set({ 'n', 'x' }, '<leader>N', function()
      mc.matchAddCursor(-1)
    end, { desc = 'Add cursor to previous match' })

    set({ 'n', 'x' }, '<leader>S', function()
      mc.matchSkipCursor(-1)
    end, { desc = 'Skip previous match' })

    set('n', '<c-leftmouse>', mc.handleMouse, { desc = 'Add/remove cursor at mouse position' })
    set('n', '<c-leftdrag>', mc.handleMouseDrag, { desc = 'Add/remove cursors by dragging mouse' })
    set('n', '<c-leftrelease>', mc.handleMouseRelease, { desc = 'Finish mouse selection' })

    set({ 'n', 'x' }, '<c-q>', mc.toggleCursor, { desc = 'Toggle multicursor mode' })
    -- Mappings defined in a keymap layer only apply when there are
    -- multiple cursors. This lets you have overlapping mappings.
    mc.addKeymapLayer(function(layerSet)
      -- Select a different cursor as the main one.
      layerSet({ 'n', 'x' }, '<left>', mc.prevCursor)
      layerSet({ 'n', 'x' }, '<right>', mc.nextCursor)

      -- Delete the main cursor.
      layerSet({ 'n', 'x' }, '<leader>x', mc.deleteCursor)

      -- Enable and clear cursors using escape.
      layerSet('n', '<esc>', function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end)
    end)

    -- Customize how cursors look.
    local hl = vim.api.nvim_set_hl
    hl(0, 'MultiCursorCursor', { reverse = true })
    hl(0, 'MultiCursorVisual', { link = 'Visual' })
    hl(0, 'MultiCursorSign', { link = 'SignColumn' })
    hl(0, 'MultiCursorMatchPreview', { link = 'Search' })
    hl(0, 'MultiCursorDisabledCursor', { reverse = true })
    hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
    hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })
  end,
}
