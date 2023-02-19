return {
  -- TODO: review placement of diagnostics
  -- TODO: figure out a better strategy for filename -- currently
  --       winbar carries the bare filename while the statusline
  --       carries the full path
  -- TODO: add copilot button/icon that checks for activity
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      { "nvim-navic" },
    },
    opts = function(_, lop)
      local NON_LSP_CLIENTS = { "", "copilot", "null-ls" }
      local FILESTATUS_SYMBOLS = { modified = "  ", readonly = "", unnamed = "" }

      local navic = require("nvim-navic")
      local cwd = function()
        local path = vim.split(vim.fn.getcwd(), "/", {})
        return path[#path]
      end

      local get_active_lsp = function()
        for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
          if not vim.tbl_contains(NON_LSP_CLIENTS, client.name) then
            return "LSP: " .. client.name
          end
        end
      end

      local winbar = {
        lualine_a = {
          { "filename", path = 0, symbols = FILESTATUS_SYMBOLS },
        },
        lualine_b = {
          { navic.get_location, cond = navic.is_available },
        },
      }

      local inactive_winbar = {
        lualine_a = winbar.lualine_a,
      }

      local sections = {
        -- Mode
        lualine_a = lop.sections.lualine_a,
        lualine_b = {
          { cwd },
          -- Branch
          -- HACK: might break if lazyvim changes the order of sections
          lop.sections.lualine_b,
          { "filename", path = 1, symbols = FILESTATUS_SYMBOLS },
        },
        -- -- File info
        lualine_c = {
          -- Diagnostics
          -- HACK: might break if lazyvim changes the order of the diagnostics
          lop.sections.lualine_c[1],
        },

        -- Workspace and git state
        lualine_x = lop.sections.lualine_x,
        -- Location and filetype
        lualine_y = {
          "progress",
          "location",
          "encoding",
          "fileformat",
        },
        -- LSP status
        lualine_z = {
          "filetype",
          get_active_lsp,
        },
      }

      lop.winbar = winbar
      lop.inactive_winbar = inactive_winbar
      lop.sections = sections
      return lop
    end,
  },
}
