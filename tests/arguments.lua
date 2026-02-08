local buffer_to_string = dofile('helpers.lua').buffer_to_string

describe("printer", function()
      local printer = require('printer')

      it("handles arguments", function()
          -- go to value
          vim.api.nvim_win_set_cursor(0, {1, 12})
          printer.add_console_log()

          assert.are.equal([[
doSomething(value)
console.log({ value })]], buffer_to_string())
    end)

end)
