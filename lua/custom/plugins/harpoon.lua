-- Harpoon configuration (v2)
return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    -- REQUIRED
    harpoon:setup()

    local conf = require('telescope.config').values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require('telescope.pickers')
        .new({}, {
          prompt_title = 'Harpoon',
          finder = require('telescope.finders').new_table {
            results = file_paths,
          },
          previewer = conf.file_previewer {},
          sorter = conf.generic_sorter {},
        })
        :find()
    end

    vim.keymap.set('n', '<leader><tab>e', function()
      toggle_telescope(harpoon:list())
    end, { desc = 'Open harpoon window' })

    vim.keymap.set('n', '<leader><tab>a', function()
      harpoon:list():add()
    end)

    vim.keymap.set('n', '<leader><tab>1', function()
      harpoon:list():select(1)
    end)
    vim.keymap.set('n', '<leader><tab>2', function()
      harpoon:list():select(2)
    end)
    vim.keymap.set('n', '<leader><tab>3', function()
      harpoon:list():select(3)
    end)
    vim.keymap.set('n', '<leader><tab>4', function()
      harpoon:list():select(4)
    end)

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<leader><tab>p', function()
      harpoon:list():prev()
    end)
    vim.keymap.set('n', '<leader><tab>n', function()
      harpoon:list():next()
    end)

    local ok, wk = pcall(require, 'which-key')
    if ok then
      wk.add {
        { '<leader><tab>', name = 'Harpoon' },
      }
    end
  end,
}
