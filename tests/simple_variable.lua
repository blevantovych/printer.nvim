local buffer_to_string = dofile('helpers.lua').buffer_to_string

describe("printer", function()
      local printer = require('printer')

      it("handles simple variable", function()
          -- go to foo
          vim.api.nvim_win_set_cursor(0, {1, 6})
          printer.add_console_log()

          assert.are.equal([[
const foo = 123
console.log({ foo })]], buffer_to_string())
    end)

end)
