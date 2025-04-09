-- Custom Neo-tree configuration
return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal toggle<CR>', desc = 'NeoTree toggle', silent = true },
    { '<leader>e', ':Neotree reveal<CR>', desc = 'NeoTree reveal current file', silent = true },
  },
  init = function()
    -- Unless you are still migrating, remove the deprecated commands from v1.x
    vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]
  end,
  opts = {
    close_if_last_window = true,
    popup_border_style = 'rounded',
    enable_git_status = true,
    enable_diagnostics = true,
    sources = {
      'filesystem',
      'buffers',
      'git_status',
    },
    source_selector = {
      winbar = true,
      content_layout = 'center',
      sources = {
        { source = 'filesystem', display_name = ' 󰉓 Files ' },
        { source = 'buffers', display_name = ' 󰈙 Buffers ' },
        { source = 'git_status', display_name = ' 󰊢 Git ' },
      },
    },
    default_component_configs = {
      indent = {
        with_expanders = true,
        expander_collapsed = '',
        expander_expanded = '',
        expander_highlight = 'NeoTreeExpander',
      },
      icon = {
        folder_closed = '',
        folder_open = '',
        folder_empty = '',
      },
      modified = {
        symbol = '●',
      },
      git_status = {
        symbols = {
          added = '✚',
          deleted = '✖',
          modified = '',
          renamed = '',
          untracked = '?',
          ignored = '',
          unstaged = '',
          staged = '',
          conflict = '',
        },
      },
    },
    window = {
      width = 30,
      mappings = {
        ['<space>'] = 'none',
      },
    },
    filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      follow_current_file = {
        enabled = true,
      },
      use_libuv_file_watcher = true,
      hijack_netrw_behavior = 'open_current',
      window = {
        mappings = {
          ['<F1>'] = 'toggle_node',
          ['<F2>'] = 'open',
          ['d'] = 'delete',
          ['r'] = 'rename',
          ['c'] = 'copy',
          ['m'] = 'move',
          ['q'] = 'close_window',
          ['\\'] = 'close_window',
          ['n'] = {
            command = 'add',
            config = {
              show_path = 'none',
            },
          },
        },
      },
    },
  },
}
