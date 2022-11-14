local plugin = "AutoCWD Plugin"

local nt_api = require("nvim-tree.api")

-- By convention, nvim Lua plugins include a setup function that takes a table
-- so that users of the plugin can configure it using this pattern:
--
-- require'myluamodule'.setup({p1 = "value1"})
local function setup(parameters)
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
        nt_api.tree.change_root(root_dir)
        vim.notify(str, "info", { 
            title = plugin,
            timeout = 3000 })
    end
end

-- Create a command, ':Aw'
vim.api.nvim_create_user_command(
    'AutoCWD',
    auto_set_working_directory,
    {bang = true, desc = 'a new command to do the thing'}
)

vim.keymap.set('n', '<leader>aw', auto_set_working_directory, {desc = 'Auto set working directory.', remap = false})


-- Returning a Lua table at the end allows fine control of the symbols that
-- will be available outside this file. Returning the table also allows the
-- importer to decide what name to use for this module in their own code.
--
-- Examples of how this module can be imported:
--    local mine = require('myluamodule')
--    mine.local_lua_function()
--    local myluamodule = require('myluamodule')
--    myluamodule.local_lua_function()
--    require'myluamodule'.setup({p1 = "value1"})
return {
    setup = setup,
}
