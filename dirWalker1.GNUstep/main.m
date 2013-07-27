// DirWalker project
// Copyright 2013 Philippe Quesnel
// Licensed under the Academic Free License version 3.0

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

