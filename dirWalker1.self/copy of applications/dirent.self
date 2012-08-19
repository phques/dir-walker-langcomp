 '$Revision:$'
 '
Copyright 1992-2009 AUTHORS, Sun Microsystems, Inc. and Stanford University.
See the LICENSE file for license information.
'


 '-- Module body'

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> () From: ( | {
         'Category: applications\x7fCategory: dirent\x7fModuleInfo: Module: dirent InitialContents: FollowSlot\x7fVisibility: public'
        
         dirent = bootstrap setObjectAnnotationOf: bootstrap stub -> 'globals' -> 'dirent' -> () From: ( |
             {} = 'ModuleInfo: Creator: globals dirent.
'.
            | ) .
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'dirent' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: InitializeToExpression: (\'\')'
        
         name <- ''.
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> () From: ( | {
         'Category: applications\x7fCategory: dirent\x7fModuleInfo: Module: dirent InitialContents: FollowSlot\x7fVisibility: public'
        
         dirent = bootstrap setObjectAnnotationOf: bootstrap stub -> 'traits' -> 'dirent' -> () From: ( |
             {} = 'ModuleInfo: Creator: traits dirent.
'.
            | ) .
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'dirent' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot'
        
         parent* = bootstrap stub -> 'traits' -> 'dirent' -> ().
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'dirent' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: InitializeToExpression: (0)'
        
         type <- 0.
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> () From: ( | {
         'Category: applications\x7fCategory: dirent\x7fModuleInfo: Module: dirent InitialContents: FollowSlot\x7fVisibility: public'
        
         direntReader = bootstrap setObjectAnnotationOf: bootstrap stub -> 'globals' -> 'direntReader' -> () From: ( |
             {} = 'ModuleInfo: Creator: globals direntReader.
'.
            | ) .
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'direntReader' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: InitializeToExpression: (nil)'
        
         direntVec.
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'direntReader' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: InitializeToExpression: (nil)'
        
         file.
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> () From: ( | {
         'Category: applications\x7fCategory: dirent\x7fComment: allo\x7fModuleInfo: Module: dirent InitialContents: FollowSlot\x7fVisibility: public'
        
         direntVec = bootstrap setObjectAnnotationOf: bootstrap stub -> 'globals' -> 'direntVec' -> () From: ( |
             {} = 'ModuleInfo: Creator: globals direntVec.
'.
            | ) .
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'direntVec' -> () From: ( | {
         'Comment: Current index into vector, ie- next field\x7fModuleInfo: Module: dirent InitialContents: InitializeToExpression: (0)'
        
         idxCurr <- 0.
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'direntVec' -> () From: ( | {
         'Comment: index into vector of current dirent block\x7fModuleInfo: Module: dirent InitialContents: InitializeToExpression: (0)'
        
         idxDirent <- 0.
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> () From: ( | {
         'Category: applications\x7fCategory: dirent\x7fModuleInfo: Module: dirent InitialContents: FollowSlot\x7fVisibility: public'
        
         direntVec = bootstrap setObjectAnnotationOf: bootstrap stub -> 'traits' -> 'direntVec' -> () From: ( |
             {} = 'Comment: struct linux_dirent {
   unsigned long  d_ino;     /* Inode number */
   unsigned long  d_off;     /* Offset to next linux_dirent */
   unsigned short d_reclen;  /* Length of this linux_dirent */
   char           d_name[];  /* Filename (null-terminated) */
/* length is (d_reclen - 2 - offsetof d_name */
   char           pad;       // Zero padding byte
   char           d_type;    // File type (only since Linux 2.6.4;
                             // offset is (d_reclen - 1))
}\x7fModuleInfo: Creator: traits direntVec.
'.
            | ) .
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'direntVec' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot'
        
         parent* = bootstrap stub -> 'traits' -> 'direntVec' -> ().
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'direntVec' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: InitializeToExpression: (byteVector cloneSize: 256+32 FillingWith: 0)'
        
         vec <- byteVector cloneSize: 256+32 FillingWith: 0.
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'direntVec' -> () From: ( | {
         'Comment: length of data in vec\x7fModuleInfo: Module: dirent InitialContents: InitializeToExpression: (0)'
        
         vecDataLen <- 0.
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'modules' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot'
        
         dirent = bootstrap define: bootstrap stub -> 'globals' -> 'modules' -> 'dirent' -> () ToBe: bootstrap addSlotsTo: (
             bootstrap remove: 'directory' From:
             bootstrap remove: 'fileInTimeString' From:
             bootstrap remove: 'myComment' From:
             bootstrap remove: 'postFileIn' From:
             bootstrap remove: 'revision' From:
             bootstrap remove: 'subpartNames' From:
             globals modules init copy ) From: bootstrap setObjectAnnotationOf: bootstrap stub -> 'globals' -> 'modules' -> 'dirent' -> () From: ( |
             {} = 'ModuleInfo: Creator: globals modules dirent.

CopyDowns:
globals modules init. copy 
SlotsToOmit: directory fileInTimeString myComment postFileIn revision subpartNames.

\x7fIsComplete: '.
            | ) .
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'modules' -> 'dirent' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot\x7fVisibility: public'
        
         directory <- 'applications'.
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'modules' -> 'dirent' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: InitializeToExpression: (_CurrentTimeString)\x7fVisibility: public'
        
         fileInTimeString <- _CurrentTimeString.
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'modules' -> 'dirent' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot'
        
         myComment <- ''.
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'modules' -> 'dirent' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot'
        
         postFileIn = ( |
            | resend.postFileIn).
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'modules' -> 'dirent' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot\x7fVisibility: public'
        
         revision <- '$Revision:$'.
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'modules' -> 'dirent' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot\x7fVisibility: private'
        
         subpartNames <- ''.
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> 'dirent' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot'
        
         initName: name Type: type = ( |
            | 
            name: name.
            type: type).
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> 'dirent' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot'
        
         makeWithName: name Type: type = ( |
            | 
            dirent clone initName: name Type: type).
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> 'dirent' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot'
        
         parent* = bootstrap stub -> 'traits' -> 'clonable' -> ().
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> () From: ( | {
         'Category: applications\x7fCategory: dirent\x7fModuleInfo: Module: dirent InitialContents: FollowSlot\x7fVisibility: public'
        
         direntReader <- bootstrap setObjectAnnotationOf: bootstrap stub -> 'traits' -> 'direntReader' -> () From: ( |
             {} = 'ModuleInfo: Creator: traits direntReader.
'.
            | ) .
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> 'direntReader' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot\x7fVisibility: public'
        
         nextIfFail: fblk = ( |
             nbRead.
            | 
            "file nil when done"
            (file = nil) ifTrue: [^nil].

            " need to read more data ?"
            direntVec atEOF ifTrue: [
              nbRead: readDirentVec: direntVec 
                       WithFileDesc: fileDesc
                             IfFail: [|:e|
                       file close. reset.
                       fblk value: e.
                       ^nil.
                     ].
              ].

            "done reading dir ?"
            nbRead = 0 ifTrue: [
              file close. reset.
              ^nil.
            ].

            direntVec nextDirent).
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> 'direntReader' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot\x7fVisibility: public'
        
         openAt: dir = ( |
            | 
            file: os_file openForReading: dir
            "IfFail: [|:e| ^e]".

            fileDesc: file fileDescriptor.
            direntVec: globals direntVec copy.
            self).
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> 'direntReader' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot'
        
         parent* = bootstrap stub -> 'traits' -> 'clonable' -> ().
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> 'direntReader' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot'
        
         readDirentVec: direntVec WithFileDesc: fileDesc IfFail: fb = ( |
             resVec.
             sysCallRes.
            | 
            "'filedesc :' print. fileDesc printLine."

            resVec: os syscall: os sys_getdents 
                With: fileDesc And: 0
                With: direntVec vec And: 0 
                With: direntVec vec size And: 0
                IfFail: fb.

            sysCallRes: sysCallResCint: resVec.
            direntVec reset: sysCallRes.
            sysCallRes).
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> 'direntReader' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot'
        
         reset = ( |
            | 
            file: nil. fileDesc: nil. "direntVec: nil").
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> 'direntReader' -> () From: ( | {
         'Comment: \"Linux...\"
\"Why is result from syscall (4 byte vector) in bigEndian order ??\"
\"the normal syscall function to convert uses cInt & does NOT work\"\x7fModuleInfo: Module: dirent InitialContents: FollowSlot'
        
         sysCallResCint: sysCallResByteVec = ( |
            | 
            sysCallResByteVec bigEndianIntSize: 4*8 Signed: true At: 0).
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> 'direntVec' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot\x7fVisibility: public'
        
         atEOF = ( |
            | idxDirent >= vecDataLen).
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> 'direntVec' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot'
        
         copy = ( |
            | 
            direntVec clone init).
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> 'direntVec' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot'
        
         getName = ( |
             idxNull.
            | 
            "find terminating null byte"
            idxNull: idxCurr.
            [idxNull: idxNull succ] untilTrue: [(vec at: idxNull) = 0].

            "extract name string "
            (vec copyFrom: idxCurr UpTo: idxNull) asString).
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> 'direntVec' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot'
        
         getUlong = ( |
             val.
            | 
            val: vec cIntSize: longSizeBits Signed: false At: idxCurr.
            idxCurr: idxCurr + longSize.
            val).
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> 'direntVec' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot'
        
         getUshort = ( |
             val.
            | 
            val: vec cIntSize: shortSizeBits Signed: false At: idxCurr.
            idxCurr: idxCurr + shortSize.
            val).
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> 'direntVec' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot'
        
         init = ( |
            | 
            vec: byteVector cloneSize: 256+32 FillingWith: 0.
            idxCurr:  0.
            idxDirent: 0.
            self).
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> 'direntVec' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: InitializeToExpression: (typeSizes byteSize: \'long\')'
        
         longSize = typeSizes byteSize: 'long'.
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> 'direntVec' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: InitializeToExpression: ( typeSizes bitSize: \'long\')'
        
         longSizeBits =  typeSizes bitSize: 'long'.
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> 'direntVec' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot\x7fVisibility: public'
        
         nextDirent = ( |
             length.
             name.
             nameLen.
             type.
            | 
            "get parts, starting @ idxDirent"
            idxCurr: idxDirent.

            "inode" skipUlong.
            "offs" skipUlong.
            length: getUshort.
            name: getName.
            type: vec at: ((idxDirent + length) - 1).

            "increment direntVec index for next dirent"
            idxDirent: idxDirent + length.

            "create new dirent"
            dirent makeWithName: name Type: type).
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> 'direntVec' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot'
        
         parent* = bootstrap stub -> 'traits' -> 'clonable' -> ().
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> 'direntVec' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot\x7fVisibility: public'
        
         reset: dataLen = ( |
            | 
            idxCurr: 0.
            idxDirent: 0.
            vecDataLen: dataLen).
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> 'direntVec' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: InitializeToExpression: (typeSizes byteSize: \'short\')'
        
         shortSize = typeSizes byteSize: 'short'.
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> 'direntVec' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: InitializeToExpression: (typeSizes bitSize: \'short\')'
        
         shortSizeBits = typeSizes bitSize: 'short'.
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'traits' -> 'direntVec' -> () From: ( | {
         'ModuleInfo: Module: dirent InitialContents: FollowSlot'
        
         skipUlong = ( |
            | 
            idxCurr: idxCurr + longSize).
        } | ) 



 '-- Side effects'

 globals modules dirent postFileIn
