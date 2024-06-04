local icons = require("lazyvim.config").icons

local diff = {
  "diff",
  symbols = {
    added = icons.git.added,
    modified = icons.git.modified,
    removed = icons.git.removed,
  },
}

local diagnostic = {
  "diagnostics",
  symbols = {
    error = icons.diagnostics.Error,
    warn = icons.diagnostics.Warn,
    info = icons.diagnostics.Info,
    hint = icons.diagnostics.Hint,
  },
}

local filename = {
  "filename",
  path = 4, -- set to 0 for just filename
  symbols = {
      modified = "",
      readonly = "[ro]",
      unnamed = "[No Name]",
      newfile = "[New]",
  },
}

local position = {
  "location",
  padding = { left = 0, right = 1 },
}

-- local trouble = {
--   function() 
--     return require("trouble").statusLine({
--       mode = "lsp_document_symbols",
--       groups = {},
--       title = false,
--       filter = { range = true },
--       format = "{kind_icon}{symbol.name:Normal}",
--     })
--   end
-- }

local filetype = {
  "fileformat",
  padding = { left = 1, right = 0 }
}

local encoding = {
  "encoding",
  padding = { left = 1, right = 0 }
}

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        options = {
          -- component_separators = { left = "╲", right = "│" },
          -- section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          -- section_separators = { left = "|", right = "|" },
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", diff },
          lualine_c = { filetype, filename },
          lualine_x = { "searchcount", "selectioncount" },
          lualine_y = { diagnostic, encoding, "filesize" },
          lualine_z = { position },
        },
        extensions = { "neo-tree", "lazy" },
      }
    end,
  },
}
