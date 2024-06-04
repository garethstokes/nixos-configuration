local km = vim.keymap.set

-- Telescope
km("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "[F]ind in file using Telescope" })
km("n", "f", function()
    require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({ previewer = false }))
end, { desc = "Telescope [f]ind file" })

-- move selected lines
km("v", "J", ":m '>+1<CR>gv=gv")
km("v", "K", ":m '<-2<CR>gv=gv")

-- diagnostics
-- ENABLE THIS IF USING trouble.nvim
-- km("n", "<leader>xx", vim.cmd.TroubleToggle, { desc = "TroubleToggle" })
-- km(
--     "n",
--     "<leader>xw",
--     "<cmd>TroubleToggle workspace_diagnostics<cr>",
--     { desc = "TroubleToggle [W]orkspace" }
-- )

-- buffers
km({ "n", "i", "v" }, "<A-l>", vim.cmd.bnext, { desc = "Switch to next Buffer" })
km({ "n", "i", "v" }, "<A-h>", vim.cmd.bprev, { desc = "Switch to prev Buffer" })
km("n", "q", function()
    vim.cmd("bw")
end, { desc = "Close Buffer" })

-- selection
km("n", "<C-a>", "ggVG")
km("v", "V", "j")

-- colors
km("n", "<leader>cc", vim.cmd.ColorizerToggle, { desc = "[C]olorizer" })
km("n", "<leader>cp", vim.cmd.PickColor, { desc = "[P]ick Color" })
