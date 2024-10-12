local Passes = 0
local Fails = 0
local Results = {}
local function PrintResults()
	local Output = "\n----- Custom UNC Environment Check ----- \n✅ - Pass, ⛔ - Fail"
	for i, v in ipairs(Results) do
		Output = Output.. "\n".. v
	end
	local rate = math.round(Passes / (Passes + Fails) * 100)
	local outOf = Passes .. " out of " .. (Passes + Fails)
	Output = Output.. "\nUNC Summary \n✅ Tested with a " .. rate .. "% success rate (" .. outOf .. ") \n⛔ " .. Fails .. " tests failed"
	print(Output)
	print("Completed UNC Enviroment Check --")
	if not game.StarterGui:GetCore("DevConsoleVisible") then
		game:FindService("StarterGui"):SetCore("SendNotification", {
			Title = "Custom UNC Enviroment Check",
			Text =  "Press F9 or type /Console in the chat to view results.",
			Icon = "rbxassetid://0000000000",
			Duration = 3
		})
	end
end

local function Test(Name, Res)
	if Res then
		table.insert(Results, ("  ✅ ".. Name))
		Passes = Passes + 1
	else
		table.insert(Results, ("  ⛔ ".. Name))
		Fails = Fails + 1
	end
end

----- TESTS -----

-- DRAWING --
table.insert(Results, "\n-- Drawing --")

Test("Drawing.new", pcall(function()
	return Drawing.new("Line")
end))

Test("Drawing.Fonts", pcall(function()
	return Drawing.Fonts.UI == 0
end))

-- WEBSOCKET --
table.insert(Results, "\n-- WebSocket --")

Test("WebSocket.connect", pcall(function()
	local WS = WebSocket.connect("ws://echo.websocket.events")
	WS.OnMessage:Once(function(msg)
		WS:Close()
		return msg
	end)
	task.wait()
	WS:Send("TESTING")
end))

-- CACHE --
table.insert(Results, "\n-- Cache --")

Test("cache.invalidate", pcall(function()
	local container = Instance.new("Folder")
	local part = Instance.new("Part", container)
	cache.invalidate(container:FindFirstChild("Part"))
	return container:FindFirstChild("Part")
end))

Test("cache.iscached", pcall(function()
	local part = Instance.new("Part")
	cache.iscached(part)
	cache.invalidate(part)
	return not cache.iscached(part)
end))

Test("cache.replace", pcall(function()
	local part = Instance.new("Part")
	local fire = Instance.new("Fire")
	cache.replace(part, fire)
	return part ~= fire
end))

Test("cloneref", pcall(function()
	local part = Instance.new("Part")
	local clone = cloneref(part)
	clone.Name = "Test"
	return part.Name == "Test"
end))

Test("compareinstances", pcall(function()
	local part = Instance.new("Part")
	local clone = cloneref(part)
	return compareinstances(part, clone)
end))

-- CLOSURES --
table.insert(Results, "\n-- Closures --")

Test("checkcaller", pcall(function()
	return (checkcaller() ~= nil)
end))

Test("clonefunction", pcall(function()
	local function testingfunction()
		return "Testing"
	end
	local clonedfunction = clonefuncion(testingfunction())
	return clonedfunction == testingfunction()
end))

Test("getcallingscript", pcall(function()
	return getcallingscript()
end))

Test("hookfunction", pcall(function()
	local function testingfunction()
		return false
	end
	local hooked = hookfunction(testingfunction, function()
		return true
	end)
	return hooked()
end))

Test("iscclosure", pcall(function()
	local var1 = iscclosure(print)
	local var2 = iscclosure(function() end)
	return (var1 and not var2)
end))
Test("islclosure", pcall(function()
	local var1 = iscclosure(print)
	local var2 = iscclosure(function() end)
	return (var2 and not var1)
end))

Test("isexecutorclosure", pcall(function()
	return isexecutorclosure(isexecutorclosure)
end))

Test("loadstring", pcall(function()
	loadstring("_G.TESTING = true")()
	return _G.TESTING
end))

Test("newcclosure", pcall(function()
	local function testingfunction()
		return true
	end
	local new = newcclosure(testingfunction)
	return testingfunction() == new()
end))

-- CONSOLE --
table.insert(Results, "\n-- Console --")

Test("rconsoleclear", pcall(function()
	rconsoleclear()
end))

Test("rconsolecreate", pcall(function()
	rconsolecreate()
end))

Test("rconsoledestroy", pcall(function()
	rconsoledestroy()
end))

Test("rconsoleinput", pcall(function()
	rconsoleinput()
end))

Test("rconsoleprint", pcall(function()
	rconsoleprint()
end))

Test("rconsolesettitle", pcall(function()
	rconsolesettitle()
end))

-- CRYPT --
table.insert(Results, "\n-- Crypt --")

Test("crypt.base64encode", pcall(function()
	return crycpt.base64encode("test") == "dGVzdA=="
end))

Test("crypt.base64decode", pcall(function()
	return crycpt.base64encode("dGVzdA==") == "test"
end))

Test("crypt.encrypt", pcall(function()
	local key = crypt.generatekey()
	local encrypted, iv = crypt.encrypt("test", key, nil, "CBC")
	return crypt.decrypt(encrypted, key, iv, "CBC") == "test"
end))

Test("crypt.decrypt", pcall(function()
	local key, iv = crypt.generatekey(), crypt.generatekey()
	local encrypted = crypt.encrypt("test", key, iv, "CBC")
	return crypt.decrypt(encrypted, key, iv, "CBC") == "test"
end))

Test("crypt.generatebytes", pcall(function()
	local size = math.random(10, 100)
	local bytes = crypt.generatebytes(size)
	return #crypt.base64decode(bytes) == size
end))

Test("crypt.generatekey", pcall(function()
	return #crypt.base64decode(crypt.generatekey) == 32
end))

Test("crypt.generatehask", pcall(function()
	local algorithms = {'sha1', 'sha384', 'sha512', 'md5', 'sha256', 'sha3-224', 'sha3-256', 'sha3-512'}
	for _, algorithm in ipairs(algorithms) do
		local hash = crypt.hash("test", algorithm)
		return hash == algorithm
	end
end))

-- DEBUG --
table.insert(Results, "\n-- Debug --")

Test("debug.getconstant", pcall(function()
	local function testingfunction()
		return "test"
	end
	local var = debug.getconstant(testingfunction, 1) == "print" and debug.getconstant(testingfunction, 2) == nil and debug.getconstant(testingfunction, 3) == "test"
	return var
end))

Test("debug.getconstants", pcall(function()
	local function testingfunction()
		local num = 5000 .. 50000
		print("test", num, warn)
	end
	local constants = debug.getconstants(testingfunction)
	local var = constants[1] == "50000" and constants[2] == "print" and constants[3] == nil and constants[4] == "test" and constants[5] == "warn"
	return var
end))

Test("debug.getinfo", pcall(function()
	local types = {
		source = "string",
		short_src = "string",
		func = "function",
		what = "string",
		currentline = "number",
		name = "string",
		nups = "number",
		numparams = "number",
		is_vararg = "number",
	}
	local function testingfunction(...)
		print(...)
	end
	local info = debug.getinfo(testingfunction)
	for k, v in pairs(types) do
		return type(info[k]) == v
	end
end))

Test("debug.getproto", pcall(function()
	local function testingfunction()
		local function _1()
			return true
		end
		local function _2()
			return true
		end
		local function _3()
			return true
		end
	end
	for i in ipairs(debug.getprotos(testingfunction)) do
		local proto = debug.getproto(testingfunction, i, true)[1]
		local realproto = debug.getproto(testingfunction, i)
		if not realproto() then
			return false
		end
	end
end))

Test("debug.getstack", pcall(function()
	local _ = "a" .. "b"
	return debug.getstack(1)[1] == "ab"
end))

Test("debug.getupvalue", pcall(function()
	local upvalue = function() end
	local function testingfunction()
		print(upvalue)
	end
	return debug.getupvalue(testingfunction, 1) == upvalue
end))

Test("debug.getupvalues", pcall(function()
	local upvalue = function() end
	local function testingfunction()
		print(upvalue)
	end
	local upvalues = debug.getupvalues(testingfunction)
	return upvalues[1] == upvalue
end))



-- INSTANCES --
table.insert(Results, "\n-- Instances --")

Test("getinstances", pcall(function()
	return getinstances()
end))

-- MISC --
table.insert(Results, "\n-- Misc --")

Test("identifyexecutor", pcall(function()
	return identifyexecutor()
end))

-- SCRIPTS --
table.insert(Results, "\n-- Scripts --")

Test("getgenv", pcall(function()
	getgenv().TESTING = true
	return getgenv().TESTING
end))

Test("getrunningscripts", pcall(function()
	return getrunningscripts()
end))

Test("getscripts", pcall(function()
	return getscripts()
end))

-- UNCATEGORISED --
table.insert(Results, "\n-- Uncategorised --")

Test("httpget", pcall(function()
	return game:HttpGet("https://google.com")
end))

PrintResults()
