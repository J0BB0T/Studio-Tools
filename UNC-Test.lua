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
