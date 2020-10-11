local M = {}
local cjson = require "cjson"

function M.split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function M.startswith(s, value)
    return string.sub(s, 1, string.len(value)) == value
end

function M.has_at_least_one(s, array)
    for _, item in pairs(array) do
        if M.startswith(s, item) then
            return true
        end
    end
    return false
end

function M.random(template)
    math.randomseed(os.clock()+os.time())
    local rnd = math.random
    local function randid()
        return string.gsub(template, '[xy]', function (c)
            local v = (c == 'x') and rnd(0, 0xf) or rnd(8, 0xb)
            return string.format('%x', v)
        end)
    end
    return randid()
end

function M.is_valid_url(url)
    if url == nill or url == "" then
        return false
    end
    local i, _ = string.find(url, "://", 1, true)
    return i ~= nill
end

function M.to_json(content)
    return cjson.encode(content)
end

function M.from_json(content)
    return cjson.decode(content)
end

return M
