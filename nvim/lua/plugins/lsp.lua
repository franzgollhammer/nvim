return {
  {
    "williamboman/mason.nvim",
    lazy = false,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local on_attach = function(_, bufnr)
        local keymap = function(keys, func, desc)
          if desc then
            desc = "LSP: " .. desc
          end

          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end

        keymap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        keymap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        keymap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
        keymap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        keymap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
        keymap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
        keymap("K", vim.lsp.buf.hover, "Hover Documentation")
        keymap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
        keymap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
      end

      require("lspconfig")
      require("mason").setup()
      require("mason-lspconfig").setup()

      local mason_lspconfig = require("mason-lspconfig")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities()

      local servers = {
        tsserver = {},
        -- eslint = {},
        html = { filetypes = { "html", "hbs" } },
        volar = {},
        cssls = {},
        bashls = {},
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      }

      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
      })

      mason_lspconfig.setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
          })
        end,
      })
    end,
  },
}
