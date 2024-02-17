//
//  utils.m
//  kfd
//
//  Created by Seo Hyun-gyu on 2023/07/30.
//

#import <Foundation/Foundation.h>
#import <dirent.h>
#import <sys/statvfs.h>
#import <sys/stat.h>
#import "proc.h"
#import "vnode.h"
#import "krw.h"
#import "helpers.h"
#include "offsets.h"
#import "thanks_opa334dev_htrowii.h"
#import <errno.h>
#import "utils.h"

uint64_t createFolderAndRedirect(uint64_t vnode, NSString *mntPath) {
    [[NSFileManager defaultManager] removeItemAtPath:mntPath error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:mntPath withIntermediateDirectories:NO attributes:nil error:nil];
    uint64_t orig_to_v_data = funVnodeRedirectFolderFromVnode(mntPath.UTF8String, vnode);
    return orig_to_v_data;
}

uint64_t UnRedirectAndRemoveFolder(uint64_t orig_to_v_data, NSString *mntPath) {
    funVnodeUnRedirectFolder(mntPath.UTF8String, orig_to_v_data);
    [[NSFileManager defaultManager] removeItemAtPath:mntPath error:nil];
    return 0;
}

int setResolution(NSString *path, NSInteger height, NSInteger width) {
    NSDictionary *dictionary = @{
        @"canvas_height": @(height),
        @"canvas_width": @(width)
    };
    
    BOOL success = [dictionary writeToFile:path atomically:YES];
    if (!success) {
        printf("[-] Failed createPlistAtPath.\n");
        return -1;
    }
    
    return 0;
}

NSData* dataFromFile(NSString* directoryPath, NSString* fileName) {
    NSString* mntPath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), [[NSUUID UUID] UUIDString]];
    uint64_t orig_to_v_data = createFolderAndRedirect(getVnodeAtPathByChdir((char *)[directoryPath UTF8String]), mntPath);
    NSData* fileData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", mntPath, fileName]];
    UnRedirectAndRemoveFolder(orig_to_v_data, mntPath);
    return fileData;
}

void writeDataToFile(NSData* fileData, NSString* directoryPath, NSString* fileName) {
    NSString* mntPath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), [[NSUUID UUID] UUIDString]];
    uint64_t orig_to_v_data = createFolderAndRedirect(getVnodeAtPathByChdir((char *)[directoryPath UTF8String]), mntPath);
    const void *_Nullable rawData = [fileData bytes];
    const char* data = (char *)rawData;
    int open_fd = open([NSString stringWithFormat:@"%@/%@", mntPath, fileName].UTF8String, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    write(open_fd, data, strlen(data));
    close(open_fd);
    UnRedirectAndRemoveFolder(orig_to_v_data, mntPath);
}

NSString* removeFile(NSString* directoryPath, NSString* fileName) {
    NSString* mntPath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), [[NSUUID UUID] UUIDString]];
    uint64_t orig_to_v_data = createFolderAndRedirect(getVnodeAtPathByChdir((char *)[directoryPath UTF8String]), mntPath);
    NSError* error;
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@", mntPath, fileName] error:&error];
    if (error) {
//        printf(error.localizedDescription.UTF8String);
    }
    UnRedirectAndRemoveFolder(orig_to_v_data, mntPath);
    return error.localizedDescription;
}

NSString* makeSymlink(NSString* directoryPath, NSString* fileName, NSString* destinationPath) {
    NSString* mntPath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), [[NSUUID UUID] UUIDString]];
    uint64_t orig_to_v_data = createFolderAndRedirect(getVnodeAtPathByChdir((char *)[directoryPath UTF8String]), mntPath);
    NSError* error;
    [[NSFileManager defaultManager] createSymbolicLinkAtPath:[NSString stringWithFormat:@"%@/%@", mntPath, fileName] withDestinationPath:destinationPath error:&error];
    if (error) {
//        printf(error.localizedDescription.UTF8String);
    }
    UnRedirectAndRemoveFolder(orig_to_v_data, mntPath);
    return error.localizedDescription;
}

BOOL isFileDeletable(NSString* directoryPath, NSString* fileName) {
    NSString* mntPath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), [[NSUUID UUID] UUIDString]];
    uint64_t orig_to_v_data = createFolderAndRedirect(getVnodeAtPathByChdir((char *)[directoryPath UTF8String]), mntPath);
    BOOL isDeletable = [[NSFileManager defaultManager] isDeletableFileAtPath:[NSString stringWithFormat:@"%@/%@", mntPath, fileName]];
    UnRedirectAndRemoveFolder(orig_to_v_data, mntPath);
    return isDeletable;
}

NSString* createDirectory(NSString* directoryPath, NSString* fileName) {
    NSString* mntPath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), [[NSUUID UUID] UUIDString]];
    uint64_t orig_to_v_data = createFolderAndRedirect(getVnodeAtPathByChdir((char *)[directoryPath UTF8String]), mntPath);
    NSError* error;
    [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@", mntPath, fileName] withIntermediateDirectories:NO attributes:nil error:&error];
    if (error) {
//        printf(error.localizedDescription.UTF8String);
    }
    UnRedirectAndRemoveFolder(orig_to_v_data, mntPath);
    return error.localizedDescription;
}

NSArray<NSString*>* contentsOfDirectory(NSString* directoryPath) {
    NSString* mntPath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), [[NSUUID UUID] UUIDString]];
    uint64_t orig_to_v_data = createFolderAndRedirect(getVnodeAtPathByChdir((char *)[directoryPath UTF8String]), mntPath);
    NSError* error;
    NSArray<NSString*>* directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:mntPath error:&error];
    if (error) {
//        printf(error.localizedDescription.UTF8String);
    }
    UnRedirectAndRemoveFolder(orig_to_v_data, mntPath);
    return directoryContents;
}

uint64_t createFolderAndRedirectR(NSString *path, NSString *mntPath) {
    [[NSFileManager defaultManager] removeItemAtPath:mntPath error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:mntPath withIntermediateDirectories:NO attributes:nil error:nil];
    uint64_t vnode = getVnodeAtPathByChdir(path.UTF8String);
    uint64_t orig_to_v_data = -1;
    if (vnode != -1) {
        orig_to_v_data = funVnodeRedirectFolderFromVnode(mntPath.UTF8String, vnode);
    } else {
        NSLog(@"Failed to get folder vnode");
    }
    return orig_to_v_data;
}

NSData* dataFromFileCopy(NSString* directoryPath, NSString* fileName) {
    NSString* mntPath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), [[NSUUID UUID] UUIDString]];
    NSString* copyPath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), [[NSUUID UUID] UUIDString]];
    uint64_t orig_to_v_data = createFolderAndRedirect(getVnodeAtPathByChdir((char *)[directoryPath UTF8String]), mntPath);
    NSError* error;
    [[NSFileManager defaultManager] copyItemAtPath:[NSString stringWithFormat:@"%@/%@", mntPath, fileName] toPath:copyPath error:&error];
    if (error) {
//        printf(error.localizedDescription.UTF8String);
    }
    NSData* fileData = [NSData dataWithContentsOfFile:copyPath];
    [[NSFileManager defaultManager] removeItemAtPath:copyPath error:&error];
    if (error) {
//        printf(error.localizedDescription.UTF8String);
    }
    UnRedirectAndRemoveFolder(orig_to_v_data, mntPath);
    return fileData;
}

BOOL isFileReadable(NSString* directoryPath, NSString* fileName) {
    NSString* mntPath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), [[NSUUID UUID] UUIDString]];
    uint64_t orig_to_v_data = createFolderAndRedirect(getVnodeAtPathByChdir((char *)[directoryPath UTF8String]), mntPath);
    BOOL isReadable = [[NSFileManager defaultManager] isReadableFileAtPath:[NSString stringWithFormat:@"%@/%@", mntPath, fileName]];
    UnRedirectAndRemoveFolder(orig_to_v_data, mntPath);
    return isReadable;
}
