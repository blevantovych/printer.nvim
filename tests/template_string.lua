local buffer_to_string = dofile('helpers.lua').buffer_to_string

describe("printer", function()
      local printer = require('printer')

      it("handles template string", function()
          -- go to name
          vim.api.nvim_win_set_cursor(0, {1, 20})
          printer.add_console_log()

          assert.are.equal([[
const s = `hello ${name}`
console.log({ name })]], buffer_to_string())
    end)

end)
