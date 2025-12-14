return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },
  {
    "folke/neoconf.nvim",
    lazy = false,
    config = function()
      require("neoconf").setup {}
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    tag = "v0.9.3",
    opts = {
      ensure_installed = {
        "lua",
        "c",
        "cpp",
        "markdown",
        "markdown_inline",
        "toml",
        "meson",
        "make",
        "gitignore",
        "fish",
        "dockerfile",
        "python",
        "rust",
        "latex",
      },
    },
    config = function(_, opts)
      local mason_bin_path = vim.fn.stdpath "data" .. "/mason/bin"
      if vim.loop.os_uname().sysname == "Windows_NT" then
        vim.env.PATH = mason_bin_path .. ";" .. vim.env.PATH
      else
        vim.env.PATH = mason_bin_path .. ":" .. vim.env.PATH
      end
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    ft = {
      "tex",
      "bib",
    },
    init = function()
      require "configs.vimtex"
    end,
  },
  { import = "nvchad.blink.lazyspec" },
  {
    "Saghen/blink.cmp",
    event = "InsertEnter",
    build = "cargo +nightly build --release",
    dependencies = {
      "saghen/blink.compat", -- nvim-cmp sources in blink
      "L3MON4D3/LuaSnip", -- snippet engine
      "micangl/cmp-vimtex", -- source of vimtex for latex
    },
    opts = {
      sources = {
        default = { "vimtex", "lsp", "path", "snippets", "buffer" },
        providers = {
          vimtex = {
            name = "vimtex",
            module = "blink.compat.source",
            score_offset = 300, -- make VimTeX completions appear at the very top
          },
        },
      },
      snippets = { preset = "luasnip" },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 250,
          update_delay_ms = 50,
          treesitter_highlighting = true,
          window = { border = "rounded" },
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },
        menu = {
          border = "rounded",
        },
      },
      keymap = {
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = {
          function(cmp)
            return cmp.select_next()
          end,
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = {
          function(cmp)
            return cmp.select_prev()
          end,
          "snippet_backward",
          "fallback",
        },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-up>"] = { "scroll_documentation_up", "fallback" },
        ["<C-down>"] = { "scroll_documentation_down", "fallback" },
      },
      -- Experimental signature help support
      signature = {
        enabled = false,
        window = { border = "rounded" },
      },
    },
  },
  {
    "stevearc/vim-arduino",
    ft = {
      "arduino",
    },
  },
  {
    "towolf/vim-helm",
    ft = { "helm" },
  },

  {
    "barreiroleo/ltex_extra.nvim",
    ft = { "markdown", "tex" },
    dependencies = { "neovim/nvim-lspconfig" },
  },
  {
    "EthanJWright/vs-tasks.nvim",
    dependencies = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("configs.vstask").setup()
    end,
  },
}
