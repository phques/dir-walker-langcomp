// DirWalker project
// Copyright 2013 Philippe Quesnel
// Licensed under the Academic Free License version 3.0

#ifndef _ONEDIRBASE_H_
#define _ONEDIRBASE_H_

#import <Foundation/Foundation.h>

@interface OneDirBase : NSObject
{
@private
  NSString* path;
  NSString* basePath;
  NSString* fullPath;
  NSMutableArray* filenames;    //NSString
  NSMutableArray* kids;         //OneDirBase
}

+ (OneDirBase*)withPath: (NSString*)path;

- init;
- (void)walk;
// overide these two for specific processing
- (void)processSubdirLevel:(int)level;
- (void)processFile:(NSString*)filename atLevel:(int)level;

- (NSString*)path;
- (NSString*)basePath;
- (NSString*)fullPath;
- (NSArray*)filenames;
- (NSArray*)kids;

@end

#endif // _ONEDIRBASE_H_

