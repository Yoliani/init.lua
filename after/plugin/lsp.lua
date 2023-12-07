local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
    'tsserver',
    'eslint',
    'lua_ls',
    'rust_analyzer',
    'pyright',
    'gopls',
})

lsp.nvim_workspace()


-- Fix Undefined global 'vim'
lsp.configure('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

lsp.configure(
    "rust_analyzer", {
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy",
                },
            },
            diagnostics = {
                enable = true,
                disabled = { "unresolved-proc-macro" },
                enableExperimental = true,
            },
        },
    }
)

lsp.format_on_save({
  format_opts = {
    async = false,
    timeout_ms = 10000,
  },
  servers = {
    ['tsserver'] = {'javascript', 'typescript'},
    ['rust_analyzer'] = {'rust'},
  }
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

-- disable completion with tab
-- this helps with copilot setup
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = ''
    },
    configure_diagnostics = true,
    cmp_capabilities = true,
    manage_nvim_cmp = true,
    setup_servers_on_start = true,
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    local function lsp_keymaps(mode, key, cmd)
        vim.keymap.set(mode, key, cmd, opts)
    end

    lsp_keymaps("n", "gD", vim.lsp.buf.declaration)
    lsp_keymaps("n", "gd", vim.lsp.buf.definition)
    lsp_keymaps("n", "K", vim.lsp.buf.hover)
    lsp_keymaps("n", "<leader>vws", vim.lsp.buf.workspace_symbol)
    lsp_keymaps("n", "<leader>vd", vim.diagnostic.open_float)
    lsp_keymaps("n", "[d", vim.diagnostic.goto_next)
    lsp_keymaps("n", "]d", vim.diagnostic.goto_prev)
    lsp_keymaps("n", "<leader>vca", vim.lsp.buf.code_action)
    lsp_keymaps("n", "<leader>vrr", vim.lsp.buf.references)
    lsp_keymaps("n", "<leader>vrn", vim.lsp.buf.rename)
    lsp_keymaps("i", "<C-h>", vim.lsp.buf.signature_help)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    -- float = true,
})
