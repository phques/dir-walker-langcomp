-- ---------------------------------------------------------------
-- 
-- declare them once so we can just assign them in new 'classes'

-- traditional Lua prototypre based OO / classes CTOR
function _classnew(classSelf, o)
  o = o or {}   -- create object if user does not provide one
  setmetatable(o, classSelf)
  classSelf.__index = classSelf
  return o
end

-- Create a proxy function to forward a function call to an object+method (single param)
function _methodproxy(self, methodName)
	local method = self[methodName]
    return function(val)
        method(self,val)
    end
end

--~ class = { new = _classnew }
--~ obj = class:new()

--~ objClass = getmetatable(obj)
--~ print(objClass, class)