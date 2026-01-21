-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

local default_servers =
  { "clangd", "dockerls", "docker_compose_language_service", "jsonls", "lua_ls", "hyprls", "pyright" }
local nvlsp = require "nvchad.configs.lspconfig"

local mappings = {
  n = {
    -- LSP Diagnostics
    ["<leader>lgp"] = {
      function()
        vim.diagnostic.goto_prev()
      end,
      { desc = "Go to previous diagnostic" },
    },
    ["<leader>lgn"] = {
      function()
        vim.diagnostic.goto_next()
      end,
      { desc = "Go to next diagnostic" },
    },
    ["<leader>ld"] = {
      function()
        local float_opts = {
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          border = "single",
          source = "if_many",
          prefix = "",
        }
        vim.diagnostic.open_float(nil, float_opts)
      end,
      { desc = "Open diagnostic float" },
    },

    -- LSP Buffer Actions
    ["<leader>la"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      { desc = "Code action" },
    },
    ["<leader>lgd"] = {
      function()
        vim.lsp.buf.definition()
      end,
      { desc = "Go to definition" },
    },
    ["<leader>lgD"] = {
      function()
        vim.lsp.buf.declaration()
      end,
      { desc = "Go to declaration" },
    },
    ["<leader>lh"] = {
      function()
        vim.lsp.buf.hover()
      end,
      { desc = "Hover info" },
    },
    ["<leader>li"] = {
      function()
        vim.lsp.buf.implementation()
      end,
      { desc = "Go to implementation" },
    },
    ["<leader>lr"] = {
      function()
        vim.lsp.buf.rename()
      end,
      { desc = "Rename symbol" },
    },
    ["<leader>lR"] = {
      function()
        vim.lsp.buf.references()
      end,
      { desc = "Find references" },
    },
    ["<leader>ls"] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      { desc = "Signature help" },
    },
  },
}

local on_attach = function(client, bufnr)
  -- Mappings
  local opts = { buffer = bufnr, silent = true }
  for mode, maps in pairs(mappings) do
    for key, val in pairs(maps) do
      -- Merge opts with the keymap options
      local key_opts = vim.tbl_extend("force", opts, val[2] or {})
      vim.keymap.set(mode, key, val[1], key_opts)
    end
  end
  nvlsp.on_attach(client, bufnr)
end

-- change keybinds on attach
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    on_attach(_, args.buf)
  end,
})

-- lsps with default config
for _, lsp in ipairs(default_servers) do
  vim.lsp.enable(lsp)
end

local server_configs = {
  ["rust_analyzer"] = {
    filetypes = { "rust" },
    settings = {
      ["rust_analyzer"] = {
        cargo = {
          allFeatures = true,
        },
      },
    },
  },

  ["helm-ls"] = {
    settings = {
      ["helm-ls"] = {
        yamlls = {
          path = "yaml-language-server",
        },
      },
    },
  },

  ["yamlls"] = {
    filetypes = { "yaml" },
    settings = {
      yaml = {
        schemas = {
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
          ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
        },
      },
    },
  },
  ["pylsp"] = {
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = {
            ignore = { "W391" },
            maxLineLength = 150,
          },
        },
      },
    },
  },

  ["ltex"] = {
    settings = {
      ltex = {
        language = "en-US",
        enabled = {
          "bibtex",
          "gitcommit",
          "markdown",
          "org",
          "tex",
          "restructuredtext",
          "latex",
          "context",
          "mail",
          "plaintext",
        },
        checkFrequency = "save",
        completionEnabled = true,
        diagnosticSeverity = "information",
        additionalRules = {
          enablePickyRules = true,
        },
      },
    },
    on_attach = function(client, bufnr)
      -- Mappings
      local ltex_mappings = {
        n = {
          -- LSP Diagnostics
          ["<leader>ll"] = {
            "<cmd> VimtexCompile <CR>",
            { desc = "Start LaTeX Compiler" },
          },
          ["<leader>lo"] = {
            "<cmd> VimtexCompileOutput <CR>",
            { desc = "Show Compiler Output" },
          },
          ["<leader>le"] = {
            "<cmd> VimtexErrors <CR>",
            { desc = "Start LaTeX Compiler" },
          },
          ["<leader>lv"] = {
            "<cmd> VimtexView <CR>",
            { desc = "Start LaTeX Compiler" },
          },
        },
      }
      local opts = { buffer = bufnr, silent = true }
      for mode, maps in pairs(ltex_mappings) do
        for key, val in pairs(maps) do
          -- Merge opts with the keymap options
          local key_opts = vim.tbl_extend("force", opts, val[2] or {})
          vim.keymap.set(mode, key, val[1], key_opts)
        end
      end

      on_attach(client, bufnr)

      require("ltex_extra").setup { --client-side features of nvim
        load_langs = { "de-DE", "en-US" },
        path = ".ltex",
      }
    end,
  },
  ["qmlls"] = {
    cmd = { "qmlls" },
  },
}

for lsp, config in pairs(server_configs) do
  vim.lsp.config(lsp, config)
  vim.lsp.enable(lsp)
end
