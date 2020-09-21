package.path = '/var/www/lua/libs/?.lua;' .. package.path

local username = ngx.var["cookie_Link4Fun"]
local template = require "resty.template"
template.render("index.html", {
    username = username
})
