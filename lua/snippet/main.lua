package.path = '/var/www/lua/libs/?.lua;' .. package.path

local constants = require "constants"
local username = ngx.var[constants.COOKIE_NAME]

local template = require "resty.template"
template.render("snippet.html", {
    username = username,
    syntaxes = constants.SYNTAXES
})
