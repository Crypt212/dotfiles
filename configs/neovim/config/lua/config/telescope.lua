local telescope = require('telescope')

telescope.setup({
  defaults = {
    cache_picker = {
      num_pickers = 15, -- Cache last 15 pickers
    },
    file_ignore_patterns = {
      "node_modules", ".git", "venv", "__pycache__"
    }
  },
  pickers = {
    find_files = {
      find_command = { "fd", "--type", "f", "--hidden" }, -- Requires fd
      theme = "dropdown"
    }
  }
})
