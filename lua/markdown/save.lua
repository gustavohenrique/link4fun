package.path = '/etc/nginx/conf.d/libs/?.lua;' .. package.path

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

local markdown = args.markdown
if markdown == nill or markdown == "" then
    ngx.say("error: required parameter 'markdown' is empty")
    ngx.exit(400)
end

local stringutils = require "stringutils";
local code = args.code
if code == nill or code == "" then
    code = stringutils.random("xxxx4xxxxxxyxxxx")
end

local fileutils = require "fileutils"
local filepath = fileutils.getMarkdownFilePath(code)

local file, err = io.open(filepath .. ".md", "w")
if file == nill then
    ngx.say("error: couldnt open file: ", err)
    ngx.exit(500)
end
file:write(markdown)
file:close()

ngx.redirect("/md/" .. code .. ".html")
