local buffer_to_string = dofile('helpers.lua').buffer_to_string

describe("printer", function()
      local printer = require('printer')

      it("handles jsx element", function()
          -- go to userName
          vim.api.nvim_win_set_cursor(0, {2, 17})
          printer.add_console_log()

          assert.are.equal([[
function App() {
    console.log({ userName })
    return <div>{userName}</div>
}]], buffer_to_string())
    end)

end)
