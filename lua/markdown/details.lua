package.path = '/etc/nginx/conf.d/libs/?.lua;' .. package.path

local fileutils = require "fileutils"
local filepath = fileutils.getMarkdownFilePath(ngx.var.code)

local file, err = io.open(filepath .. ".md", "r")
if err ~= nill then
    ngx.say("error: couldnt open file: ", err)
    ngx.exit(500)
end 
local content = file:read("*all")
if content == nill or content == "" then
    ngx.say("error: file is empty:", filepath)
    ngx.exit(500)
end
file:close()

if ngx.var.extension == ".md" then
    ngx.say("<pre>",content,"</pre>")
    return
end
local template = require "resty.template"
local view = template.new "markdown_details.html"
view.code = ngx.var.code
view.markdown = content
view:render()
