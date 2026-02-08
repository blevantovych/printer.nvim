# printer.nvim

Neovim plugin that inserts a `console.log()` statement for the identifier under the cursor at a syntactically valid position. Uses tree-sitter to walk up the AST and find the right insertion point — handles cases where the cursor is inside an array, object, JSX, return statement, etc.

Scoped to JavaScript/TypeScript only.

## Architecture

Single module: `lua/printer.lua`. No configuration system, no setup function — just one exported function `M.add_console_log()`.

**Flow:**
1. Validate cursor is on an `identifier` or `shorthand_property_identifier_pattern` node
2. Walk up the AST looking for "restricted" parent nodes (object, array, jsx_element, formal_parameters, etc.)
3. If inside a restricted node, insert the print statement above or below that node (above for return_statement/parenthesized_expression, below for everything else)
4. If not restricted, insert below the current line
5. Auto-indent the inserted line with `==`

**Dependency:** `nvim-treesitter` (uses `nvim-treesitter.ts_utils`)

## Tests

Tests use Plenary (`PlenaryBustedFile`). Each test case is a pair of files in `tests/`:
- `<name>.js` — input fixture (the buffer content)
- `<name>.lua` — test spec that positions cursor, calls `add_console_log()`, and asserts buffer content

Run from the `tests/` directory:
```
./run_tests.sh
```

**Known issues:**
- `arrow_function` test is a known failing test (commit `0e24a06`) — cursor on `index` in `[1,2,3].map((n, index) => {})` should insert inside the function body
- Array/object tests have TODOs for printing the variable on the left side of the declaration (e.g., `arr` in `const arr = [...]`)

## Print statement format

```
console.log({ variableName })
```

Uses JS object shorthand so the logged output shows both the name and value.
