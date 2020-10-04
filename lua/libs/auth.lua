local M = {}

local user = {
  username = "demo",
  password = "demo"
}

function M.login(username, password)
    if username ~= user.username or password ~= user.password then
        return false
    end
    return true
end

return M
