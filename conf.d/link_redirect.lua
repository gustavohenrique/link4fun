local filepath = "/var/www/html/links/" .. ngx.var.code
local file, err = io.open(filepath, "r")
if file == nill then
    ngx.say("error: couldn't open file: ", err)
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
local clicks = table[2] + 1
local newContent = siteUrl .. "|" .. clicks
file = io.open(filepath, "w")
file:write(newContent)
file:close()

local function startswith(s, value)
    return string.sub(s, 1, string.len(value)) == value
end
if startswith(siteUrl, "http://") or startswith(siteUrl, "https://") then
    return ngx.redirect(siteUrl, 302)
end
return ngx.redirect("http://" .. siteUrl)
