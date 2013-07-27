// DirWalker project
// Copyright 2013 Philippe Quesnel
// Licensed under the Academic Free License version 3.0
module main;

import std.stdio;
import std.file;
import std.path;
import std.array;
import std.algorithm;


class BaseDir
{
public:
    this() {}
    this(in string dirPath) { _path = dirPath; read(); }

    string name() { return baseName(_path); }
    void walk() { walk(0); }

private:
    void read()
    {
        DirEntry dir = dirEntry(_path);
        //debug writeln(_path);

        // get all entriees in this dir
        bool followSymLink = false;
        foreach (entry; dirEntries(dir.name, SpanMode.shallow, followSymLink))
        {
            // avoid symlink, exception if it is invalid
            if (!entry.isSymlink && entry.isDir)
                _kids ~= newMe(entry);
            else
                _files ~= baseName(entry);
        }

        // recurse on all subdirs: read them!
        foreach (ref kid; _kids)
            kid.read();
    }

    void walk(int level)
    {
        processDir(level);

        foreach (kid; _kids)
            kid.walk(level+1);

        foreach (file; _files)
            processFile(file, level+1);
    }


    // creates a new instance of same type as 'this'
    BaseDir newMe(string path)
    {
        BaseDir dir = cast(BaseDir)this.classinfo.create();
        dir._path = path;
        return dir;
    }

public:
    // virtuals (must be public !!)
    void processDir(int level) {}
    void processFile(in string filename, int level) {}

private:
    BaseDir[] _kids;
    string[] _files;
    string _path;
}


class PrintDir : BaseDir
{
public:
    this() { super(); _spaces[] = ' ';}
    this(in string dirPath) { super(dirPath); }

private:
    char[1024] _spaces;
    version(none)
        string spaces(int level) { return level ? replicate(" ", level*2) : ""; }
    else
        char[] spaces(int level) { return _spaces[0..level*2]; }

public:
    // virtuals (must be public !!)
    override void processDir(int level)
    {
        writeln(spaces(level), "+", name, "/");
    }
    override void processFile(in string filename, int level)
    {
        writeln(spaces(level), filename);
    }

}

int main(string[] argv)
{ 
    if (argv.length != 2 || !isDir(argv[1]))
    {
        writeln("param: directory to list");
        return 1;
    }

    BaseDir dir;
    dir = new BaseDir(argv[1]);
    dir.walk();
    writeln("==============");

    dir = new PrintDir(argv[1]);
    dir.walk();

    return 0;
}
