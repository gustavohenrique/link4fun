local ffi      = require "ffi"
local ffi_load = ffi.load

return ffi_load "/var/www/lua/lib/resty/hoedown/libhoedown.so"
