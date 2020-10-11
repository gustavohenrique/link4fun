local constants = require "app.constants"

local M = {}
M.__index = M

function M.new(deps)
    obj = { deps = deps }
    setmetatable(obj, M)
    return obj
end

function M:render_create(route)
    return function(route)
        route:render("snippet.html", {
            content = "",
            syntaxes = constants.SYNTAXES
        })
    end
end

function M:render_details(route, id)
    return function(route, id)
        local snippet, err = self:read(id)
        if err then
            return route:render("error.html", { error = err })
        end
        local context = route.context
        route:render("snippet.details.html", {
            site_url = context.site_url .. "s/" .. id,
            username = context.username,
            id = id,
            content = snippet.content,
            syntax = snippet.syntax,
            syntax_name = constants.SYNTAXES[snippet.syntax]
        })
    end
end

function M:render_edit(route, id)
    return function(route, id)
        local snippet, err = self:read(id)
        if err then
            return route:render("error.html", { error = err })
        end
        local context = route.context
        route:render("snippet.html", {
            site_url = context.site_url .. "s/" .. id,
            username = context.username,
            id = id,
            content = snippet.content,
            syntax = snippet.syntax,
            syntaxes = constants.SYNTAXES
        })
    end
end

function M:submit_form(route)
    return function(route)
        id, err = self:save(route.context.form)
        if err then
            return route:render("error.html", { error = err })
        end
        route:redirect("/s/" .. id, 301)
    end
end

function M:read(id)
    local content = self:__read_file(id)
    return self.deps.stringutils.from_json(content)
end

function M:save(form)
    local stringutils = self.deps.stringutils
    local content = form.content
    if not content or content == "" then
       return nil, "The content is empty"
    end

    local syntax = form.syntax
    if not constants.SYNTAXES[syntax] then
        syntax = "plaintext"
    end

    local id = form.code
    if not id or id == "" then
        id = stringutils.random("xxxx4xxxxxxyxxxx")
    end

    local snippet = stringutils.to_json({
        syntax = syntax,
        content = content
    })

    local err = self:__write_file(id, snippet)
    return id, err
end

function M:__write_file(id, content)
    local filename = "snippet/" .. id
    local fileutils = self.deps.fileutils
    return fileutils:write(filename, content)
end

function M:__read_file(id)
    local filename = "snippet/" .. id
    local content, err = self.deps.fileutils:read(filename)
    if err then
        return nil, err
    end
    return content, nil
end

return M
