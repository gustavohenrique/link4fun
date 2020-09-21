ngx.req.read_body()
local method = ngx.req.get_method()
if method ~= "POST" then
    ngx.say("error: unsupported method")
    ngx.exit(422)
end
local args, err = ngx.req.get_post_args(2)
if err == "truncated" then
    ngx.say("error: too many POST parameters.")
    ngx.exit(403)
end
if not args then
    ngx.say("error: failed to get post args: ", err)
    ngx.exit(500)
end

local siteUrl = args.url
if siteUrl == nill or siteUrl == "" then
    ngx.say("error: required parameter 'siteUrl' is empty")
    ngx.exit(400)
end

local code = args.code
if code == nill or code == "" then
    math.randomseed(os.clock()+os.time())
    local random = math.random
    local function randid()
        local template ='xxxyx'
        return string.gsub(template, '[xy]', function (c)
            local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
            return string.format('%x', v)
        end)
    end
    code = randid()
end

local filepath = "/var/www/html/links/" .. code
local file, err = io.open(filepath, "w")
if file == nill then
    ngx.say("error: couldnt open file: ", err)
    ngx.exit(500)
end 
local content = siteUrl .. "|0"
file:write(content)
file:close()

ngx.redirect("/u/" .. code)
