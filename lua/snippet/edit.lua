package.path = '/etc/nginx/conf.d/libs/?.lua;' .. package.path

local fileutils = require "fileutils"
local filepath = fileutils.getSnippetFilePath(ngx.var.code)
local file, err = io.open(filepath, "r")
if file == nill then
    ngx.say("error: couldnt open file: ", err)
    ngx.exit(500)
end 
content = file:read()
if content == nill or content == "" then
    ngx.say("error: file is empty")
    ngx.exit(500)
end
file:close()

local stringutils = require "stringutils";
local map = stringutils.fromJson(content)

local template = require "resty.template"
local view = template.new "snippet_edit.html"
view.code = ngx.var.code
view.syntax = map.syntax
view.snippet = map.snippet
view:render()


