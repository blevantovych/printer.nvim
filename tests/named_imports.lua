local buffer_to_string = dofile('helpers.lua').buffer_to_string

describe("printer", function()
      local printer = require('printer')

      it("handles named imports", function()
          -- go to foo
          vim.api.nvim_win_set_cursor(0, {1, 9})
          printer.add_console_log()

          assert.are.equal([[
import { foo } from 'bar'
console.log({ foo })]], buffer_to_string())
    end)

end)
