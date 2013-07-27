--~ DirWalker project
--~ Copyright 2013 Philippe Quesnel
--~ Licensed under the Academic Free License version 3.0

require "ooutil"
require "lfs"

-- base prototype
OneDirBase = {}

function OneDirBase:new()
-- assign/create fields HERE vs in OneDirBase !
-- otherwise table.insert(self.kids, kid) uses the original 'kids', never a new one is created in instances
	local o = _classnew(self)
	o.kids = {};
	o.filenames = {};
	o.name = "";
	return o
end


function OneDirBase:Read(dirBasePath, dirName)
	local class = getmetatable(self)	-- class to create new instances of Dir
	
	self.name = dirName
	self.path = dirBasePath..'/'..dirName
	
	-- get all 'files' in directory
	for file in lfs.dir(self.path) do
		-- skip parent & ourself
		if file ~= "." and file ~= ".." then
			-- is it a directory ?
			if lfs.attributes(self.path..'/'..file).mode == "directory" then
				-- directory, recurse on new kid
				local kid = class:new()
				kid:Read(self.path, file)
				table.insert(self.kids, kid)
			else
				-- file or link or ? ... add as filename
				table.insert(self.filenames, file)
			end
		end
	end
end

function OneDirBase:Walk(level)
	level = level or 0
	self:ProcessDir(level)
	
	for _, subdir in ipairs(self.kids) do 
		subdir:Walk(level+1)
	end

	for _, filename in ipairs(self.filenames) do 
		self:ProcessFile(level+1, filename)
	end
end

function OneDirBase:ProcessDir(level) print(self.name) end
function OneDirBase:ProcessFile(level, filename) print(filename) end

-------------------------

OneDirPrint = OneDirBase:new()

function OneDirPrint.Spaces(level) 
	return string.rep(" ", level*2)
end

function OneDirPrint:ProcessDir(level) 
	print(OneDirPrint.Spaces(level)..'+'..self.name..'/')
end

function OneDirPrint:ProcessFile(level, filename) 
	print(OneDirPrint.Spaces(level)..filename)
end


-------------------------

--~ one = OneDirBase:new()
one = OneDirPrint:new()
one:Read('/home/kwez','Downloads')

one:Walk()
