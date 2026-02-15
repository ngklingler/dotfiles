return {
  {
    "navarasu/onedark.nvim",
    version = "v0.1.0", -- Pin to legacy version
    priority = 1000,
    config = function()
      require("onedark").setup({
        style = "darker",
        colors = {
          bg0 = "#000000", -- main background
          bg1 = "#000000",
          bg2 = "#000000",
          bg3 = "#000000",
        },

        highlights = {
          Normal = { bg = "#000000" },
          NormalFloat = { bg = "#000000" },
          SignColumn = { bg = "#000000" },
          EndOfBuffer = { bg = "#000000" },
          CursorLine = { bg = "#111111" }, -- subtle cursor line contrast
          Visual = { bg = "#222222" },
        },
      })
      require("onedark").load()
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
}
