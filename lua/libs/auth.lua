local M = {}

local user = {
  username = "gustavo",
  password = "henrique"
}

function M.login(username, password)
    if username ~= user.username or password ~= user.password then
        return false
    end
    return true
end

return M
