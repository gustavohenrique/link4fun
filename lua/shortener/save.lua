package.path = '/var/www/lua/libs/?.lua;' .. package.path

ngx.req.read_body()
local form, _ = ngx.req.get_post_args()
if not form then
    ngx.say("error: failed to get post form: ", err)
    ngx.exit(400)
end

local site_url = form.url
local stringutils = require "stringutils";
if not stringutils.is_valid_url(site_url) then
    ngx.say("error: site url is empty or invalid.")
    ngx.exit(400)
end

local blocklist = {
    "http://link4.fun",
    "https://link4.fun",
    "http://" .. ngx.var.remote_addr,
    "https://" .. ngx.var.remote_addr,
    "http://" .. ngx.var.host,
    "https://" .. ngx.var.host
}
if stringutils.has_at_least_one(site_url, blocklist) then
    ngx.say("error: the long URL cannot use this domain.")
    ngx.exit(400)
end

local code = form.code
if not code or code == "" then
    code = stringutils.random("xxxyx")
end

local fileutils = require "fileutils"
local filename = fileutils.get_shortener_file(code)
local file, err = io.open(filename, "w")
if not file then
    ngx.say("error: couldn't open file: ", err)
    ngx.exit(500)
end 
local content = site_url .. "|0"
file:write(content)
file:close()

ngx.redirect("/0/" .. code)
