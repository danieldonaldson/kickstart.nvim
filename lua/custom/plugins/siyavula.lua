-- ~/.config/nvim/lua/custom/plugins/project_config.lua
return {
  'nvim-lua/plenary.nvim', -- Using plenary as dependency since we need to return a plugin spec
  lazy = false,
  config = function()
    -- Define the specific project path
    local specific_project_path = '/home/danie/Siyavula/siyavula.portal'

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

          -- Setup Telescope commands for this project
          local telescope_ok, telescope = pcall(require, 'telescope.builtin')
          if telescope_ok then
            -- Create project-specific commands and mappings
            vim.api.nvim_create_user_command('ProjectFind', function()
              telescope.find_files {
                find_command = { 'rg', '--files', '--no-ignore', '--hidden', '--glob', '!**/.git/*' },
              }
            end, {})

            vim.api.nvim_create_user_command('ProjectGrep', function()
              telescope.live_grep {
                additional_args = { '--no-ignore' },
              }
            end, {})

            vim.keymap.set('n', '<leader>sif', ':ProjectFind<CR>', { desc = 'Find in Project (with ignored)' })
            vim.keymap.set('n', '<leader>sig', ':ProjectGrep<CR>', { desc = 'Grep in Project (with ignored)' })
          end

          print 'Loaded project-specific configuration'
        end
      end,
    })

    -- Trigger the autocommand when Neovim starts
    vim.defer_fn(function()
      vim.api.nvim_exec_autocmds('DirChanged', {})
    end, 100)
  end,
}
