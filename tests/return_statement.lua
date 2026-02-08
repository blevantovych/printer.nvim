local buffer_to_string = dofile('helpers.lua').buffer_to_string

describe("printer", function()
      local printer = require('printer')

      it("handles return statement", function()
          -- go to foo
          vim.api.nvim_win_set_cursor(0, {2, 11})
          printer.add_console_log()

          assert.are.equal([[
function f() {
    console.log({ foo })
    return foo
}]], buffer_to_string())
    end)

end)
