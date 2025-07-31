local M = {}

M.config = {
    max_depth = 5,
}

function M.setup(opts)
    M.config = vim.tbl_extend("force", M.config, opts or {})

    -- Update makeprg when entering a buffer
    vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
        callback = function()
            local cmd = M.read_command()
            if cmd then
                vim.opt.makeprg = cmd
            else
                vim.opt.makeprg = "make" -- default
            end
        end,
    })
end

-- Search up the tree for .nvim-compile
function M.find_compile_file()
    local uv = vim.loop
    local cwd = uv.cwd()
    local depth = 0

    while cwd and depth <= M.config.max_depth do
        local target = cwd .. "/.nvim-compile"
        local stat = uv.fs_stat(target)
        if stat and stat.type == "file" then
            return target
        end
        local parent = cwd:match("(.+)/[^/]+$")
        if not parent or parent == cwd then break end
        cwd = parent
        depth = depth + 1
    end
    return nil
end

-- Read first line as command
function M.read_command()
    local path = M.find_compile_file()
    if not path then return nil end
    local file = io.open(path, "r")
    if not file then return nil end
    local cmd = file:read("*l") -- first line
    file:close()
    return cmd
end

return M
