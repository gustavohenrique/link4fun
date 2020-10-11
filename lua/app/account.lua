local M = {}
M.__index = M

function M.new(deps)
    obj = { deps = deps }
    setmetatable(obj, M)
    return obj
end

function M:render_signin(route)
    return function(route)
        route:render("account.signin.html")
    end
end

function M:signin(route)
    return function(route)
        local auth = self.deps.auth
        local form = route.context.form
        ok = auth:login(form.username, form.password)
        if not ok then
            return route:render("error.html", { error = "Invalid username or password." })
        end
        local cookie_name = auth.cookie_name
        ngx.header["Set-Cookie"] = cookie_name .. "=" .. form.username .. "; Path=/; HttpOnly; Expires=" .. ngx.cookie_time(ngx.time() + 86400) .. ";Max-Age=86400;"
        route:redirect("/signin")
    end
end

function M:render_signout(route)
    return function(route)
        local cookie_name = self.deps.auth.cookie_name
        ngx.header["Set-Cookie"] = cookie_name .. "=" .. "; Path=/; HttpOnly; Expires=" .. ngx.cookie_time(ngx.time() - 86400) .. ";"
        route:redirect("/signin")
    end
end

return M
