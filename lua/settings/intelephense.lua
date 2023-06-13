
local lspconfig = require "lspconfig"

return {
  root_dir = lspconfig.util.root_pattern("composer.json", ".git", "wp-config.php"),
  single_file_support = true
}
