local Passes = 0
local Fails = 0
local Results = {}
local function PrintResults()
	print("\n")
	print("Custom UNC Environment Check")
	print("✅ - Pass, ⛔ - Fail")
	for i, v in ipairs(Results) do
		print(v)
	end
	local rate = math.round(Passes / (Passes + Fails) * 100)
	local outOf = Passes .. " out of " .. (Passes + Fails)
	print("\n")
	print("UNC Summary")
	print("✅ Tested with a " .. rate .. "% success rate (" .. outOf .. ")")
	print("⛔ " .. Fails .. " tests failed")
end

local function Test(Name, Res)
	if Res then
		table.insert(Results, ("✅ ".. Name))
		Passes = Passes + 1
	else
		table.insert(Results, ("⛔ ".. Name))
		Fails = Fails + 1
	end
end

----- TESTS -----

-- CLOSURES --
table.insert(Results, "-- Closures --")
Test("loadstring", pcall(function()
	loadstring("_G.TESTING = true")()
	return _G.TESTING
end))

-- INSTANCES --
table.insert(Results, "-- Instances --")
Test("getinstances", pcall(function()
	return getinstances()
end))

-- MISC --
table.insert(Results, "-- Misc --")
Test("identifyexecutor", pcall(function()
	return identifyexecutor()
end))
Test("getexecutorname", pcall(function()
	return getexecutorname()
end))

-- SCRIPTS --
table.insert(Results, "-- Scripts --")
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
table.insert(Results, "-- Uncategorised --")
Test("httpget", pcall(function()
	return game:HttpGet("https://google.com")
end))

PrintResults()
