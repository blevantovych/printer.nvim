local buffer_to_string = function()
    local content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
    return table.concat(content, "\n")
end

describe("printer", function()
      local printer = require('printer')

      it("handles callback arrow function", function()
          -- go to index
          vim.api.nvim_win_set_cursor(0, {1, 18})
          printer.add_console_log()

          assert.are.equal([[
[1, 2, 3].map((n, index) => {
    console.log({ index })
});]], buffer_to_string())
    end)

end)

