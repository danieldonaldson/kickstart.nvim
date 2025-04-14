-- ~/.config/nvim/lua/custom/plugins/project_config.lua
return {
  'nvim-lua/plenary.nvim', -- Using plenary as dependency since we need to return a plugin spec
  lazy = false,
  config = function()
    -- Define the specific project path
    local specific_project_path = '/home/danie/Siyavula/siyavula.portal'

    local function run_nosetests()
      local filepath = vim.fn.expand '%:p'
      local cmd = string.format('source %s/venv/bin/activate && nosetests -v %s', specific_project_path, filepath)

      -- Create a terminal window
      vim.cmd 'botright 20split'
      vim.cmd 'terminal'

      -- Send the command to the terminal
      local bufnr = vim.api.nvim_get_current_buf()
      vim.api.nvim_chan_send(vim.b[bufnr].terminal_job_id, cmd .. '\n')

      -- Start in insert mode
      vim.cmd 'startinsert'
    end

    vim.api.nvim_create_augroup('ProjectSpecificConfig', { clear = true })
    vim.api.nvim_create_autocmd('DirChanged', {
      group = 'ProjectSpecificConfig',
      callback = function()
        local current_dir = vim.fn.getcwd()

        -- Check if we're in the specific project
        if current_dir == specific_project_path or current_dir:find(specific_project_path, 1, true) == 1 then
          -- We're in the target project

          -- Setup PyRight for this project
          vim.defer_fn(function()
            for _, client in pairs(vim.lsp.get_clients()) do
              if client.name == 'pyright' then
                client.config.settings = client.config.settings or {}
                client.config.settings.python = client.config.settings.python or {}
                client.config.settings.python.analysis = client.config.settings.python.analysis or {}
                client.config.settings.python.analysis.extraPaths = {
                  current_dir .. '/src/siyavula.models',
                  current_dir .. '/venv/lib/python3.8/site-packages',
                }
                vim.cmd('LspRestart ' .. client.id)
                break
              end
            end
          end, 1000)

          print 'Loaded project-specific configuration'
        end
      end,
    })

    -- Add project-specific keymaps
    vim.keymap.set('n', '<leader>tn', run_nosetests, {
      buffer = 0,
      desc = 'Run nosetests on current file',
    })

    -- Configure which-key if available
    local wk_ok, wk = pcall(require, 'which-key')
    if wk_ok then
      wk.add {
        { '<leader>tn', 'Run nosetests on current file' },
      }
    end

    -- Trigger the autocommand when Neovim starts
    vim.defer_fn(function()
      vim.api.nvim_exec_autocmds('DirChanged', {})
    end, 100)
  end,
}
