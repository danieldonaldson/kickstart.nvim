-- Enhanced Python support using treesitter text objects
return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('nvim-treesitter.configs').setup {
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['al'] = '@loop.outer',
            ['il'] = '@loop.inner',
            ['ai'] = '@conditional.outer',
            ['ii'] = '@conditional.inner',
            ['ab'] = '@block.outer',
            ['ib'] = '@block.inner',
            ['as'] = '@statement.outer',
            ['is'] = '@statement.outer',
            ['am'] = '@call.outer',
            ['im'] = '@call.inner',
            ['ad'] = '@comment.outer',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>pn'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>pp'] = '@parameter.inner',
          },
        },
      },
    }

    -- Add python-specific mappings under <leader>p namespace
    local ok, wk = pcall(require, 'which-key')
    if ok then
      wk.register({
        p = {
          name = '[P]ython',
          y = {
            name = '[Y]ank',
            f = { 'yaf', 'Yank function', mode = 'n' },
            c = { 'yac', 'Yank class', mode = 'n' },
            m = { 'yam', 'Yank method call', mode = 'n' },
          },
          n = { desc = 'Swap with next parameter' },
          p = { desc = 'Swap with previous parameter' },
        },
      }, { prefix = '<leader>' })
    end

    -- Ensure Python is in the ensured languages for treesitter
    local ts_config = require 'nvim-treesitter.configs'
    local languages = ts_config.get_module 'ensure_installed'
    if type(languages) ~= 'table' then
      languages = {}
    end

    -- Check if Python is already in the table
    local has_python = false
    for _, lang in ipairs(languages) do
      if lang == 'python' then
        has_python = true
        break
      end
    end

    -- Add Python if not already present
    if not has_python then
      table.insert(languages, 'python')
      ts_config.setup { ensure_installed = languages }
    end
  end,
}
