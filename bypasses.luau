print("# Very cool bypasses enabled, by @delovoymuzhchina")

local PlayerClass = Instance.new('Player')

local RobloxEnv = getrenv()
local ExploitEnv = getgenv()


local old; old = hookfunction(RobloxEnv.debug.info, newcclosure(function(level: number, option: string): ()
    if option == "l" then
        return nil
    end
    return old(level, option)
end))

local old; old = hookfunction(RobloxEnv.getfenv, newcclosure(function(level: number | (...any) -> ...any): ()
    local env = old(level)
    if not checkcaller() and env and typeof(level) == "number" and (getrawmetatable(env).__index == getgenv()) then
        error("invalid argument #1 to 'getfenv' (invalid level)")
   end
   return old(level)
end))

local old; old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local namecall = getnamecallmethod()
	
    if not checkcaller() then
        if self.ClassName == "Player" and namecall == "Kick" then
            return coroutine.yield(coroutine.running())
        end
    end
    return old(self, ...)
end))

local old; old = hookfunction(PlayerClass.Kick, newcclosure(function(self, reason)
    if not checkcaller() then return coroutine.yield(coroutine.running()) end
    return old(self, reason)
end))

ExploitEnv.decompile = function(Script)
	local httpresponse = request({
        	Url = "http://127.0.0.1:9002",
        	Body = base64.encode(getscriptbytecode(Script)),
        	Method = "POST",
        	Headers = {
            	["Content-Type"] = "text/plain"
       	 },
    })
    return httpresponse.Body
end


local old; old = hookfunction(RobloxEnv.require, newcclosure(function(Module: ModuleScript | string | number): any
    if not checkcaller() and typeof(Module) == "Instance" and Module.Name == 'Anti' and Module.Parent and Module.Parent.Name == "Core" then
        print('[!] Adonis sucks:', Module)
       return {}
    end
    return old(Module)
end))


local synsaveinstance = loadstring(game:HttpGet("https://raw.githubusercontent.com/luau/SynSaveInstance/main/saveinstance.luau"))()
ExploitEnv.saveinstance = synsaveinstance
