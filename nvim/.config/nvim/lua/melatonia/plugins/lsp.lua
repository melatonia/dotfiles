return {
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "",
          package_pending = "",
          package_uninstalled = "",
        },
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "prettier",
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp",
    },
     opts = {
      ensure_installed = { 
        "lua_ls",
        "bashls",
        "jsonls",
        "marksman",
      },
      automatic_enable = {
        exclude = { "rust_analyzer" },
      },
    },
    config = function(_, opts)
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { gloabls = { "vim" } },
            workspace = { checkThirdParty = false},
          },
        },
      })

      -- rust_analyzer excluded from automatic_enable and enabled manually here
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            check = { command = "clippy" },
          },
        },
      })
      vim.lsp.enable( "rust_analyzer" )

      require("mason-lspconfig").setup(opts)
    end,
  },
}
