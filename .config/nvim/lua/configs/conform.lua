-- Array of filetypes where autoformat is disabled by default

local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    tex = { "latexindent" },
    yaml = { "yamlfix" },
    python = { "black", "isort" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    rust = { "rustfmt" },
    qml = { "qmlformat" },
    -- bib = { "bibtex-tidy" },
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 5000, lsp_format = false }
  end,
}

return options
