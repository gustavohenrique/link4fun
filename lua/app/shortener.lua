local M = {}
M.__index = M

local blocklist = {
    "http://link4.fun",
    "https://link4.fun",
    "http://" .. ngx.var.remote_addr,
    "https://" .. ngx.var.remote_addr,
    "http://" .. ngx.var.host,
    "https://" .. ngx.var.host
}

function M.new(deps)
    obj = { deps = deps }
    setmetatable(obj, M)
    return obj
end

function M:render_create(route)
    return function(route)
        route:render("shortener.html", { content = "" })
    end
end

function M:render_details(route, id)
    return function(route, id)
        local content, err = self:read(id)
        if err then
            return route:render("error.html", { error = err })
        end
        local context = route.context
        route:render("shortener.details.html", {
            site_url = context.site_url .. id,
            username = context.username,
            long_url = content.long_url,
            hits = content.hits
        })
    end
end

function M:submit_form(route)
    return function(route)
        id, err = self:save(route.context.form)
        if err then
            return route:render("error.html", { error = err })
        end
        route:redirect("/shortener/" .. id, 301)
    end
end

function M:redirect(route, id)
    return function(route, id)
        local content = self:read(id)
        if not content then
            return
        end
        local site_url = content.long_url
        content.hits = content.hits + 1
        self:__write_file(id, content)
        if self.deps.stringutils.is_valid_url(site_url) then
            return route:redirect(site_url, 302)
        end
        return route.redirect("http://" .. site_url, 302)
    end
end

function M:read(id)
    return self:__read_file(id)
end

function M:save(form)
    local stringutils = self.deps.stringutils
    local long_url = form.url
    if not stringutils.is_valid_url(long_url) then
       return nil, "URL is empty or invalid."
    end
    if stringutils.has_at_least_one(long_url, blocklist) then
        return nil, "You cannot use this domain."
    end

    local id = form.code
    if not id or id == "" then
        id = stringutils.random("xxxyx")
    end

    local err = self:__write_file(id, {
        long_url = long_url,
        hits = 0
    })
    return id, err
end

function M:__write_file(id, data)
    local filename = "shortener/" .. id
    local content = data.long_url .. "|" .. data.hits
    local fileutils = self.deps.fileutils
    return fileutils:write(filename, content)
end

function M:__read_file(id)
    local filename = "shortener/" .. id
    local content, err = self.deps.fileutils:read(filename)
    if err then
        return nil, err
    end
    local list = self.deps.stringutils.split(content, "|")
    return {
        long_url = list[1],
        hits = list[2]
    }, nil
end

return M
