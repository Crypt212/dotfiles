require("neo-tree").setup({
  filesystem = {
    follow_current_file = {
      enabled = false  -- Disable auto-focus if you have it enabled
    },
    hijack_netrw_behavior = "open_current",
    bind_to_cwd = false,  -- Important! Allows custom root behavior
    use_libuv_file_watcher = true,
    window = {
      mappings = {
        ["<space>"] = "none",  -- Prevent space from toggling, if you want
      }
    }
  }
})
