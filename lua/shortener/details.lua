package.path = '/var/www/lua/libs/?.lua;' .. package.path

local fileutils = require "fileutils"
local filepath = fileutils.getLinkFilePath(ngx.var.code)
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
local list = stringutils.split(content, "|")

local username = ngx.var["cookie_Link4Fun"]
local template = require "resty.template"
template.render("shortener.details.html", {
    username = username,
    code = ngx.var.code,
    escaped_url = ngx.var.escaped_url .. ngx.var.code,
    unescaped_url = ngx.var.unescaped_url .. ngx.var.code,
    url = list[1],
    clicks = list[2]
})
