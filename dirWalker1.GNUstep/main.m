/*
   Project: dirWalker1.GNUstep

   Copyright (C) 2010 Free Software Foundation

   Author: Philippe Quesnel,,,

   Created: 2010-10-17 16:27:06 -0400 by kwez

   This application is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This application is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA.
*/

#import <Foundation/Foundation.h>
#import "OneDirBase.h"

//---------------

// subclass OneDirBase to do processing: print subdirs / files
@interface DirWalkerPrint : OneDirBase
@end

@implementation DirWalkerPrint

// overide these two for specific processing
- (void)processSubdirLevel:(int)level
{
  if (level > 0)
    printf("%*c+%s/\n", level*2, ' ', [[self path] cString]);
  else
    printf("+%s/\n", [[self basePath] cString]);
}

- (void)processFile:(NSString*)filename atLevel:(int)level
{
  printf("%*c%s\n", (level+1)*2, ' ', [filename cString]);
}
@end

//---------------

int
main(int argc, const char *argv[])
{
  id pool = [[NSAutoreleasePool alloc] init];

  if (argc != 2)
  {
    printf("argument : dirToParse\n");
  }
  else
  {
    NSString* pathname = [NSString stringWithCString: argv[1]];
    OneDirBase* oneDir = [DirWalkerPrint withPath: pathname];
    if (oneDir)
    {
      NSLog(@"got onedir %@", [oneDir path]);
      NSLog(@"onedir files %@", [oneDir filenames]);
      NSLog(@"onedir kids %@", [oneDir kids]);
      [oneDir walk];
    }
  }
  
  // The end...
  [pool release];

  return 0;
}

