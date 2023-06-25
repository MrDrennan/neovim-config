local M = {
  "akinsho/toggleterm.nvim",
  commit = "19aad0f41f47affbba1274f05e3c067e6d718e1e",
  event = "VeryLazy",
}

function M.config()
  local status_ok, toggleterm = pcall(require, "toggleterm")
  if not status_ok then
    return
  end

  toggleterm.setup {
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "tab",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = "curved",
    },
  }

  function _G.set_terminal_keymaps()
    local opts = { noremap = true }
    -- vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
  end

  vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"

  local Terminal = require("toggleterm.terminal").Terminal

  function GET_CURR_BUFFER()
    return string.gsub(vim.api.nvim_buf_get_name(0), "\\", "/")
  end

  function GET_CURR_WORKING_DIR()
    return string.gsub(vim.fn.getcwd(), "\\", "/")
  end

  function _LAZYGIT_TOGGLE()
    local lazygit_cmd =  'lazygit -p "' .. GET_CURR_WORKING_DIR() .. '"'

    local lazygit = Terminal:new { cmd = lazygit_cmd, hidden = true }
    lazygit:toggle()
  end

  function _FROGMOUTH_TOGGLE()
    local frogmouth_cmd = 'frogmouth "' .. GET_CURR_BUFFER() .. '"'

    local frogmouth = Terminal:new { cmd = frogmouth_cmd, hidden = true }
    frogmouth:toggle()
  end
end

return M
