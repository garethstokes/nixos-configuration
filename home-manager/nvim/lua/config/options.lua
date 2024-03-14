local opt = vim.opt

opt.conceallevel = 1
opt.cursorline = false
opt.number = true -- Print line number
opt.relativenumber = true -- Relative line numbers
opt.hlsearch = false -- highlight search
opt.incsearch = true -- incremental search
opt.scrolloff = 2 -- scroll offset
opt.clipboard = "unnamedplus" -- sync clipboard with os
opt.breakindent = true

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

opt.swapfile = false

opt.cinoptions:append(":0") -- switch statement indentations

-- global overrides
vim.o.shiftwidth = 2

vim.diagnostic.config({
  virtual_text = false,
})
