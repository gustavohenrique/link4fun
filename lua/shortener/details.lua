package.path = '/var/www/lua/libs/?.lua;' .. package.path

local fileutils = require "fileutils"
local filename = fileutils.get_shortener_file(ngx.var.code)
local file, err = io.open(filename, "r")
if not file then
    ngx.say("error: couldn't open file: ", err)
    ngx.exit(500)
end 
content = file:read()
if not content or content == "" then
    ngx.say("error: file is empty")
    ngx.exit(500)
end
file:close()

local stringutils = require "stringutils";
local list = stringutils.split(content, "|")

local template = require "resty.template"
template.render("shortener.details.html", {
    code = ngx.var.code,
    escaped_url = ngx.var.escaped_url .. ngx.var.code,
    unescaped_url = ngx.var.unescaped_url .. ngx.var.code,
    url = list[1],
    clicks = list[2]
})
