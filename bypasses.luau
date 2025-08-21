print("# Very cool bypasses enabled")

local PlayerClass = Instance.new('Player')
local CurrentScript = script
local RobloxEnv = getrenv()
local ExploitEnv = getgenv()

local old; old = hookfunction(RobloxEnv.require, newcclosure(function(Module: ModuleScript | string | number): any
	script = getcallingscript()
    
    if not checkcaller() then
        local Parent = Module.Parent
        if typeof(Module) == "Instance" then
            if Module:IsA('ModuleScript') then
                if Module.Name == "Client" then
                    print("####### PROTOS #######")
                    local protos = debug.getprotos(debug.getinfo(4).func)
                    local loadingDetected, kill
                    for i, v in protos do
                        local Name = debug.getinfo(v).name
                        if not kill and Name == "Kill" then
                            kill = v
                        elseif not loadingDetected and Name == 'loadingDetected' then
                            loadingDetected = v
                        end
                    end
                    print(`loadingDetected: {loadingDetected}`)
                    print(`Kill: {kill}`)
                    if Kill then
                        local old; old =hookfunction(Kill, newcclosure(function()
                            warn('Trying to kill client')
                        end))
                    end
                    if loadingDetected then
                        local old; old =hookfunction(loadingDetected, newcclosure(function()
                            warn('Trying to "loadingDetected" client')
                        end))
                    end
                end
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
if not game:IsLoaded() then game.Loaded:Wait() end

print('OTHER INITIALIZED!')
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
            print("####")
            table.foreach(debug.getinfo(3), print)
            print("####")
            table.foreach(debug.getupvalues(3), print)
            print("####")
            table.foreach(debug.getconstants(3), print)
            print("####")
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
        print("####")
        table.foreach(debug.getinfo(3), print)
        print("####")
        table.foreach(debug.getupvalues(3), print)
        print("####")
        table.foreach(debug.getconstants(3), print)
        print("####")
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
