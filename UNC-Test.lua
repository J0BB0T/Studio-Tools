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

-- CLOSURES --
table.insert(Results, "\n-- Closures --")

Test("loadstring", pcall(function()
	loadstring("_G.TESTING = true")()
	return _G.TESTING
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
Test("getexecutorname", pcall(function()
	return getexecutorname()
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
