// DirWalker project
// Copyright 2013 Philippe Quesnel
// Licensed under the Academic Free License version 3.0

// import objc style code
o := ObjcStyle clone


OneDirBase := Object clone do(

    name := method(self directory name)
    path := method(self directory path)

    init := method(
        self directory := nil
        self filenames := list()
        self kids := list()
    )

    // walk thru directory structure, gathering filenames & subdirs
    _walkDir := method( dirObj,
        directory = dirObj
        filenames = dirObj fileNames
        subdirs := dirObj directories
        subdirs foreach(subdir,
            kid := [self clone _walkDir: subdir]
            [kids append: kid]
        )
        return self
    )

   
    // 'class method', used to create instance 
    // called w. : OneDirBaseExtended with(..)
    with := method( arg,
        // make certain it's a (existing) directory !
        if([Directory exists: arg]) then(
            dirObj := [Directory with: arg]
            return [self clone _walkDir: dirObj]
        ) else (
            writeln("Error, " .. arg .. " is not a directory")
            return nil
        )
    )

    // traverse self, calling processAtLevel & processFile for each entry
    walk := method(
        _walkDirAtLevel := method(dir, level,
            // process self
            [dir processAtLevel: level]
            // process kids (recurse on subdirs)
            dir kids foreach(kid, [_walkDir: kid AtLevel: [level+1]])
            // process files
            dir filenames foreach(filename, [processFile: filename AtLevel: level])
        )
        
        [_walkDir: self AtLevel: 0]
    )
    
    spaces := method(level, " " repeated(2*level))
    processAtLevel := method(dir, level, nil)
    processFile := method(filename, level, nil)
    processFileAtLevel := method(filename, level, nil)
)

// subclass OneDirBase w. wanted dir/file processing
OneDirPrint := OneDirBase clone
OneDirPrint processAtLevel := method(level, writeln(spaces(level), "+", name, "\\"))
OneDirPrint processFileAtLevel := method(filename, level, writeln(spaces(level+1), filename))

//==========

doit := method(
    if (System args size == 2) then(
        return [OneDirPrint with: [System args at: 1]]
    ) else (
        writeln("argument: rootDirectoryToScan")
        return nil
    )
)

dir := doit

if (dir,
    dir name println
    dir path println
    dir filenames foreach(println)
    
    "*********" println
    dir walk
    "*********" println
)
