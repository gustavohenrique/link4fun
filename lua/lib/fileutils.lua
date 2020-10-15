local M = {}
M.__index = M

function M.new(data_dir)
    obj = {
        data_dir = data_dir
    }
    setmetatable(obj, M)
    return obj
end

function M:write(filename, content)
    local file, err = io.open(self.data_dir .. filename, "w")
    if not file then
        return "couldn't open file: " .. err
    end 
    file:write(content)
    file:close()
end

function M:read(filename)
    -- local data_dir = "/var/www/data/"
    local file, err = io.open(self.data_dir .. filename, "r")
    if not file then
        return nil, "couldn't open file: " .. err
    end 
    content = file:read("a")
    if not content or content == "" then
        return nil, "file is empty"
    end
    file:close()
    return content, nil
end

function M:list_files_from_data_dir(dir)
    local directory = self.data_dir .. dir
    local filehandler = assert(io.popen(("find '%s' -mindepth 1 -maxdepth 1 -type f -exec ls -1rt \"{}\" +;"):format(directory), "r"))
    local list = filehandler:read('*a')
    filehandler:close()
    local files = {}
    for filepath in string.gmatch(list, "[^\r\n]+") do
        local filename = filepath:match("^.+/(.+)$")
        table.insert(files, filename)
    end
    return files
end

return M
