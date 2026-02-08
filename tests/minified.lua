local buffer_to_string = dofile('helpers.lua').buffer_to_string

describe("printer", function()
      local printer = require('printer')

      it("handles minified object", function()
          -- go to foo (value, col 14)
          vim.api.nvim_win_set_cursor(0, {1, 14})
          printer.add_console_log()

          assert.are.equal([[
const o={foo:foo};
console.log({ foo })]], buffer_to_string())
    end)

end)
