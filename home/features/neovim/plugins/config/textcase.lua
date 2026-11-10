require('textcase').setup {
  prefix = "tc",
  keys = {
   "tc", -- Default invocation prefix
    { "tc.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
  }
}
require("telescope").load_extension("textcase")
