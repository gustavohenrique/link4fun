ngx.header["Set-Cookie"] = "Link4Fun=" .. "; Path=/; HttpOnly; Expires=" .. ngx.cookie_time(ngx.time() - 86400) .. ";"
return ngx.redirect("/login")
