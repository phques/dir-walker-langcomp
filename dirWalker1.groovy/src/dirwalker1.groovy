
class OneDirBase {
    def name
    def fullPath

    protected  _kids = []
    protected _filenames = []
    
    OneDirBase(String baseDirname) {
        this(new File(baseDirname)) 
    }
    
    protected OneDirBase(File dir) {
        assert dir.isDirectory()
        read(dir)
    }

    // walk through our data
    def Walk(level = 0) {    
        // self
        //println "self $level"
        this.ProcessDir(level)
        
        // subdirs
        //println "subdirs $level"
        _kids.each{ it.Walk(level+1) }
        
        // files
        //println "filenames $level"
        _filenames.each{ ProcessFile(it, level+1) }
    }

    // overrides
    def ProcessDir(level) {    }
    def ProcessFile(filename, level) { }
    
    
    // walk dir & subdirs gathering the info
    private def read(dir) {
        name = dir.name
        fullPath = dir.canonicalPath
        
        // get filenames list
        def files = dir.listFiles( [accept:{!it.isDirectory()}] as FileFilter )
        _filenames = files.toList()*.name
        
        // recurse on subdirs
        dir.eachFile(groovy.io.FileType.DIRECTORIES) { subdir -> 
            _kids << this.class.newInstance(subdir)
        }
    }
}


class OneDirPrint extends OneDirBase {
    OneDirPrint(dirname) { super(dirname) }

    def Spaces(level) { " " * (2 * level) }
    
    // overrides
    def ProcessDir(level) { println "${Spaces(level)}+$name/" }
    def ProcessFile(filename, level) { println "${Spaces(level)}$filename" }
}


// main
//## running from groovyConsole, no cmdline args !
args = ['/home/kwez/Downloads'] as String[]
//args = this.args
if (args.length == 1 && new File(args[0]).isDirectory()) {
    
    //OneDirBase one = new OneDirBase(args[0])
    OneDirBase one = new OneDirPrint(args[0])
    one.Walk()    
}
else {
    println "ooops, argument: directory to walk"
}