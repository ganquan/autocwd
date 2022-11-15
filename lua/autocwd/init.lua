local plugin = "AutoCWD Plugin"

local M = {}
local _config = {}

function M.setup(config)
  -- Simple variant; could also be more complex with validation, etc.
  _config = config
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
    {bang = true, desc = 'a new command to do the thing'}
)

vim.keymap.set('n', '<leader>aw', auto_set_working_directory, {desc = 'Auto set working directory.', remap = false})

return M
