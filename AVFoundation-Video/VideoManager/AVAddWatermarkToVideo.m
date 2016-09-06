//
//  PjyAddWatermarkToVideo.m
//  changeriji
//
//  Created by TSS on 15/8/31.
//  Copyright (c) 2015年 Belync Inc. All rights reserved.
//

#import "AVAddWatermarkToVideo.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "AVMergeAndSaveVideo.h"

@implementation AVAddWatermarkToVideo


+(void)addWatermarkWithBeginImg:(UIImage *)beginImg andEndImg:(UIImage *)endImg andFirstPImg:(UIImage *)PImg WithComplationBlock:(PjySyncheticVideoComplationBlock)complationBlock
{

    dispatch_group_t watermarkGroup = dispatch_group_create();
    
    for (int i = 0; i<3; i++) {
        
        dispatch_group_enter(watermarkGroup);
        
        NSString * pathStr;
        if (i == 0) {
            pathStr = PregnancyCameraVideoPath_1;
        }else if (i == 1) {
            pathStr = PregnancyCameraVideoPath_2;
        }else if (i == 2) {
            pathStr = PregnancyCameraVideoPath_3;
        }
        NSURL * url = [NSURL fileURLWithPath:pathStr];
        
        AVURLAsset * videoAsset = [[AVURLAsset alloc]initWithURL:url options:nil];
        AVMutableComposition * mixComposition = [AVMutableComposition composition];
        
        AVMutableCompositionTrack * compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        AVAssetTrack *clipVideoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                       ofTrack:clipVideoTrack
                                        atTime:kCMTimeZero error:nil];
        
        [compositionVideoTrack setPreferredTransform:[[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] preferredTransform]];
        
        CGSize videoSize = [clipVideoTrack naturalSize];
        
        
        
        CALayer *parentLayer = [CALayer layer];
        CALayer *videoLayer = [CALayer layer];
        parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
        videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
        [parentLayer addSublayer:videoLayer];
        
        
        if (i == 0) {
            
//            CALayer * PLayer = [CALayer layer];
//            PLayer.contents = (id)PImg.CGImage;
//            PLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height); //Needed for proper display. We are using the app icon (57x57). If you use 0,0 you will not see it
//            PLayer.opacity = 1; //Feel free to alter the alpha here
//            
//            CABasicAnimation *fadeOutanimation =[CABasicAnimation animationWithKeyPath:@"opacity"];
//            fadeOutanimation.duration=1.5;
//            fadeOutanimation.repeatCount=1;
//            fadeOutanimation.autoreverses=NO;
//            // animate from fully visible to invisible
//            fadeOutanimation.fromValue=[NSNumber numberWithFloat:0.0];
//            fadeOutanimation.toValue=[NSNumber numberWithFloat:1.0];
//            fadeOutanimation.beginTime = AVCoreAnimationBeginTimeAtZero;
//            [PLayer addAnimation:fadeOutanimation forKey:@"animateOpacity"];
//            [parentLayer addSublayer:PLayer];
            
            
            
            CALayer *beginLayer = [CALayer layer];
            beginLayer.contents = (id)beginImg.CGImage;
            beginLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height); //Needed for proper display. We are using the app icon (57x57). If you use 0,0 you will not see it
            beginLayer.opacity = 1; //Feel free to alter the alpha here
            
            
            CABasicAnimation *fadeInanimation =[CABasicAnimation animationWithKeyPath:@"opacity"];
            fadeInanimation.duration=1.5;
            fadeInanimation.repeatCount=1;
            fadeInanimation.autoreverses=YES;
            // animate from fully visible to invisible
            fadeInanimation.fromValue=[NSNumber numberWithFloat:0.0];
            fadeInanimation.toValue=[NSNumber numberWithFloat:1.0];
            fadeInanimation.beginTime = AVCoreAnimationBeginTimeAtZero;
            [beginLayer addAnimation:fadeInanimation forKey:@"animateOpacity"];
            [parentLayer addSublayer:beginLayer];
        }
        
//        if (i == 2) {
//            CALayer *endLayer = [CALayer layer];
//            endLayer.contents = (id)endImg.CGImage;
//            endLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height); //Needed for proper display. We are using the app icon (57x57). If you use 0,0 you will not see it
//            endLayer.opacity = 1; //Feel free to alter the alpha here
//            
//            
//            CABasicAnimation *animation
//            =[CABasicAnimation animationWithKeyPath:@"opacity"];
//            animation.duration=2.5;
//            animation.repeatCount=1;
//            animation.autoreverses=NO;
//            // animate from fully visible to invisible
//            animation.fromValue=[NSNumber numberWithFloat:0.0];
//            animation.toValue=[NSNumber numberWithFloat:1.0];
//            animation.beginTime = 2.0;
//            [endLayer addAnimation:animation forKey:@"animateOpacity"];
//            
//            [parentLayer addSublayer:endLayer];
//        }
        
        UIImage *myImage = [UIImage imageNamed:@"watermark.jpeg"];
        CALayer *aLayer = [CALayer layer];
        aLayer.contents = (id)myImage.CGImage;
        aLayer.frame = CGRectMake(videoSize.width-90-25, 90-25, 50, 50); //Needed for proper display. We are using the app icon (57x57). If you use 0,0 you will not see it
        aLayer.opacity = 0.6; //Feel free to alter the alpha here
        [parentLayer addSublayer:aLayer];
        
        
        AVMutableVideoComposition* videoComp = [AVMutableVideoComposition videoComposition];
        videoComp.renderSize = videoSize;
        videoComp.frameDuration = CMTimeMake(1, 30);
        videoComp.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
        
        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [mixComposition duration]);
        AVAssetTrack *videoTrack = [[mixComposition tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        AVMutableVideoCompositionLayerInstruction* layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
        videoComp.instructions = [NSArray arrayWithObject: instruction];
        
        
        AVAssetExportSession * assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];//AVAssetExportPresetPassthrough
        assetExport.videoComposition = videoComp;
        
        
        NSString *exportPath = pathStr;
        NSURL    *exportUrl = [NSURL fileURLWithPath:exportPath];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
        }
        
        assetExport.outputFileType = AVFileTypeQuickTimeMovie;
        assetExport.outputURL = exportUrl;
        assetExport.shouldOptimizeForNetworkUse = YES;
        
        //    [strRecordedFilename setString: exportPath];
        
        [assetExport exportAsynchronouslyWithCompletionHandler:
         ^(void ) {
             //YOUR FINALIZATION CODE HERE
             NSInteger  status = assetExport.status;
             switch (status)
             {
                 case AVAssetExportSessionStatusCompleted:
                 {
                     DLog(@"Export OK");
//                     if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathStr)) {
//                         UISaveVideoAtPathToSavedPhotosAlbum(pathStr, self, nil, nil);
//                     }
                 }
                     break;
                 case AVAssetExportSessionStatusFailed:
                     DLog (@"AVAssetExportSessionStatusFailed: %@", assetExport.error);
                     break;
                 case AVAssetExportSessionStatusCancelled:
                     DLog(@"Export Cancelled");
                     break;
             }
             dispatch_group_leave(watermarkGroup);
         }       
         ];
    }
    
    dispatch_group_notify(watermarkGroup, dispatch_get_main_queue(), ^{
        DLog(@"watermark finished");
        [AVMergeAndSaveVideo MergeAndSaveWithComplationBlock:complationBlock];
        
    });
}

+(void) video: (NSString *) videoPath didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if(error)
        DLog(@"Finished saving video with error: %@", error);
}

@end
