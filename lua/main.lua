local template = require "resty.template"
local route = require "resty.route".new()

local deps = {
    auth = require "lib.auth".new({
        username = ngx.var.admin_username,
        password = ngx.var.admin_password,
        cookie_name = ngx.var.auth_cookie_name
    }),
    stringutils = require "lib.stringutils",
    fileutils = require "lib.fileutils".new(ngx.var.data_dir)
}

local app = require "app.main".new(deps, template)
app:add_middlewares_to(route)
route:get("=/", app:render_index())

local account = require "app.account".new(deps)
route:get("=/signin", account:render_signin())
route:get("=/signout", account:render_signout())
route:post("=/account/signin", account:signin())

local markdown = require "app.markdown".new(deps)
route:get("=/markdown", markdown:render_create())
route:get("@/markdown/:string/edit", markdown:render_edit())
route:get("@/m/:string", markdown:render_details())
route:post("=/markdown/save", markdown:submit_form())

local snippet = require "app.snippet".new(deps)
route:get("=/snippet", snippet:render_create())
route:get("@/snippet/:string/edit", snippet:render_edit())
route:get("@/s/:string", snippet:render_details())
route:post("=/snippet/save", snippet:submit_form())

local shortener = require "app.shortener".new(deps)
route:get("=/shortener", shortener:render_create())
route:get("@/shortener/:string", shortener:render_details())
route:post("=/shortener/save", shortener:submit_form())
route:get("@/:string", shortener:redirect())


route:dispatch()
