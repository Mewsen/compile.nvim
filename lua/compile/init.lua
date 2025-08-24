local M = {}

M.config = {
    max_depth = 1,
    default_makeprg = "make",
}

local function find_compile_file(start_path)
    local uv = vim.loop
    local cwd = start_path
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

local function read_command(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local cmd = file:read("*l")
    file:close()
    return cmd
end

function M.update_makeprg()
    local buf_dir = vim.fn.expand("%:p:h")
    if buf_dir == "" then
        buf_dir = vim.loop.cwd()
    end

    local compile_file = find_compile_file(buf_dir)
    if compile_file then
        local cmd = read_command(compile_file)
        if cmd and cmd ~= "" then
            vim.o.makeprg = cmd
            return
        end
    end
    vim.o.makeprg = M.config.default_makeprg
end

function M.setup(opts)
    M.config = vim.tbl_extend("force", M.config, opts or {})

    vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
        callback = M.update_makeprg,
    })

    vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = ".nvim-compile",
        callback = M.update_makeprg,
    })

    M.update_makeprg()
end

return M
