package.path = '/etc/nginx/conf.d/libs/?.lua;' .. package.path

local fileutils = require "fileutils"
local filepath = fileutils.getLinkFilePath(ngx.var.code)
local file, err = io.open(filepath, "r")
if file == nill then
    ngx.say("error: couldn't open file: ", err)
    ngx.exit(500)
end 
content = file:read()
if content == nill or content == "" then
    ngx.say("error: file is empty")
    ngx.exit(500)
end
file:close()

local stringutils = require "stringutils";
local table = stringutils.split(content, "|")
local siteUrl = table[1]
local clicks = table[2] + 1
local newContent = siteUrl .. "|" .. clicks
file = io.open(filepath, "w")
file:write(newContent)
file:close()

if stringutils.startswith(siteUrl, "http://") or stringutils.startswith(siteUrl, "https://") then
    return ngx.redirect(siteUrl, 302)
end
return ngx.redirect("http://" .. siteUrl)
