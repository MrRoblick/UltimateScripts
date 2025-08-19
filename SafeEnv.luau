local RobloxEnv = getrenv()
local old; old = hookfunction(RobloxEnv.getfenv, newcclosure(function(level: number | (...any) -> ...any): ()
    local env = old(level)
    if not checkcaller() and env and typeof(level) == "number" and (isexecutorclosure(debug.getinfo(level).func) or getrawmetatable(env).__index == getgenv()) then
        return nil
   end
   return old(level)
end))
