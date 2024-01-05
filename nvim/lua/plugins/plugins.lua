return {
  -- colorscheme
  { 'joshdick/onedark.vim',
    lazy = true,
    -- config = function()
    --   vim.cmd([[colorscheme onedark]])
    -- end
  },
  { 'ribru17/bamboo.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('bamboo').setup {
        -- optional configuration here
      }
      require('bamboo').load()
    end,
  },
  { "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end,
  },
  { "zbirenbaum/copilot-cmp",
    config = function ()
      require("copilot_cmp").setup()
    end
  },
  { 'tzachar/cmp-tabnine' ,
    build = './install.sh',
    dependencies = { 'hrsh7th/nvim-cmp' },
  },
  { "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "tzachar/cmp-tabnine",
      "zbirenbaum/copilot-cmp",
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-j>"] = cmp.mapping.scroll_docs(-4),
          ["<C-k>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
        }),
        sources = cmp.config.sources({
          { name = "copilot" },
          { name = "tabnine" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = defaults.sorting,
      }
    end,
    ---@param opts cmp.ConfigSchema
    config = function(_, opts)
      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end
      require("cmp").setup(opts)
    end,
  },
  -- appearance
  { 'lukas-reineke/indent-blankline.nvim', 
    main = "ibl", 
    opts = {},
    config = function()
        require("ibl").setup()
    end,
  },
  { 'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("lualine").setup({})
    end,
  },
  { 'bronson/vim-trailing-whitespace',
    lazy = true },
  { 'mechatroner/rainbow_csv' },
  { 'tpope/vim-commentary' },
  { 'luochen1990/rainbow' },

  -- git
  { 'airblade/vim-gitgutter' },
  { 'tpope/vim-fugitive' },

  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<C-e>", "<Cmd>Neotree<CR>" },
    },
    config = function ()
      require("neo-tree").setup({
        enable_git_status = true,
        filesystem={ 
          filtertered_items = { 
            hide_dotfiles = false,
            hide_gitignored = false,
            never_show = { 
              ".DS_Store",
            },
          },
        },
      })
    end
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete other buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
      { "<C-h>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
      { "<C-l>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
    },
    opts = {
      options = {
        -- stylua: ignore
        close_command = function(n) require("mini.bufremove").delete(n, false) end,
        -- stylua: ignore
        right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd("BufAdd", {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
        require'alpha'.setup(require'alpha.themes.startify'.config)
    end
  },
  { 'nvim-treesitter/nvim-treesitter-textobjects' },
  { 'nvim-treesitter/nvim-treesitter',
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
      },
    },
  },
      -- LSP Configuration & Plugins
  { 'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
        'williamboman/mason-lspconfig.nvim',
    }
  },
  { 'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        ["python"] = { "black", "isort" },
      },
    }
  },
  { 'mfussenegger/nvim-lint',
    config = function()
      require('lint').linters_by_ft = {
        python = { 'flake8', 'mypy', 'typos', 'vale' },
        cpp = { 'cppcheck', 'typos', 'vale' },
      }
    end
  },
  { 'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { "ff", "<Cmd>Telescope find_files<CR>", desc = "Find files" },
      { "fg", "<Cmd>Telescope live_grep<CR>", desc = "Grep files" },
      { "fb", "<Cmd>Telescope buffers<CR>", desc = "Find buffers" },
      { "fh", "<Cmd>Telescope help_tags<CR>", desc = "Find help tags" },
    },
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', 
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' 
  },
}
