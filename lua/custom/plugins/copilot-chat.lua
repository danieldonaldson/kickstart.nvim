return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    opts = {
      model = 'gpt-4.1',
      -- See Configuration section for options
    },
    keys = {
      { '<leader>cc', '<cmd>CopilotChat<cr>', desc = 'Open Copilot Chat' },
    },
  },
}
