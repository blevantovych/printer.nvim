local buffer_to_string = function()
    local content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
    return table.concat(content, "\n")
end

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
