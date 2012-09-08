Object subclass: OneDirBase [
    | name kids filenames |
    
    <category: 'DirWalker'>
    <comment: 'Base class, reads directory structure recursively, reproducing in memory.Has a ''walk'' method that goes through the structure, call methods to process directories & files.Override it to provide actual processing of dir & files. (cf DirPrinter for an example that prints out the structure)Instance Variables:        name	<String>        kids	<(LinkedList of: OneDirBase)>        filenames	<(Collection of: (ProtoObject | PseudoContext))>'
    >

    OneDirBase class >> new [
        | r |
        <category: 'instance creation'>
        'OneDirBase new' printNl. "debug"
        r := super new.
        r init.
        ^r.
    ]

    init [
        <category: 'initialization'>
        'init' printNl.
        "super initialize."
        name := ''.
        kids := OrderedCollection new.
        filenames := OrderedCollection new.
    ]

    readAt: dirPath [
        "reads filenames & then recurses on subdir kids"

        <category: 'public'>
        | dir |
        dir := File name: dirPath.
        dir isDirectory ifFalse: [self error: 'not a directory'. ^nil].
        ^self readFrom: dir
    ]

    walk [
        "traverse/walk-thru our data"

        <category: 'public'>
        self walkAt: 0
    ]



    readFrom: dir [
        "FileDirectory"

        "reads filenames & then recurses on subdir kids"

        <category: 'private'>

        | kid subdirname |
        "sanity check"
        dir isDirectory ifFalse: [^nil].
        name := dir stripPath.
        
        "debug" 'readFrom: ' print. dir printNl.

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

        <category: 'private'>
        self processDir: level.
        kids do: [:kid | kid walkAt: level + 1].
        filenames do: [:filename | self processFile: filename atLevel: level + 1]
    ]

    processDir: level [
        "override this"

        <category: 'virtuals'>
        self subclassResponsibility
    ]

    processFile: filename atLevel: level [
        "override this"

        <category: 'virtuals'>
        self subclassResponsibility
    ]
]



OneDirBase subclass: DirPrinter [
    
    <category: 'DirWalker'>
    <comment: 'Subclasses OneDirBase to override the processDir & processFile:atLevel:  methods to protcess the data.This example override prints out the structure, indented (to Transcript)'>

    Spaces1024 := nil.

    DirPrinter class >> init [
        <category: 'initialization'>
        "super init."
        self initSpaces
    ]

    DirPrinter class >> initSpaces [
        "create a string of 1024 spaces"

        <category: 'initialization'>
        Spaces1024 := ArrayedCollection new: 1024 withAll: $ 
    ]

    spaces: level [
        <category: 'util'>
        | nbSpaces |
        nbSpaces := level * 2.
        ^Spaces1024 copyFrom: 1 to: nbSpaces
    ]

    processDir: level [
        "override"

        <category: 'virtuals'>
        Transcript
            show: (self spaces: level) , '+' , name , '/';
            cr
    ]

    processFile: filename atLevel: level [
        "override"

        <category: 'virtuals'>
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
    d readAt: '/home/kwez/temp'.
    d walk
]