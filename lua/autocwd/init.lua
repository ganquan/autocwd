local plugin = "AutoCWD Plugin"

local M = {}
local _config = {}

function M.setup(config)
  -- Simple variant; could also be more complex with validation, etc.
  _config = config
end

local function toggle_quickfix()
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            qf_exists = true
        end
    end
    if qf_exists == true then
        vim.cmd "cclose"
        return
    end
    if not vim.tbl_isempty(vim.fn.getqflist()) then
        vim.cmd "copen"
    end
end


function M.do_something()
   local option_x = _config.option_x or 'some_default_value'
   -- ...
end


local function auto_set_working_directory()
    local root_dir
    for dir in vim.fs.parents(vim.api.nvim_buf_get_name(0)) do
        if vim.fn.isdirectory(dir .. "/.git") == 1 then
            root_dir = dir
            break
        end
    end

    if root_dir then
        local pwd = vim.fn.getcwd()
        local str = "Change CWD: "..pwd.." to "..root_dir
        print(str)
        vim.cmd {cmd = 'cd', args = {root_dir} }
        local nt_api = require("nvim-tree.api")
        nt_api.tree.change_root(root_dir)
        vim.notify(str, "info", { 
            title = plugin,
            timeout = 3000 })
    end
end

-- Create a command, ':AutoCWD'
vim.api.nvim_create_user_command(
    'AutoCWD',
    auto_set_working_directory,
    {bang = true, desc = 'Auto set working directory.'}
)

vim.api.nvim_create_user_command(
    'Toggleqf',
    toggle_quickfix,
    {bang = true, desc = 'Toggle QuickFix.'}
)

vim.keymap.set('n', '<leader>aw', auto_set_working_directory, {desc = 'Auto set working directory.', remap = false})
vim.keymap.set('n', '<leader>q', toggle_quickfix, {desc = 'Toggle quickfix', remap = false})

return M
