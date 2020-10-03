package.path = '/var/www/lua/libs/?.lua;' .. package.path

ngx.req.read_body()
local form, _ = ngx.req.get_post_args(3)
if not form then
    ngx.say("error: failed to get post form: ", err)
    ngx.exit(500)
end

local snippet = form.snippet
if not snippet or snippet == "" then
    ngx.say("error: required parameter 'snippet' is empty")
    ngx.exit(400)
end

local constants = require "constants"
local syntax = form.syntax
if not constants.SYNTAXES[syntax] then
    syntax = "plaintext"
end
local stringutils = require "stringutils";
local code = form.code
if not code or code == "" then
    code = stringutils.random("xxxx4xxxxxxyxxxx")
end

local fileutils = require "fileutils"
local filename = fileutils.get_snippet_file(code)
local file, err = io.open(filename, "w")
if not file then
    ngx.say("error: couldnt open file: ", err)
    ngx.exit(500)
end 

local content = stringutils.to_json({
    syntax = syntax,
    snippet = snippet
})
file:write(content)
file:close()

ngx.redirect("/1/" .. code)
