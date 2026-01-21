return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup {
        -- Chat buffer configuration
        chat = {
          border = "rounded",
          width = 80,
          height = 20,
        },
        -- Enable inline assistant
        inline = {
          enabled = true,
          border = "rounded",
        },
        -- Enable tools and workflows
        tools = {
          enabled = true,
        },
        -- Logging configuration
        log_level = "INFO", -- DEBUG, INFO, WARN, ERROR
        adapters = {
          opts = {
            allow_insecure = true,
          },
          ["gpt-oss:20b_ollama"] = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "gpt-oss:20b",
              env = {
                url = "http://localhost:11434",
              },
              -- headers = {
              --   ["Content-Type"] = "application/json",
              --   ["Authorization"] = "Bearer ${api_key}",
              -- },
              parameters = {
                sync = true,
              },
              schema = {
                model = {
                  default = "gpt-oss:20b",
                },
                num_ctx = {
                  default = 16384,
                },
                num_predict = {
                  default = -1,
                },
              },
            })
          end,
          ["qwen3-coder:30b_ollama"] = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "qwen3-coder:30b",
              env = {
                url = "http://localhost:11434",
              },
              -- headers = {
              --   ["Content-Type"] = "application/json",
              --   ["Authorization"] = "Bearer ${api_key}",
              -- },
              parameters = {
                sync = true,
              },
              schema = {
                model = {
                  default = "qwen3-coder:30b",
                },
                num_ctx = {
                  default = 16384,
                },
                num_predict = {
                  default = -1,
                },
              },
            })
          end,
        },
        strategies = {
          chat = {
            adapter = "qwen3-coder:30b_ollama",
          },
          inline = {
            adapter = "qwen3-coder:30b_ollama",
          },
          agent = {
            adapter = "qwen3-coder:30b_ollama",
          },
        },
      }
    end,
    keys = {
      -- Default keymaps for CodeCompanion
      { "<leader>ci", "<cmd>'<,'>CodeCompanion<CR>", mode = { "v" }, desc = "Open CodeCompanion Inline" },
      { "<leader>cc", "<cmd>CodeCompanionChat<CR>", desc = "Open CodeCompanion Chat" },
      { "<leader>ca", "<cmd><,'>CodeCompanionActions<CR>", mode = { "i" }, desc = "Open CodeCompanion Actions" },
      { "<leader>ca", "<cmd>CodeCompanionActions<CR>", mode = { "v" }, desc = "Open CodeCompanion Actions" },
      { "<leader>ct", "<cmd>CodeCompanionCmd<CR>", desc = "Open Tools" },
    },
  },
  {
    "echasnovski/mini.diff",
    config = function()
      local diff = require "mini.diff"
      diff.setup {
        -- Disabled by default
        source = diff.gen_source.none(),
      }
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "codecompanion" },
  },
}
