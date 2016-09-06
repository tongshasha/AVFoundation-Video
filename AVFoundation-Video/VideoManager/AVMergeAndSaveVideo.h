//
//  PjyMergeAndSaveVideo.h
//  changeriji
//
//  Created by TSS on 15/9/7.
//  Copyright (c) 2015年 Belync Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AVSyntheticVideoManager.h"

#ifndef DLog
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#endif

@interface AVMergeAndSaveVideo : NSObject

+ (void)MergeAndSaveWithComplationBlock:(PjySyncheticVideoComplationBlock)complationBlock;

@end
