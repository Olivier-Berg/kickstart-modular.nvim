local function gh(repo) return 'https://github.com/' .. repo end

-- [[ Formatting ]]
vim.pack.add { gh 'stevearc/conform.nvim' }
require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    -- Disable "format_on_save lsp_fallback" for languages that don't
    -- have a well standardized coding style. You can add additional
    -- languages here or re-enable it for the disabled ones.
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then
      return nil
    else
      return {
        timeout_ms = 5000,
        lsp_format = 'fallback',
      }
    end
  end,
  default_format_opts = {
    lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
  },
  formatters_by_ft = {
    lua = { 'stylua' },
    -- Conform can also run multiple formatters sequentially
    python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },

    go = { 'goimports', 'gofumpt' },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { 'rustfmt', lsp_format = 'fallback' },
    -- You can use 'stop_after_first' to run the first available formatter from the list
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
    -- html = { 'prettierd', 'prettier', stop_after_first = true },

    -- Only use prettierd because it allows for a PRETTIERD_DEFAULT_CONFIG which regular prettier does not allow for
    gotmpl = { 'prettierd' },

    sql = { 'sql_formatter' },
  },
  formatters = {
    sql_formatter = {
      append_args = { '-l', 'postgresql' },
    },
    prettierd = {
      env = {
        string.format('PRETTIERD_DEFAULT_CONFIG=%s', vim.fn.expand '~/.config/nvim/.prettierrc.json'),
      },
    },
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true, lsp_format = 'fallback' } end, { desc = '[F]ormat buffer' })

-- vim: ts=2 sts=2 sw=2 et
