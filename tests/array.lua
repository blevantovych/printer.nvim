local buffer_to_string = dofile('helpers.lua').buffer_to_string

describe("printer", function()
      local printer = require('printer')

      it("handles array", function()
          -- go to arr
          -- TODO: this doesn't work currently
          -- vim.api.nvim_win_set_cursor(0, {1, 6})
          -- printer.add_console_log()

          -- go to foo
          vim.api.nvim_win_set_cursor(0, {2, 4})
          printer.add_console_log()

          -- go to bar
          vim.api.nvim_win_set_cursor(0, {3, 4})
          printer.add_console_log()

          assert.are.equal([[
const arr = [
    foo,
    bar
];
console.log({ bar })
console.log({ foo })]], buffer_to_string())
    end)

end)
