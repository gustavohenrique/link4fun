local hoedown = require "resty.hoedown"

local M = {}
M.__index = M

function M.new(deps)
    obj = { deps = deps }
    setmetatable(obj, M)
    return obj
end

function M:render_create(route)
    return function(route)
        route:render("markdown.html", { content = "" })
    end
end

function M:render_details(route, id)
    return function(route, id)
        -- local callback = function(id) return self:read(id) end
        -- local content, err = cache:get(id, { ttl = 30 }, callback, id)
        local content, err = self:read(id)
        if err then
            return route:render("error.html", { error = err })
        end
        if id:match(".md$") then
            ngx.say("<pre>", content, "</pre>")
            route:done()
        end
        local template_file = "markdown.details.html"
        if id:match(".html$") then
            template_file = "markdown.rendered.html"
            content = hoedown(content)
        end
        local context = route.context
        route:render(template_file, {
            site_url = context.site_url .. "m/" .. id,
            username = context.username,
            id = id,
            content = content
        })
    end
end

function M:render_edit(route, id)
    return function(route, id)
        local content, err = self:read(id)
        if err then
            return route:render("error.html", { error = err })
        end
        local context = route.context
        route:render("markdown.html", {
            site_url = context.site_url .. "m/" .. id,
            username = context.username,
            id = id,
            content = content
        })
    end
end

function M:submit_form(route)
    return function(route)
        id, err = self:save(route.context.form)
        if err then
            return route:render("error.html", { error = err })
        end
        route:redirect("/m/" .. id, 301)
    end
end

function M:read(id)
    local filename = id
    local idx = id:find("%f[.]")
    if idx then
        filename = id:sub(0, idx - 1)
    end
    return self:__read_file(filename .. ".md")
end

function M:save(form)
    local stringutils = self.deps.stringutils
    local content = form.content
    if not content or content == "" then
       return nil, "content is empty"
    end

    local id = form.code
    if not id or id == "" then
        id = stringutils.random("xxxx4xxxxxxyxxxx")
    end

    local err = self:__write_file(id, content)
    return id, err
end

function M:__write_file(id, content)
    local filename = "markdown/" .. id .. ".md"
    local fileutils = self.deps.fileutils
    return fileutils:write(filename, content)
end

function M:__read_file(id)
    local filename = "markdown/" .. id
    local content, err = self.deps.fileutils:read(filename)
    if err then
        return nil, err
    end
    return content, nil
end

return M
