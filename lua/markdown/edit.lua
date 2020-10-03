package.path = '/etc/nginx/conf.d/libs/?.lua;' .. package.path

local fileutils = require "fileutils"
local filename = fileutils.get_markdown_file(ngx.var.code)
local file, err = io.open(filename .. ".md", "r")
if err then
    ngx.say("error: couldnt open file: ", err)
    ngx.exit(500)
end 
local content = file:read("*all")
if not content or content == "" then
    ngx.say("error: file is empty")
    ngx.exit(500)
end
file:close()

local template = require "resty.template"
template.render("markdown.html", {
    code = ngx.var.code,
    markdown = content
})
