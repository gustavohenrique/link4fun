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

return M
