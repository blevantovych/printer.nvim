# printer.nvim

Neovim plugin that inserts a `console.log()` statement for the identifier under the cursor at a syntactically valid position. Uses tree-sitter to walk up the AST and find the right insertion point — handles cases where the cursor is inside an array, object, JSX, return statement, etc.

Scoped to JavaScript/TypeScript only.

## Installation

Requires [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) with a JavaScript or TypeScript parser installed.

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "blevantovych/printer.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  keys = {
    { "<leader>p", function() require("printer").add_console_log() end, desc = "Add console.log" },
  },
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "bodya17/printer.nvim",
  requires = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    vim.keymap.set("n", "<leader>p", function() require("printer").add_console_log() end, { desc = "Add console.log" })
  end,
}
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'bodya17/printer.nvim'

" After plug#end():
nnoremap <leader>p <cmd>lua require("printer").add_console_log()<cr>
```

## Usage

Place your cursor on any identifier in a JavaScript/TypeScript file and trigger the keymap (`<leader>p` with the suggested config). The plugin will insert:

```javascript
console.log({ variableName })
```

The statement is placed at a syntactically valid position — if the identifier is inside an array, object, JSX element, function parameters, or return statement, the print is inserted outside that construct rather than inline.

## Tests

To run tests, execute the following command in the `tests` directory:

```
./run_tests.sh
```
