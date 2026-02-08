local buffer_to_string = dofile('helpers.lua').buffer_to_string

describe("printer", function()
      local printer = require('printer')

      it("handles tsx jsx element", function()
          -- go to count inside JSX
          vim.api.nvim_win_set_cursor(0, {3, 17})
          printer.add_console_log()

          assert.are.equal([[
function Counter() {
    const count = 0
    console.log({ count })
    return <div>{count}</div>
}]], buffer_to_string())
    end)

end)
