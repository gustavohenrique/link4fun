package.path = '/etc/nginx/conf.d/libs/?.lua;' .. package.path

ngx.req.read_body()
local method = ngx.req.get_method()
if method ~= "POST" then
    ngx.say("error: unsupported method")
    ngx.exit(422)
end
local args, err = ngx.req.get_post_args(3)
if err == "truncated" then
    ngx.say("error: too many POST parameters.")
    ngx.exit(403)
end
if not args then
    ngx.say("error: failed to get post args: ", err)
    ngx.exit(500)
end

local snippet = args.snippet
if snippet == nill or snippet == "" then
    ngx.say("error: required parameter 'snippet' is empty")
    ngx.exit(400)
end

local syntax = args.syntax
if syntax == nill then
    syntax = "plaintext"
end
local stringutils = require "stringutils";
local code = args.code
if code == nill or code == "" then
    code = stringutils.random("xxxx4xxxxxxyxxxx")
end

local fileutils = require "fileutils"
local filepath = fileutils.getSnippetFilePath(code)
local file, err = io.open(filepath, "w")
if file == nill then
    ngx.say("error: couldnt open file: ", err)
    ngx.exit(500)
end 

local content = stringutils.toJson({
    syntax = syntax,
    snippet = snippet
})
file:write(content)
file:close()

ngx.redirect("/1/" .. code)

