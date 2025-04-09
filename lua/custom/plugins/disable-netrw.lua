-- Disable netrw completely
return {
  'nvim-lua/plenary.nvim',
  lazy = false,
  priority = 1000, -- Make sure this loads first
  init = function()
    -- Disable netrw at the very start of your init.lua
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.g.loaded_netrwSettings = 1
    vim.g.loaded_netrwFileHandlers = 1

    -- Also handle directory opens
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        -- If started with directory, open Neo-tree
        local arg = vim.fn.argv(0)
        if arg and (vim.fn.isdirectory(arg) == 1) then
          vim.cmd.cd(arg)
          -- Small delay to ensure neovim is fully loaded
          vim.defer_fn(function()
            vim.cmd('Neotree position=current dir=' .. arg)
          end, 10)
        end
      end,
    })
  end,
}
