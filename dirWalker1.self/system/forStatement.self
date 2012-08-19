 '$Revision:$'
 '
Copyright 1992-2009 AUTHORS, Sun Microsystems, Inc. and Stanford University.
See the LICENSE file for license information.
'


 '-- Module body'

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> () From: ( | {
         'Category: system\x7fComment: for: [i:0] & [i<10] & [i: i succ] Do: [
  i printLine
]\x7fModuleInfo: Module: forStatement InitialContents: FollowSlot\x7fVisibility: public'
        
         for: forBlocksCollector Do: execBlock = ( |
             blocks.
             init.
             step.
             test.
            | 
            blocks: forBlocksCollector asVector.
            init: blocks at: 0.
            test: blocks at: 1.
            step: blocks at: 2.
            init value.
            test whileTrue: [
              execBlock value.
              step value.
            ]).
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'modules' -> () From: ( | {
         'ModuleInfo: Module: forStatement InitialContents: FollowSlot'
        
         forStatement = bootstrap define: bootstrap stub -> 'globals' -> 'modules' -> 'forStatement' -> () ToBe: bootstrap addSlotsTo: (
             bootstrap remove: 'directory' From:
             bootstrap remove: 'fileInTimeString' From:
             bootstrap remove: 'myComment' From:
             bootstrap remove: 'postFileIn' From:
             bootstrap remove: 'revision' From:
             bootstrap remove: 'subpartNames' From:
             globals modules init copy ) From: bootstrap setObjectAnnotationOf: bootstrap stub -> 'globals' -> 'modules' -> 'forStatement' -> () From: ( |
             {} = 'ModuleInfo: Creator: globals modules forStatement.

CopyDowns:
globals modules init. copy 
SlotsToOmit: directory fileInTimeString myComment postFileIn revision subpartNames.

\x7fIsComplete: '.
            | ) .
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'modules' -> 'forStatement' -> () From: ( | {
         'ModuleInfo: Module: forStatement InitialContents: FollowSlot\x7fVisibility: public'
        
         directory <- 'system'.
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'modules' -> 'forStatement' -> () From: ( | {
         'ModuleInfo: Module: forStatement InitialContents: InitializeToExpression: (_CurrentTimeString)\x7fVisibility: public'
        
         fileInTimeString <- _CurrentTimeString.
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'modules' -> 'forStatement' -> () From: ( | {
         'ModuleInfo: Module: forStatement InitialContents: FollowSlot'
        
         myComment <- ''.
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'modules' -> 'forStatement' -> () From: ( | {
         'ModuleInfo: Module: forStatement InitialContents: FollowSlot'
        
         postFileIn = ( |
            | resend.postFileIn).
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'modules' -> 'forStatement' -> () From: ( | {
         'ModuleInfo: Module: forStatement InitialContents: FollowSlot\x7fVisibility: public'
        
         revision <- '$Revision:$'.
        } | ) 

 bootstrap addSlotsTo: bootstrap stub -> 'globals' -> 'modules' -> 'forStatement' -> () From: ( | {
         'ModuleInfo: Module: forStatement InitialContents: FollowSlot\x7fVisibility: private'
        
         subpartNames <- ''.
        } | ) 



 '-- Side effects'

 globals modules forStatement postFileIn
