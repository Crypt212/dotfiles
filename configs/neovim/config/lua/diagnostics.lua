-- lua/config/diagnostics.lua
return {
  virtual_lines = {
    source = "if_many",                 -- Show diagnostic source (e.g., "pyright")
    prefix = "■ ",                      -- Custom prefix
    flat = false,                       -- Show diagnostics on a single line
    current_line = true,                -- Show diagnostics for current line only
    format = function(d)
      return string.format(
        "%s [%s] %s",
        d.severity == vim.diagnostic.severity.ERROR and "" or "",
        d.source,
        d.message:gsub("\n", " ")
      )
    end,
  },
  severity_sort = true,                 -- Sort diagnostics by severity
  signs = true,                         -- Show gutter icons
  underline = true,                     -- Underline problematic code
  update_in_insert = false,             -- Don't update diagnostics while typing
}

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
