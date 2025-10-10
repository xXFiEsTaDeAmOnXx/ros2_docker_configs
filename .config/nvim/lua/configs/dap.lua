local dap = require "dap"

require("dap.ext.vscode").load_launchjs()

dap.adapters.cpp = {
  name = "codelldb server",
  type = "server",
  port = "${port}",
  executable = {
    command = vim.fn.stdpath "data" .. "/mason/bin/codelldb",
    args = { "--port", "${port}" },
  },
}

-- Define your keybindings
local debugger_mappings = {
  n = {
    -- LSP Diagnostics
    ["<leader>dt"] = {
      function()
        require("dapui").toggle()
        require("nvim-tree.api").tree.resize { width = 30 }
      end,
      { desc = "Toogle DAP-UI" },
    },
    ["<leader>db"] = {
      function()
        require("dap").toggle_breakpoint()
      end,
      { desc = "Toggle breakpoint at line" },
    },
    ["<leader>dr"] = {
      function()
        require("dap").continue()
      end,
      { desc = "Start or continiue the debugger" },
    },

    ["<leader>dsov"] = {
      function()
        require("dap").step_over()
      end,
      { desc = "Step over" },
    },

    ["<leader>dsi"] = {
      function()
        require("dap").step_over()
      end,
      { desc = "Step into" },
    },

    ["<leader>dsou"] = {
      function()
        require("dap").step_over()
      end,
      { desc = "Step out" },
    },
  },
}

local function setup_debugger_mappings(bufnr)
  local dap = require "dap"

  -- Check if the current buffer has a DAP configuration
  local configurations = dap.configurations[vim.bo.filetype]
  if configurations and #configurations > 0 then
    -- Set the keybindings with options
    local opts = { buffer = bufnr, silent = true }
    for mode, maps in pairs(debugger_mappings) do
      for key, val in pairs(maps) do
        -- Merge opts with the keymap options
        local key_opts = vim.tbl_extend("force", opts, val[2] or {})
        vim.keymap.set(mode, key, val[1], key_opts)
      end
    end
  end
end

-- Autocommand to set up DAP keybindings on BufEnter (when entering a buffer)
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(args)
    setup_debugger_mappings(args.buf)
  end,
})
