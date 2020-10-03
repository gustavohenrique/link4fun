package.path = '/var/www/lua/libs/?.lua;' .. package.path

local fileutils = require "fileutils"
local code = ngx.var.code
local filename = fileutils.get_markdown_file(code)

local file, err = io.open(filename .. ".md", "r")
if err then
    ngx.say("error: couldnt open file: ", err)
    ngx.exit(500)
end 
local content = file:read("*all")
if not content or content == "" then
    ngx.say("error: file is empty:", filename)
    ngx.exit(500)
end
file:close()

if ngx.var.extension == ".md" then
    ngx.say("<pre>",content,"</pre>")
    return
end

local constants = require "constants"
local username = ngx.var[constants.COOKIE_NAME]

local template = require "resty.template"
template.render("markdown.details.html", {
    username = username,
    unescaped_url = ngx.var.unescaped_url .. "2/" .. code,
    escaped_url = ngx.var.escaped_url .. "2%2F" .. code,
    code = code,
    markdown = content
})
