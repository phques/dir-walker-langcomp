/*
   Project: dirWalker1.GNUstep

   Copyright (C) 2010 Free Software Foundation

   Author: Philippe Quesnel,,,

   Created: 2010-10-17 17:31:22 -0400 by kwez

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

