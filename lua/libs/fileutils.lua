local M = {}

function M.getHtmlFilePath()
    return "/var/www/html"
end

function M.getLinkFilePath(name)
    return "/var/www/html/links/" .. name
end

function M.getSnippetFilePath(name)
    return "/var/www/html/snippets/" .. name
end

function M.getMarkdownFilePath(name)
    return "/var/www/html/markdowns/" .. name
end

return M
