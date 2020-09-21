local filepath = "/var/www/html/links/" .. ngx.var.code
local file, err = io.open(filepath, "r")
if file == nill then
    ngx.say("error: couldnt open file: ", err)
    ngx.exit(500)
end 
content = file:read()
if content == nill or content == "" then
    ngx.say("error: file is empty")
    ngx.exit(500)
end
file:close()
local function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end
local table = split(content, "|")
local siteUrl = table[1]
local clicks = table[2]
local template = require "resty.template"
local view = template.new "link_details.html"
view.code = ngx.var.code
view.url = siteUrl
view.clicks = clicks
view:render()
