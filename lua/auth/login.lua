package.path = '/var/www/lua/libs/?.lua;' .. package.path

ngx.req.read_body()
local method = ngx.req.get_method()
if method ~= "POST" then
    ngx.say("error: unsupported method")
    ngx.exit(422)
end
local args, err = ngx.req.get_post_args(2)
if err == "truncated" then
    ngx.say("error: too many POST parameters.")
    ngx.exit(403)
end
if not args then
    ngx.say("error: failed to get post args: ", err)
    ngx.exit(500)
end

local username = args.username
local password = args.password
local auth = require "auth"
if not auth.login(username, password) then
    ngx.say("error: invalid username or password")
    ngx.exit(401)
end

ngx.header["Set-Cookie"] = "Link4Fun=" .. username .. "; Path=/; HttpOnly; Expires=" .. ngx.cookie_time(ngx.time() + 1800) .. ";Max-Age=1800;"
return ngx.redirect("/")
