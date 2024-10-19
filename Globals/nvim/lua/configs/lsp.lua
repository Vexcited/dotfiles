require "lsp_signature".setup()

local cmp = require'cmp'

cmp.setup({
  mapping = {
    ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({
      select = true,
    }),
  },

  sources = {
    { name = "nvim_lsp" },
    { name = 'path' },
    { name = 'buffer' }
  }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()


require('lspconfig')['ts_ls'].setup {
 capabilities = capabilities
}

require('lspconfig')['pyright'].setup {
 capabilities = capabilities
}

require'lspconfig'.rust_analyzer.setup({})

