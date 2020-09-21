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

function M.toJson(content)
    return cjson.encode(content)
end

function M.fromJson(content)
    return cjson.decode(content)
end

return M
