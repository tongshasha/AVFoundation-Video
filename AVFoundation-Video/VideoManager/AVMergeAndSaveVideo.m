//
//  PjyMergeAndSaveVideo.m
//  changeriji
//
//  Created by TSS on 15/9/7.
//  Copyright (c) 2015年 Belync Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVMergeAndSaveVideo.h"

@implementation AVMergeAndSaveVideo


+ (void)MergeAndSaveWithComplationBlock:(PjySyncheticVideoComplationBlock)complationBlock{
    
    AVAsset * firstAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:PregnancyCameraVideoPath_1]];
    AVAsset * secondAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:PregnancyCameraVideoPath_2]];
    
    if(firstAsset !=nil && secondAsset!=nil){
        //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
        AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
        
        //VIDEO TRACK
        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        
        AVMutableCompositionTrack *secondTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [secondTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration) ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:firstAsset.duration error:nil];

        
        //AUDIO TRACK
//        if(audioAsset!=nil){
//            AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//            [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration)) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
//        }
        
        AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeAdd(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration)));
        MainInstruction.backgroundColor = [[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1] CGColor];
        
        //FIXING ORIENTATION//
        AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        AVAssetTrack *FirstAssetTrack = [[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        BOOL  isFirstAssetPortrait_  = NO;
        CGAffineTransform firstTransform = FirstAssetTrack.preferredTransform;
        if(firstTransform.a == 0 && firstTransform.b == 1.0 && firstTransform.c == -1.0 && firstTransform.d == 0)  {
            isFirstAssetPortrait_ = YES;
        }
        if(firstTransform.a == 0 && firstTransform.b == -1.0 && firstTransform.c == 1.0 && firstTransform.d == 0)  {
            isFirstAssetPortrait_ = YES;
        }
        if(firstTransform.a == 1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == 1.0)   {
        }
        if(firstTransform.a == -1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == -1.0) {
        }
        CGFloat FirstAssetScaleToFitRatio = 640.0/FirstAssetTrack.naturalSize.width;
        if(isFirstAssetPortrait_){
            FirstAssetScaleToFitRatio = 640.0/FirstAssetTrack.naturalSize.height;
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            [FirstlayerInstruction setTransform:CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
        }else{
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            [FirstlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, 0)) atTime:kCMTimeZero];
        }
        [FirstlayerInstruction setOpacity:0.0 atTime:firstAsset.duration];
        
        
        AVMutableVideoCompositionLayerInstruction *SecondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
        [SecondlayerInstruction setOpacityRampFromStartOpacity:0.0 toEndOpacity:1.0 timeRange:CMTimeRangeMake(firstAsset.duration, CMTimeMakeWithSeconds(2, 600))];
        AVAssetTrack *SecondAssetTrack = [[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        BOOL  isSecondAssetPortrait_  = NO;
        CGAffineTransform secondTransform = SecondAssetTrack.preferredTransform;
        if(secondTransform.a == 0 && secondTransform.b == 1.0 && secondTransform.c == -1.0 && secondTransform.d == 0)  {
            isSecondAssetPortrait_ = YES;
        }
        if(secondTransform.a == 0 && secondTransform.b == -1.0 && secondTransform.c == 1.0 && secondTransform.d == 0)  {
            isSecondAssetPortrait_ = YES;
        }
        if(secondTransform.a == 1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == 1.0)   {
        }
        if(secondTransform.a == -1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == -1.0) {
        }
        CGFloat SecondAssetScaleToFitRatio = 640.0/SecondAssetTrack.naturalSize.width;
        if(isSecondAssetPortrait_){
            SecondAssetScaleToFitRatio = 640.0/SecondAssetTrack.naturalSize.height;
            CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
            [SecondlayerInstruction setTransform:CGAffineTransformConcat(SecondAssetTrack.preferredTransform, SecondAssetScaleFactor) atTime:firstAsset.duration];
        }else{
            ;
            CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
            [SecondlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(SecondAssetTrack.preferredTransform, SecondAssetScaleFactor),CGAffineTransformMakeTranslation(0, 0)) atTime:firstAsset.duration];
        }
        [SecondlayerInstruction setOpacity:0.0 atTime:CMTimeAdd(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration))];
        
        
        MainInstruction.layerInstructions = [NSArray arrayWithObjects:FirstlayerInstruction,SecondlayerInstruction,nil];
        
        AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
        MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
        MainCompositionInst.frameDuration = CMTimeMake(1, 30);
        MainCompositionInst.renderSize = CGSizeMake(640.0, 960.0);
        
        NSString *myPathDocs = PregnancyCameraVideoPath_firstTwo;
        
        NSURL *url = [NSURL fileURLWithPath:myPathDocs];
        
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
        exporter.outputURL=url;
        exporter.outputFileType = AVFileTypeQuickTimeMovie;
        exporter.videoComposition = MainCompositionInst;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^
         {
             [AVMergeAndSaveVideo MergeAndSaveTotalWithComplationBlock:complationBlock];
         }];
    }
}


+(void)MergeAndSaveTotalWithComplationBlock:(PjySyncheticVideoComplationBlock)complationBlock
{
    AVAsset * firstAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:PregnancyCameraVideoPath_firstTwo]];
    AVAsset * secondAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:PregnancyCameraVideoPath_3]];
    
    if(firstAsset !=nil && secondAsset!=nil){
        //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
        AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
        
        //VIDEO TRACK
        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        
        AVMutableCompositionTrack *secondTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [secondTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration) ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:firstAsset.duration error:nil];
        
        
        //AUDIO TRACK
        //        if(audioAsset!=nil){
        //            AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        //            [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration)) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        //        }
        
        AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeAdd(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration)));
        MainInstruction.backgroundColor = [[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1] CGColor];
        
        //FIXING ORIENTATION//
        AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        AVAssetTrack *FirstAssetTrack = [[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        BOOL  isFirstAssetPortrait_  = NO;
        CGAffineTransform firstTransform = FirstAssetTrack.preferredTransform;
        if(firstTransform.a == 0 && firstTransform.b == 1.0 && firstTransform.c == -1.0 && firstTransform.d == 0)  {
            isFirstAssetPortrait_ = YES;
        }
        if(firstTransform.a == 0 && firstTransform.b == -1.0 && firstTransform.c == 1.0 && firstTransform.d == 0)  {
            isFirstAssetPortrait_ = YES;
        }
        if(firstTransform.a == 1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == 1.0)   {
        }
        if(firstTransform.a == -1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == -1.0) {
        }
        CGFloat FirstAssetScaleToFitRatio = 640.0/FirstAssetTrack.naturalSize.width;
        if(isFirstAssetPortrait_){
            FirstAssetScaleToFitRatio = 640.0/FirstAssetTrack.naturalSize.height;
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            [FirstlayerInstruction setTransform:CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
        }else{
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            [FirstlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, 0)) atTime:kCMTimeZero];
        }
        [FirstlayerInstruction setOpacity:0.0 atTime:firstAsset.duration];
        
        
        AVMutableVideoCompositionLayerInstruction *SecondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
        [SecondlayerInstruction setOpacityRampFromStartOpacity:0.2 toEndOpacity:1.0 timeRange:CMTimeRangeMake(firstAsset.duration, CMTimeMakeWithSeconds(2, 600))];
        AVAssetTrack *SecondAssetTrack = [[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        BOOL  isSecondAssetPortrait_  = NO;
        CGAffineTransform secondTransform = SecondAssetTrack.preferredTransform;
        if(secondTransform.a == 0 && secondTransform.b == 1.0 && secondTransform.c == -1.0 && secondTransform.d == 0)  {
            isSecondAssetPortrait_ = YES;
        }
        if(secondTransform.a == 0 && secondTransform.b == -1.0 && secondTransform.c == 1.0 && secondTransform.d == 0)  {
            isSecondAssetPortrait_ = YES;
        }
        if(secondTransform.a == 1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == 1.0)   {
        }
        if(secondTransform.a == -1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == -1.0) {
        }
        CGFloat SecondAssetScaleToFitRatio = 640.0/SecondAssetTrack.naturalSize.width;
        if(isSecondAssetPortrait_){
            SecondAssetScaleToFitRatio = 640.0/SecondAssetTrack.naturalSize.height;
            CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
            [SecondlayerInstruction setTransform:CGAffineTransformConcat(SecondAssetTrack.preferredTransform, SecondAssetScaleFactor) atTime:firstAsset.duration];
        }else{
            ;
            CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
            [SecondlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(SecondAssetTrack.preferredTransform, SecondAssetScaleFactor),CGAffineTransformMakeTranslation(0, 0)) atTime:firstAsset.duration];
        }
        [SecondlayerInstruction setOpacity:0.0 atTime:CMTimeAdd(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration))];
        
        
        MainInstruction.layerInstructions = [NSArray arrayWithObjects:FirstlayerInstruction,SecondlayerInstruction,nil];
        
        AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
        MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
        MainCompositionInst.frameDuration = CMTimeMake(1, 30);
        MainCompositionInst.renderSize = CGSizeMake(640.0, 960.0);
        
        NSString *myPathDocs =  PregnancyCameraVideoPath;
        
        NSURL *url = [NSURL fileURLWithPath:myPathDocs];
        
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
        exporter.outputURL=url;
        exporter.outputFileType = AVFileTypeQuickTimeMovie;
        exporter.videoComposition = MainCompositionInst;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^
         {
             
             ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
             if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:url]) {
                 [library writeVideoAtPathToSavedPhotosAlbum:url
                                             completionBlock:^(NSURL *assetURL, NSError *error){
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     
                                                     if (complationBlock) {
                                                         NSError * error;
                                                         complationBlock(error);
                                                     }
                                                     
                                                     if (error) {
                                                         DLog(@"Video Saving Failed");
                                                     }else{
                                                         DLog(@"Saved To Photo Album");
                                                     }
                                                     [AVMergeAndSaveVideo removeVideoInTemp];
                                                     
                                                 });
                                                 
                                             }];
             }
         }];
    }
}

+(void)removeVideoInTemp
{
    NSError * error;
    if ([AVMergeAndSaveVideo isFileExitsAtPath:PregnancyCameraVideoPath])  {
        [[NSFileManager defaultManager] removeItemAtPath:PregnancyCameraVideoPath error:&error];
        if (error) {
            DLog(@"移除孕照视频失败");
        }else {
            DLog(@"成功移除孕照视频");
        }
    }
    if ([AVMergeAndSaveVideo isFileExitsAtPath:PregnancyCameraVideoPath_1])  {
        [[NSFileManager defaultManager] removeItemAtPath:PregnancyCameraVideoPath_1 error:&error];
        if (error) {
            DLog(@"移除孕照视频1失败");
        }else {
            DLog(@"成功移除孕照视频1");
        }
    }
    if ([AVMergeAndSaveVideo isFileExitsAtPath:PregnancyCameraVideoPath_2])  {
        [[NSFileManager defaultManager] removeItemAtPath:PregnancyCameraVideoPath_2 error:&error];
        if (error) {
            DLog(@"移除孕照视频2失败");
        }else {
            DLog(@"成功移除孕照视频2");
        }
    }
    if ([AVMergeAndSaveVideo isFileExitsAtPath:PregnancyCameraVideoPath_3])  {
        [[NSFileManager defaultManager] removeItemAtPath:PregnancyCameraVideoPath_3 error:&error];
        if (error) {
            DLog(@"移除孕照视频3失败");
        }else {
            DLog(@"成功移除孕照视频3");
        }
    }
    if ([AVMergeAndSaveVideo isFileExitsAtPath:PregnancyCameraVideoPath_firstTwo])  {
        [[NSFileManager defaultManager] removeItemAtPath:PregnancyCameraVideoPath_firstTwo error:&error];
        if (error) {
            DLog(@"移除孕照视频firstTwo失败");
        }else {
            DLog(@"成功移除孕照视频firstTwo");
        }
    }
}

+ (BOOL)isFileExitsAtPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath isDirectory:NULL]) {
        return YES;
    }
    
    return NO;
}

@end
