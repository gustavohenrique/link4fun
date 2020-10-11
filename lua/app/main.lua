local M = {}
M.__index = M

function M.new(deps, template)
    obj = {
        deps = deps,
        template = template
    }
    setmetatable(obj, M)
    return obj
end

function M:render_index(route)
    return function(route)
        route:render("index.html")
    end
end

function M:add_middlewares_to(route)
    route:use(function(route)
        route.context.template = self.template
        route.context.username = self.deps.auth:get_username_from_cookie()
        route.context.site_url = ngx.var.site_url
    end)

    route.filter:post(function(route)
        ngx.req.read_body()
        local form = ngx.req.get_post_args()
        route.context.form = form
    end)
end

return M
