//
//  PjySyntheticVideoManager.h
//  changeriji
//
//  Created by TSS on 15/8/18.
//  Copyright (c) 2015年 Belync Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define PregnancyCameraVideoPath_1 [NSTemporaryDirectory() stringByAppendingPathComponent:@"pregnancyCamera_1.mov"]
#define PregnancyCameraVideoPath_2 [NSTemporaryDirectory() stringByAppendingPathComponent:@"pregnancyCamera_2.mov"]
#define PregnancyCameraVideoPath_3 [NSTemporaryDirectory() stringByAppendingPathComponent:@"pregnancyCamera_3.mov"]
#define PregnancyCameraVideoPath [NSTemporaryDirectory() stringByAppendingPathComponent:@"pregnancyCamera.mov"]

#define PregnancyCameraVideoPath_firstTwo [NSTemporaryDirectory() stringByAppendingPathComponent:@"pregnancyCamera_firstTwo.mov"]

#ifndef DLog
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#endif

typedef void (^PjySyncheticVideoProgressBlock)(CGFloat progress);
typedef void(^PjySyncheticVideoComplationBlock) (NSError * error);

@interface AVSyntheticVideoManager : NSObject

@property (nonatomic, strong) NSString * theVideoPath;

//+ (instancetype)sharedManager;


-(instancetype)initWithAnimaArray:(NSArray *)array andCoverImg:(UIImage *)coverImg;

-(void)syntheticViewWithprogressBlock:(PjySyncheticVideoProgressBlock)proBlock andComplationBlock:(PjySyncheticVideoComplationBlock)complationBlock;

@end
