//
//  utils.h
//  kfd
//
//  Created by Seo Hyun-gyu on 2023/07/30.
//

#include <stdio.h>
#import <Foundation/Foundation.h>

//File Manager Stuff
uint64_t createFolderAndRedirectR(NSString *path, NSString *mntPath);
NSData* dataFromFile(NSString* directoryPath, NSString* fileName);
void writeDataToFile(NSData* fileData, NSString* directoryPath, NSString* fileName);
NSString* removeFile(NSString* directoryPath, NSString* fileName);
NSString* makeSymlink(NSString* directoryPath, NSString* fileName, NSString* destinationPath);
BOOL isFileDeletable(NSString* directoryPath, NSString* fileName);
NSString* createDirectory(NSString* directoryPath, NSString* fileName);
NSArray<NSString*>* contentsOfDirectory(NSString* directoryPath);
NSData* dataFromFileCopy(NSString* directoryPath, NSString* fileName);
BOOL isFileReadable(NSString* directoryPath, NSString* fileName);
