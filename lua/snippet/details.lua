package.path = '/var/www/lua/libs/?.lua;' .. package.path

local fileutils = require "fileutils"
local filename = fileutils.get_snippet_file(ngx.var.code)
local file, err = io.open(filename, "r")
if not file then
    ngx.say("error: couldnt open file: ", err)
    ngx.exit(500)
end 
content = file:read()
if not content or content == "" then
    ngx.say("error: file is empty")
    ngx.exit(500)
end
file:close()

local stringutils = require "stringutils";
local map = stringutils.from_json(content)
local constants = require "constants"
local username = ngx.var[constants.COOKIE_NAME]
local template = require "resty.template"
template.render("snippet.details.html", {
    username = username,
    unescaped_url = ngx.var.unescaped_url .. "1/" .. ngx.var.code,
    escaped_url = ngx.var.escaped_url .. "1%2F" .. ngx.var.code,
    code = ngx.var.code,
    snippet = map.snippet,
    syntax = map.syntax,
    syntax_name = constants.SYNTAXES[map.syntax]
})
