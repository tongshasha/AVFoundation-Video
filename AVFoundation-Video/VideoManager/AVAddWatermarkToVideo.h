//
//  PjyAddWatermarkToVideo.h
//  changeriji
//
//  Created by TSS on 15/8/31.
//  Copyright (c) 2015年 Belync Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVSyntheticVideoManager.h"

//typedef void(^PjySyncheticVideoComplationBlock) (NSError * error);

@interface AVAddWatermarkToVideo : NSObject

+(void)addWatermarkWithBeginImg:(UIImage *)beginImg andEndImg:(UIImage *)endImg andFirstPImg:(UIImage *)PImg WithComplationBlock:(PjySyncheticVideoComplationBlock)complationBlock;

@end
