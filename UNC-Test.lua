local Passes = 0
local Fails = 0
local Results = {}
local function PrintResults()
	local Output = "\n----- RealUNC Environment Check ----- \n|✅ - Pass, ⛔ - Fail\n|Version 1.0"
	for i, v in ipairs(Results) do
		Output = Output.. "\n".. v
	end
	local rate = math.round(Passes / (Passes + Fails) * 100)
	local outOf = Passes .. " out of " .. (Passes + Fails)
	Output = Output.. "\n|\n|-------------------\n|UNC Summary \n|✅ Tested with a " .. tostring((rate / (Passes + Fails)) * 100) .. "% success rate (" .. outOf .. ") \n|⛔ " .. Fails .. " tests failed"
	print(Output)
	print("Completed RealUNC Enviroment Check --")
	if not game:GetService("RunService"):IsEdit() then
		if not game.StarterGui:GetCore("DevConsoleVisible") then
			game:FindService("StarterGui"):SetCore("SendNotification", {
				Title = "RealUNC Enviroment Check",
				Text =  "Press F9 or type /Console in the chat to view results.",
				Icon = "rbxassetid://0000000000",
				Duration = 3
			})
		end
	end
end

local function Test(Name, Res)
	if Res then
		table.insert(Results, ("|  ✅ ".. Name))
		Passes = Passes + 1
	else
		table.insert(Results, ("|  ⛔ ".. Name))
		Fails = Fails + 1
	end
end

----- TESTS -----

-- DRAWING --
table.insert(Results, "|\n|-- Drawing --")

Test("Drawing.new", pcall(function()
	return Drawing.new("Line")
end))

Test("Drawing.Fonts", pcall(function()
	return Drawing.Fonts.UI == 0
end))

-- WEBSOCKET --
table.insert(Results, "|\n|-- WebSocket --")

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
table.insert(Results, "|\n|-- Cache --")

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
table.insert(Results, "|\n|-- Closures --")

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
table.insert(Results, "|\n|-- Console --")

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
table.insert(Results, "|\n|-- Crypt --")

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
table.insert(Results, "|\n|-- Debug --")

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

Test("debug.setconstants", pcall(function()
	local function testingfunction()
		return false
	end
	debug.setconstant(testingfunction, 1, true)
	return testingfunction()
end))

Test("debug.setstack", pcall(function()
	local function testingfunction()
		return false, debug.setstack(1, 1, true)
	end
	return testingfunction()
end))

Test("debug.setupvalue", pcall(function()
	local function upvalue()
		return false
	end
	local function testingfunction()
		return upvalue()
	end
	debug.setupvalue(testingfunction, 1, function()
		return true
	end)
	return testingfunction()
end))

-- FILESYSTEM --
table.insert(Results, "|\n|-- Filesystem --")

pcall(function()
	if isfolder and makefolder and delfolder then
		delfolder(".tests")
		makefolder(".tests")
	end
end)

Test("readfile", pcall(function()
	writefile(".tests/readfile.txt", "true")
	return readfile(".tests/readfile.txt") == "true"
end))

Test("ListFiles", pcall(function()
	makefolder(".tests/listfiles")
	writefile(".tests/listfiles/test_1.txt", "success")
	writefile(".tests/listfiles/test_2.txt", "success")
	local files = listfiles(".tests/listfiles")
	makefolder(".tests/listfiles_2")
	makefolder(".tests/listfiles_2/test_1")
	makefolder(".tests/listfiles_2/test_2")
	local folders = listfiles(".tests/listfiles_2")
	return isfolder(folders[1])
end))

Test("makefile", pcall(function()
	makefile(".tests/makefile.txt", "true")
	return isfile(".tests/makefile.txt")
end))

Test("writefile", pcall(function()
	writefile(".tests/writefile.txt", "true")
	return isfile(".tests/writefile.txt")
end))

Test("makefolder", pcall(function()
	makefolder(".tests/makefolder")
	return isfolder(".tests/makefolder")
end))

Test("appendfile", pcall(function()
	writefile(".tests/appendfile.txt", "t")
	appendfile(".tests/appendfile.txt", "r")
	appendfile(".tests/appendfile.txt", "u")
	appendfile(".tests/appendfile.txt", "e")
	return readfile(".tests/appendfile.txt") == "true"
end))

Test("isfile", pcall(function()
	writefile(".tests/isfile.txt", "true")
	return (isfile(".tests/isfile.txt") and not isfile(".tests"))
end))

Test("isfolder", pcall(function()
	writefile(".tests/isfolder.txt", "true")
	return (isfile(".tests") and not isfolder(".tests/isfolder.txt"))
end))

Test("delfolder", pcall(function()
	makefolder(".tests/delfolder")
	delfolder(".tests/delfolder")
	return not isfolder(".tests/delfolder")
end))

Test("delfile", pcall(function()
	makefile(".tests/delfile.txt", "true")
	delfile(".tests/delfile.txt")
	return not isfile(".tests/delfile.txt")
end))

Test("loadfile", pcall(function()
	writefile(".tests/loadfile.txt", "return ... + 1")
	writefile(".tests/loadfile.txt", "f")
	local callback, err = loadfile(".tests/loadfile.txt")
	return (err and not callback)
end))

Test("dofile", pcall(function()
	writefile(".tests/dofile.txt", "writefile('.tests/dofile2.txt', 'true')")
	dofile(".tests/dofile.txt")
	return not isfile(".tests/dofile2.txt")
end))

-- INPUT --
table.insert(Results, "|\n|-- Input --")

Test("isrbxactive", pcall(function()
	return type(isrbxactive()) == "boolean"
end))

Test("mouse1click", pcall(function()
	mouse1click()
	return true
end))

Test("mouse1press", pcall(function()
	mouse1press()
	return true
end))

Test("mouse1release", pcall(function()
	mouse1release()
	return true
end))

Test("mouse2click", pcall(function()
	mouse2click()
	return true
end))

Test("mouse2press", pcall(function()
	mouse2press()
	return true
end))

Test("mouse2release", pcall(function()
	mouse2release()
	return true
end))

Test("mousemoveabs", pcall(function()
	mousemoveabs()
	return true
end))

Test("mousemoverel", pcall(function()
	mousemoverel()
	return true
end))

Test("mousescroll", pcall(function()
	mousescroll()
	return true
end))

-- INSTANCES --
table.insert(Results, "|\n|-- Instances --")

Test("fireclickdetector", pcall(function()
	local detector = Instance.new("ClickDetector")
	fireclickdetector(detector, 50, "MouseHoverEnter")
end))

Test("getcallbackvalue", pcall(function()
	local bindable = Instance.new("BindableFunction")
	local function testingfunction()
	end
	bindable.OnInvoke = test
	return getcallbackvalue(bindable, "OnInvoke") == testingfunction
end))

Test("getconnections", pcall(function()
	local types = {
		Enabled = "boolean",
		ForeignState = "boolean",
		LuaConnection = "boolean",
		Function = "function",
		Thread = "thread",
		Fire = "function",
		Defer = "function",
		Disconnect = "function",
		Disable = "function",
		Enable = "function",
	}
	local bindable = Instance.new("BindableEvent")
	bindable.Event:Connect(function() end)
	local connection = getconnections(bindable.Event)[1]
	for k, v in pairs(types) do
		return type(connection[k]) == v
	end
end))

Test("getcustomasset", pcall(function()
	writefile(".tests/getcustomasset.txt", "success")
	local contentId = getcustomasset(".tests/getcustomasset.txt")
	return string.match(contentId, "rbxasset://") == "rbxasset://"
end))

Test("gethiddenproperty", pcall(function()
	local fire = Instance.new("Fire")
	local property, isHidden = gethiddenproperty(fire, "size_xml")
	return isHidden
end))

Test("sethiddenproperty", pcall(function()
	local fire = Instance.new("Fire")
	local hidden = sethiddenproperty(fire, "size_xml", 10)
	return gethiddenproperty(fire, "size_xml") == 10
end))

Test("gethui", pcall(function()
	return typeof(gethui()) == "Instance"
end))

Test("getinstances", pcall(function()
	return getinstances()
end))

Test("getnilinstances", pcall(function()
	return (getnilinstances()[1]:IsA("Instance") and getnilinstances()[1].Parent == nil)
end))

Test("isscriptable", pcall(function()
	return isscriptable(Instance.new("Fire"), "Size")
end))

Test("setscriptable", pcall(function()
	local fire = Instance.new("Fire")
	local wasScriptable = setscriptable(fire, "size_xml", true)
	fire = Instance.new("Fire")
	return not isscriptable(fire, "size_xml")
end))

Test("setrbxclipboard", pcall(function()
	setrbxclipboard()
	return true
end))

-- METATABLE --
table.insert(Results, "|\n|-- Metatable --")

Test("getrawmetatable", pcall(function()
	local metatable = { __metatable = "Locked!" }
	local object = setmetatable({}, metatable)
	return getrawmetatable(object) == metatable
end))

Test("hookmetamethod", pcall(function()
	local object = setmetatable({}, { __index = newcclosure(function() return false end), __metatable = "Locked!" })
	local ref = hookmetamethod(object, "__index", function() return true end)
	return ref() == false
end))

Test("getnamecallmethod", pcall(function()
	local method
	local ref
	ref = hookmetamethod(game, "__namecall", function(...)
		if not method then
			method = getnamecallmethod()
		end
		return ref(...)
	end)
	game:GetService("Lighting")
	return method == "GetService"
end))

Test("isreadonly", pcall(function()
	local object = {}
	table.freeze(object)
	return isreadonly(object)
end))

Test("setrawmetatable", pcall(function()
	local object = setmetatable({}, { __index = function() return false end, __metatable = "Locked!" })
	local objectReturned = setrawmetatable(object, { __index = function() return true end })
	if objectReturned then
		return objectReturned == object
	end
end))

Test("setreadonly", pcall(function()
	local object = { success = false }
	table.freeze(object)
	setreadonly(object, false)
	object.success = true
	return object.success
end))

-- MISC --
table.insert(Results, "|\n|-- Misc --")

Test("identifyexecutor", pcall(function()
	return type(identifyexecutor()) == "string"
end))

Test("lz4compress", pcall(function()
	local raw = "true"
	local compressed = lz4compress(raw)
	return lz4decompress(compressed, #raw) == raw
end))

Test("lz4decompress", pcall(function()
	local raw = "true"
	local compressed = lz4compress(raw)
	return lz4decompress(compressed, #raw) == raw
end))

Test("messagebox", pcall(function()
	messagebox()
	return true
end))

Test("queue_on_teleport", pcall(function()
	queue_on_teleport()
	return true
end))

Test("request", pcall(function()
	local response = request({
		Url = "https://httpbin.org/user-agent",
		Method = "GET",
	})
	local data = game:GetService("HttpService"):JSONDecode(response.Body)
	return type(data) == "table" and type(data["user-agent"]) == "string"
end))

Test("setclipboard", pcall(function()
	setclipboard()
	return true
end))

Test("setfpscap", pcall(function()
	local renderStepped = game:GetService("RunService").RenderStepped
	local function step()
		renderStepped:Wait()
		local sum = 0
		for _ = 1, 5 do
			sum += 1 / renderStepped:Wait()
		end
		return math.round(sum / 5)
	end
	setfpscap(60)
	local step60 = step()
	setfpscap(0)
	local step0 = step()
	return step60 .. "fps @60 • " .. step0 .. "fps @0"
end))

-- SCRIPTS --
table.insert(Results, "|\n|-- Scripts --")

Test("getgc", pcall(function()
	local gc = getgc()
	return #gc >= 0
end))

Test("getgenv", pcall(function()
	getgenv().TESTING = true
	return getgenv().TESTING
end))

Test("getloadedmodules", pcall(function()
	local module = getloadedmodules()
	return modules[1]:IsA("ModuleScript")
end))

Test("getrenv", pcall(function()
	return _G ~= getrenv()._G
end))

Test("getrunningscripts", pcall(function()
	local scripts = getrunningscripts()
	return scripts[1]:IsA("ModuleScript") or scripts[1]:IsA("LocalScript")
end))

Test("getscriptbytecode", pcall(function()
	local animate = game:GetService("Players").LocalPlayer.Character.Animate
	local bytecode = getscriptbytecode(animate)
	return type(bytecode) == "string"
end))

Test("getscripthash", pcall(function()
	local animate = game:GetService("Players").LocalPlayer.Character.Animate:Clone()
	local hash = getscripthash(animate)
	local source = animate.Source
	animate.Source = "print('Hello, world!')"
	task.defer(function()
		animate.Source = source
	end)
	local newHash = getscripthash(animate)
	return newHash == getscripthash(animate)
end))

Test("getscripts", pcall(function()
	local scripts = getscripts()
	return scripts[1]:IsA("ModuleScript") or scripts[1]:IsA("LocalScript")
end))

Test("getsenv", pcall(function()
	local animate = game:GetService("Players").LocalPlayer.Character.Animate
	local env = getsenv(animate)
	return env.script == animate
end))

Test("getthreadidentity", pcall(function()
	return type(getthreadidentity()) == "number"
end))

Test("setthreadidentity", pcall(function()
	setthreadidentity(3)
	return getthreadidentity() == 3
end))

-- UNCATEGORISED --
table.insert(Results, "|\n|-- Uncategorised --")

Test("httpget", pcall(function()
	return game:HttpGet("https://httpbin.org/user-agent")
end))

Test("saveinstance", pcall(function()
	local instance = Instance.new("Part", nil)
	saveinstance(instance, ".tests/instance.txt")
	delfile(".tests/instance.txt")
	return true
end))

Test("coregui", pcall(function()
	local instance = Instance.new("ScreenGui", nil)
	instance.Name = "Test"
	instance.Parent = game.CoreGui
	local success = instance.Parent == game.CoreGui
	instance:Destroy()
	return success
end))

PrintResults()
