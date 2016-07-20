# zStar
Simple type checking library for lua.

## Usage
Add a check call to the beginning of each function you want to test.

**barrack.check(input, definition)**  
*input*: A table containing each of the arguments you'd like to test.  
*definition*: A table containing a string with the name of a barrack definition. All definitions are defined in `barrack.definition`.


## Example
```lua
barrack = require('barrack')

function createInstance(x, y, name, info)
	barrack.check(	{  x,        y,        name,     info   }, 
					{ 'number', 'number', 'string', 'table' })

	-- Continue writing the rest of your function as you normally would.
	-- Barrack will raise an error if any of the arguments do not match the required type.
end
```