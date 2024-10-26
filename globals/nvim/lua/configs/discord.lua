require("presence").setup({
  auto_update = true,
  neovim_image_text = "Neovim",
  debounce_timeout = 5,
  enable_line_number = true,

  editing_text = "writing bugs in %s",
  file_explorer_text = "opening %s",
  git_commit_text = "committing changes",
  plugin_manager_text = "managing deez plugins",
  reading_text = "trying to understand %s",
  workspace_text = "working on %s",
  line_number_text = "line %s out of %s",
})
