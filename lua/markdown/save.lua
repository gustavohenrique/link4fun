package.path = '/var/www/lua/libs/?.lua;' .. package.path

ngx.req.read_body()
local form, err = ngx.req.get_post_args(2)
if err then
    ngx.say("error: failed to get post args: ", err)
    ngx.exit(500)
end

local markdown = form.markdown
if not markdown or markdown == "" then
    ngx.say("error: required parameter 'markdown' is empty")
    ngx.exit(400)
end

local stringutils = require "stringutils";
local code = form.code
if not code or code == "" then
    code = stringutils.random("xxxx4xxxxxxyxxxx")
end

local fileutils = require "fileutils"
local filename = fileutils.get_markdown_file(code)

local file, err = io.open(filename .. ".md", "w")
if err then
    ngx.say("error: couldn't open file: ", err)
    ngx.exit(500)
end
file:write(markdown)
file:close()

ngx.redirect("/2/" .. code .. ".html")
