local latex_bin_path = vim.fn.expand "~/.config/nvim/latex"
if vim.fn.isdirectory(latex_bin_path) == 1 then
  if vim.loop.os_uname().sysname == "Windows_NT" then
    vim.env.PATH = latex_bin_path .. ";" .. vim.env.PATH
  else
    vim.env.PATH = latex_bin_path .. ":" .. vim.env.PATH
  end
end

vim.g.vimtex_mappings_enabled = 0
vim.g.vimtex_view_general_viewer = "zathura_simple"
vim.g.vimtex_view_method = "zathura_simple"
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_compiler_latexmk = {
  callback = 1,
  continuous = 1,
  executable = "latexmk",
  options = {
    "-shell-escape",
    "-verbose",
    "-file-line-error",
    "-synctex=1",
    "-interaction=nonstopmode",
  },
}
vim.g.vimtex_quickfix_mode = 0
vim.g.vimtex_fold_enabled = 0
vim.g.vimtex_syntax_enabled = 0
