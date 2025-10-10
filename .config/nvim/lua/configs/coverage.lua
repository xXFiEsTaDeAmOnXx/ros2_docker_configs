require("coverage").setup()

local testing_mappings = {
  n = {
    ["<leader>cs"] = {
      function()
        local cov = require "coverage"
        cov.load(true)
      end,
      { desc = "Show test coverage" },
    },
    ["<leader>ch"] = {
      function()
        require("coverage").hide()
      end,
      { desc = "Hide test coverage" },
    },
  },
}

local opts = { buffer = bufnr, silent = true }
for mode, maps in pairs(testing_mappings) do
  for key, val in pairs(maps) do
    local key_opts = vim.tbl_extend("force", opts, val[2] or {})
    vim.keymap.set(mode, key, val[1], key_opts)
  end
end
