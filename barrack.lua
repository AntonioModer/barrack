local barrack = {
	_VERSION		= 'barrack v0.1',
	_DESCRIPTION	= 'Simple type checking library for lua'
	_URL			= 'http://github.com/DanielPower/barrack'
	_LICENSE		= [[
		Copyright (c) 2016 Daniel Power <me@danielpower.ca>

		This software is provided 'as-is', without any express or implied
		warranty. In no event will the authors be held liable for any damages
		arising from the use of this software.

		Permission is granted to anyone to use this software for any purpose,
		including commercial applications, and to alter it and redistribute it
		freely, subject to the following restrictions:

		1. The origin of this software must not be misrepresented; you must not
		   claim that you wrote the original software. If you use this software
		   in a product, an acknowledgement in the product documentation would be
		   appreciated but is not required.
		2. Altered source versions must be plainly marked as such, and must not be
		   misrepresented as being the original software.
		3. This notice may not be removed or altered from any source distribution.
	]]
}
barrack.definition = {}

-- Main functions
function barrack.enable()
	barrack.check = barrack._check
end

function barrack.disable()
	-- Make barrack.check an empty function to remove any performance impedence.
	barrack.check = function() end
end

function barrack.check()
	-- Blank by default.
	-- Use barrack.enable() to enable this function.
	-- Code located in barrack._check()
end

function barrack._check(input, definition)
	-- Both arguments to barrack.check must be a table.
	-- The first table contains the variables to check.
	-- The second table contains the definitions to check those variables against.
	if type(input) ~= 'table' or type(definition) ~= 'table' then
		error("[barrack] 'barrack.check' requires two tables as arguments.", 2)
	end

	-- There must be a definition for each input
	if #input ~= #definition then
		error("[barrack] Length of input and definition tables do not match.", 2)
	end
	
	for i=1, #input do
		local arg = input[i]
		local def = definition[i]
		
		-- Each item in the definition table should contain a string which matches a function in 'barrack.definition'.
		if type(def) ~= 'string' then
			error("[barrack] Definition table should only contain strings.", 2)
		end

		-- If you get this error, it means there is no definition function with the name you provided.
		if barrack.definition[def] == nil then
			error("Definition '"..def.."' not found.", 2)
		end

		if barrack.definition[def](arg) ~= true then
			local argDefinition = barrack._getDefinitions(arg)
			local defString = barrack._listString(argDefinition)
			error("[barrack] Argument "..i.." expected '"..def.."' but received '"..defString.."'", 2)
		end
	end
end

-- Definition functions
function barrack.definition.boolean(arg)
	if type(arg) == 'boolean' then
		return(true)
	end
end

-- Lua doesn't allow functions named function. So this definition is just called func.
function barrack.definition.func(arg)
	if type(arg) == 'function' then
		return(true)
	end
end

function barrack.definition.int(arg)
	if type(arg) == 'number' then
		if math.floor(arg) == arg then
			return(true)
		end
	end
end

function barrack.definition.middleclassClass(arg)
	if type(arg) == 'table' then
		-- Not foolproof, but nothing else I'm aware of creates this variable name.
		if arg.__declaredMethods then
			return(true)
		end
	end
end

function barrack.definition.middleclassInstance(arg)
	if type(arg) == 'table' then
		-- Not foolproof, but nothing else I'm aware of creates this variable name.
		if arg.class then
			if arg.class.__declaredMethods then
				return(true)
			end
		end
	end
end

function barrack.definition.number(arg)
	if type(arg) == 'number' then
		return(true)
	end
end

function barrack.definition.string(arg)
	if type(arg) == 'string' then
		return(true)
	end
end

function barrack.definition.table(arg)
	if type(arg) == 'table' then
		return(true)
	end
end

-- Debug functions
function barrack._getDefinitions(arg)
	local valueType = {}
	for def in pairs(barrack.definition) do
		if barrack.definition[def](arg) then
			table.insert(valueType, def)
		end
	end

	return(valueType)
end

function barrack._listString(table)
	local string = table[1]
	for i=2, #table do
		string = string..", "..table[i]
	end

	return(string)
end

return(barrack)