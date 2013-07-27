// DirWalker project
// Copyright 2013 Philippe Quesnel
// Licensed under the Academic Free License version 3.0
#include <iostream>
#include <dirent.h>
#include <string>
#include <list>

using namespace std;

class OneDir
{
public:
    OneDir() {}

    OneDir(const string& basePath, const string& name)
    {
        this->name = name;
        this->basePath = basePath;
    }

//    void AddKid(const OneDir& kid)
//    {
//        kids.push_back(kid);
//    }
//
//    void AddFilename(const string& filename)
//    {
//        filenames.push_back(filename);
//    }

    const string& Name() const { return name; }

    string FullPath() const
    {
        if (name.length() > 0)
            return basePath + "/" + name;
        return basePath;
    }

    bool Read()
    {
        DIR* dir = 0;
//        cout << "Read() " + FullPath() << endl;
        dir = opendir(FullPath().c_str());
        if (!dir)
            return false;

        list<string> subdirnames;
        struct dirent *direntVar = 0;

        while ( (direntVar = readdir(dir)) != 0)
        {
            string kidname(direntVar->d_name);
            if (direntVar->d_type == DT_DIR)
            {
                if (kidname != "." && kidname != "..")
                {
//                    cout << " dir " << kidname << endl;
                    subdirnames.push_back(kidname);
                }
            }
            else if (direntVar->d_type == DT_REG)
            {
//                cout << "file " << kidname << endl;
                filenames.push_back(kidname);
            }
        }

        closedir(dir);
        readSubdirs(subdirnames);

        return true;
    }

    void Walk()
    {
        walk(0);
    }

protected:
    void readSubdirs(const list<string>& subdirnames)
    {
        list<string>::const_iterator subdirIt = subdirnames.begin();
        for (; subdirIt != subdirnames.end(); subdirIt++)
        {
//            OneDir* kid = new OneDir(FullPath(), *subdirIt);
            OneDir* kid = create(FullPath(), *subdirIt);
            kids.push_back(kid);
            kid->Read();
        }
    }

    void walk(int level)
    {
        processDir(level);

        list<OneDir*>::iterator kidsit = kids.begin();
        for (; kidsit != kids.end(); kidsit++)
        {
            OneDir* kid = *kidsit;
            kid->walk(level+1);
        }

        list<string>::iterator filesit = filenames.begin();
        for (; filesit != filenames.end(); filesit++)
        {
            processFile(*filesit, level);
        }
    }

protected:
    virtual OneDir* create(const string& basePath, const string& name)
    {
        return new OneDir(basePath, name);
    }

    virtual void processDir(int level)
    {
    }

    virtual void processFile(const string& filename, int level)
    {
    }

protected:
    string name;
    string basePath;
    list<OneDir*> kids;
    list<string> filenames;
};


class MyDirWalker : public OneDir
{
public:
    MyDirWalker() {}

    MyDirWalker(const string& basePath, const string& name) : OneDir(basePath, name)
    {
    }

protected:
    virtual OneDir* create(const string& basePath, const string& name)
    {
        return new MyDirWalker(basePath, name);
    }

    virtual void processDir(int level)
    {
        string spaces(level*2, ' ');
        cout << spaces << '+' << name << '/' << endl;
    }

    virtual void processFile(const string& filename, int level)
    {
        string spaces((level+1)*2, ' ');
        cout << spaces << filename << endl;
    }
};

int main(int argc, char* argv[])
{
    if (argc != 2)
    {
        cout << "param: directoryName" << endl;
        return 0;
    }

//    OneDir oneDir(argv[1], "");
    MyDirWalker oneDir(argv[1], "");
    cout << oneDir.FullPath();
    oneDir.Read();
    oneDir.Walk();
    return 0;
}
