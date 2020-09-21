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

local siteUrl = args.url
if siteUrl == nill or siteUrl == "" then
    ngx.say("error: required parameter 'siteUrl' is empty")
    ngx.exit(400)
end

local code = args.code
if code == nill or code == "" then
    local stringutils = require "stringutils";
    code = stringutils.random("xxxyx")
end

local fileutils = require "fileutils"
local filepath = fileutils.getLinkFilePath(code)
local file, err = io.open(filepath, "w")
if file == nill then
    ngx.say("error: couldnt open file: ", err)
    ngx.exit(500)
end 
local content = siteUrl .. "|0"
file:write(content)
file:close()

ngx.redirect("/0/" .. code)
