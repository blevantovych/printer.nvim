local ts_utils = require("nvim-treesitter.ts_utils")

local function i(arg)
    print(vim.inspect(arg))
end

local function m(arg)
    i(getmetatable(arg))
end

-- https://stackoverflow.com/questions/33510736/check-if-array-contains-specific-value/33511182
local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local function should_be_above(type)
    return has_value({'return_statement', 'parenthesized_expression'}, type)
end

local function is_identifier_under_cursor()
    local node = ts_utils.get_node_at_cursor()
    return node:type() == 'identifier' or node:type() == 'shorthand_property_identifier_pattern'
end

local function is_inside_where_we_cannot_add_print_statement()
    local temp = ts_utils.get_node_at_cursor()
    local node
    while temp ~= nil do
        if has_value({
                    'object',
                    'object_pattern',
                    'jsx_element',
                    'named_imports' ,
                    'ternary_expression',
                    'parenthesized_expression',
                    'return_statement',
                    'array',
                    -- 'variable_declarator',
                    'template_string',
                    'formal_parameters',
                    'arguments'
                }, temp:type()) then
            node = temp
        end
        if temp:type() == 'statement_block' then
            break
        end
        print(temp:type())
        temp = temp:parent()
    end

    if node then
        local start_row, start_col, end_row, end_col = node:range()
        return true, should_be_above(node:type()), start_row, start_col, end_row, end_col
    end

    return false
end


local M = {}

M.add_console_log = function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    if not is_identifier_under_cursor() then
        return
    end

    local cannot_add_console_log_inside, above, start_row, start_col, end_row, end_col = is_inside_where_we_cannot_add_print_statement()
    local word_under_cursor = vim.fn.expand('<cword>')
    local print_statement = 'console.log({ ' .. word_under_cursor .. ' })'

    if (cannot_add_console_log_inside) then
        if (above) then
            vim.api.nvim_buf_set_lines(0, start_row, start_row, false, {print_statement})
            vim.cmd(':' .. start_row+1)
        else
            vim.api.nvim_buf_set_lines(0, end_row+1, end_row+1, false, {print_statement})
            vim.cmd(':' .. end_row+2)
        end
    else 
        vim.api.nvim_buf_set_lines(0, row, row, false, {print_statement})
        vim.cmd(':' .. row+1)
    end

    -- align line
    vim.api.nvim_feedkeys('=', 'n', false)
    vim.api.nvim_feedkeys('=', 'n', false)
end

return M
