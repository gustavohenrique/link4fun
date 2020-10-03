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
local table = stringutils.split(content, "|")
local site_url = table[1]
local clicks = table[2] + 1
local newContent = site_url .. "|" .. clicks
file = io.open(filename, "w")
file:write(newContent)
file:close()

if stringutils.is_valid_url(site_url) then
    return ngx.redirect(site_url, 302)
end
return ngx.redirect("http://" .. site_url)
