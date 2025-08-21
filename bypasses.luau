print("# Very cool bypasses enabled, by @delovoymuzhchina")

local PlayerClass = Instance.new('Player')
local CurrentScript = script
local RobloxEnv = getrenv()
local ExploitEnv = getgenv()


local old; old = hookfunction(RobloxEnv.newproxy, newcclosure(function(AddMetatable: boolean): any
    local CallingScript = getcallingscript()
    if not checkcaller() and CallingScript.Name:match('ClientMover') and CallingScript:IsA("LocalScript") then
        return require(CallingScript.Parent.Client.Client)
    end
    return old(AddMetatable)
end))

local old; old = hookfunction(RobloxEnv.require, newcclosure(function(Module: ModuleScript | string | number): any
	script = getcallingscript()
    
    if not checkcaller() then
        local Parent = Module.Parent
        if typeof(Module) == "Instance" then
            if Module:IsA('ModuleScript') then
                if Module.Name == 'Anti' or Module.Name == 'Anti_Cheat' and Parent and (Parent.Name == "Core" or Parent.Name == "Plugins") then
                    print('[!] Adonis sucks:', Module)
                    return function(VarArgs) end
                end
            else
                error('Attempted to call require with invalid argument(s).')
            end
        elseif typeof(Module) == "userdata" then
            error('Attempted to call require with invalid argument(s).')
        end
    end
    
    local Result = old(Module)
    script = CurrentScript
    return Result
end))

local old; old = hookfunction(RobloxEnv.pcall, newcclosure(function(Func, ...: any): (boolean, ...any)
    if not checkcaller() and Func == RobloxEnv.require then
        local Target = ...
        if (typeof(Target) == "Instance" and not Target:IsA('ModuleScript')) or typeof(Target) == "userdata" then
            return false, "Attempted to call require with invalid argument(s)."
        end
    end
    return old(Func, ...)
end))

local old; old = hookfunction(RobloxEnv.task.spawn, newcclosure(function(Func, ...: any): thread
    if not checkcaller() and Func == RobloxEnv.pcall then
        local Func, Target = ...
        if Func == RobloxEnv.require then
            if (typeof(Target) == "Instance" and not Target:IsA('ModuleScript')) or typeof(Target) == "userdata" then
                return
            end
        end
    end
    return old(Func, ...)
end))

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
	local CallingScript = getcallingscript()
    
    if not checkcaller() then
        if self.ClassName == "Player" and namecall == "Kick" then
		    warn("Trying to kick me:",CallingScript.GetFullName(CallingScript))
            --if CallingScript.IsA(CallingScript) == 'LocalScript' and CallingScript.Name == "ClientMover" then
            --    CallingScript.Destroy(CallingScript)
            --    print('Fuck You!!!', CallingScript.GetFullName(CallingScript))
            --end
            return coroutine.yield(coroutine.running())
            --[[
        elseif self.ClassName == "RemoteEvent" and namecall == "FireServer" then
            local Args = {...}
            local Strings = {}
            for _, v in Args do
                table.insert(Strings, tostring(v))
            end
            local str = table.concat(Strings, ", ")
            print(`[+] {self} :: [ {str}] @ {CallingScript.GetFullName(CallingScript)}`)
            ]]
        end
    end
    return old(self, ...)
end))

local old; old = hookfunction(PlayerClass.Kick, newcclosure(function(self, reason)
    local CallingScript = getcallingscript()
    if not checkcaller() then
        warn("Trying to kick me123:",CallingScript:GetFullName())
        return coroutine.yield(coroutine.running())
    end
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

local synsaveinstance = loadstring(game:HttpGet("https://raw.githubusercontent.com/luau/SynSaveInstance/main/saveinstance.luau"))()
ExploitEnv.saveinstance = synsaveinstance
