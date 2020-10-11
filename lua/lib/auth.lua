local resty_sha256 = require "resty.sha256"
local str = require "resty.string"

local M = {}
M.__index = M

function M.new(credentials)
    obj = credentials
    setmetatable(obj, M)
    return obj
end

function M:login(username, password)
    local hash = self:sha256(password)
    return username == self.username and hash == self.password
end

function M:sha256(value)
    local sha256 = resty_sha256:new()
    sha256:update(value)
    local digest = sha256:final()
    return str.to_hex(digest)
end

function M:get_username_from_cookie()
    return ngx.var["cookie_" .. self.cookie_name]
end

return M
