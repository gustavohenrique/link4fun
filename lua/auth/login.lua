package.path = '/var/www/lua/libs/?.lua;' .. package.path

ngx.req.read_body()
local method = ngx.req.get_method()
if method ~= "POST" then
    local constants = require "constants"
    local username = ngx.var[constants.COOKIE_NAME]
    local template = require "resty.template"
    return template.render("login.html", { username = username })
end
local form, _ = ngx.req.get_post_args(2)
if not form then
    ngx.say("error: failed to get post args: ", err)
    ngx.exit(500)
end

local username = form.username
local password = form.password
local auth = require "auth"
if not auth.login(username, password) then
    ngx.say("error: invalid username or password.")
    ngx.exit(401)
end

ngx.header["Set-Cookie"] = "Link4Fun=" .. username .. "; Path=/; HttpOnly; Expires=" .. ngx.cookie_time(ngx.time() + 86400) .. ";Max-Age=86400;"
return ngx.redirect("/login")
