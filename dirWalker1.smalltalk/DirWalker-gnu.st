" DirWalker project"
" Copyright 2013 Philippe Quesnel"
" Licensed under the Academic Free License version 3.0"

Object subclass: OneDirBase [
    | name kids filenames |
    
    OneDirBase class >> new [
        | r |
        r := super new.
        r init.
        ^r.
    ]

    init [
        name := ''.
        kids := OrderedCollection new.
        filenames := OrderedCollection new.
    ]

    readAt: dirPath [
        "reads filenames & then recurses on subdir kids"

        | dir |
        dir := File name: dirPath.
        dir isDirectory ifFalse: [self error: 'not a directory'. ^nil].
        ^self readFrom: dir
    ]

    walk [
        "traverse/walk-thru our data"
        self walkAt: 0
    ]


    readFrom: dir [
        "reads filenames & then recurses on subdir kids"

        | kid subdirname |
        "sanity check"
        dir isDirectory ifFalse: [^nil].
        name := dir stripPath.
        
        "read filenames, except '.' '..' "
        filenames := dir entryNames select: [:x| (x ~= '.') & (x ~= '..')] .

        "recurse on subdirs"
        dir directories do: 
        [:subdir | 
            "skip '.' & '..'"
            subdirname := subdir asString.
            ((subdirname reverse at: 1) ~= $.) ifTrue: [
                kid := self class new.	"create new kid of same type"
                kid := kid readFrom: subdir.
                kid ifNotNil: [:foo | kids addLast: kid]
            ]
        ].
        ^self	"explicit"
    ]


    walkAt: level [
        "traverse/walk-thru our data"

        self processDir: level.
        kids do: [:kid | kid walkAt: level + 1].
        filenames do: [:filename | self processFile: filename atLevel: level + 1]
    ]

    processDir: level [
        "override this"
        self subclassResponsibility
    ]

    processFile: filename atLevel: level [
        "override this"
        self subclassResponsibility
    ]
]



OneDirBase subclass: DirPrinter [
    
    Spaces1024 := nil.

    DirPrinter class >> init [
        "super init.?"
        "create a string of 1024 spaces"
        Spaces1024 := ArrayedCollection new: 1024 withAll: $ 
    ]

    spaces: level [ ^Spaces1024 copyFrom: 1 to: (level * 2) ]

    processDir: level [
        "override"
        Transcript
            show: (self spaces: level) , '+' , name , '/';
            cr
    ]

    processFile: filename atLevel: level [
        "override"
        Transcript
            show: (self spaces: level) , filename;
            cr
    ]
]



Eval [
    DirPrinter init
]


Eval [
    d := DirPrinter new.
    d readAt: '/home/kwez/Videos'.
    d walk
]
