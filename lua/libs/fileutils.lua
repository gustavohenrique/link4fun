local M = {}

function M.get_root_dir()
    return "/var/www/data"
end

function M.get_shortener_file(filename)
    return M.get_root_dir() .. "/shortener/" .. filename
end

function M.get_snippet_file(filename)
    return M.get_root_dir() .. "/snippet/" .. filename
end

function M.get_markdown_file(filename)
    return M.get_root_dir() .. "/markdown/" .. filename
end

return M
