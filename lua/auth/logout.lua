package.path = '/var/www/lua/libs/?.lua;' .. package.path

ngx.header["Set-Cookie"] = {}
local template = require "resty.template"
template.render("index.html", {
    username = nil
})
