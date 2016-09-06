//
//  PjySyntheticVideoManager.m
//  changeriji
//
//  Created by TSS on 15/8/18.
//  Copyright (c) 2015年 Belync Inc. All rights reserved.
//

#import "AVSyntheticVideoManager.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AVAddWatermarkToVideo.h"


@interface AVSyntheticVideoManager()
{
}

@property (nonatomic, strong) NSMutableArray * imageArr;
@property (nonatomic, strong) UIImage * coverImg;
@end

@implementation AVSyntheticVideoManager

//+ (instancetype)sharedManager
//{
//    static PjySyntheticVideoManager *sharedPhotoManager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedPhotoManager = [[PjySyntheticVideoManager alloc] init];
//    });
//    return sharedPhotoManager;
//}


-(instancetype)initWithAnimaArray:(NSArray *)array andCoverImg:(UIImage *)coverImg{
    self = [super init];
    if (self) {
        UIImage * firstImg = [UIImage imageNamed:@"firstPage.png"];
        UIImage * lastImg = [UIImage imageNamed:@"lastPage.png"];
        _imageArr = [[NSMutableArray alloc]initWithArray:array];
        [_imageArr insertObject:firstImg atIndex:0];
        [_imageArr addObject:lastImg];
        
        NSString *myPathDocs =  PregnancyCameraVideoPath;
        _theVideoPath = myPathDocs;
        
        _coverImg = coverImg;
    }
    return self;
}

- (BOOL)isFileExitsAtPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath isDirectory:NULL]) {
        return YES;
    }
    
    return NO;
}

-(void)syntheticViewWithprogressBlock:(PjySyncheticVideoProgressBlock)proBlock andComplationBlock:(PjySyncheticVideoComplationBlock)complationBlock
{
    NSError * error = nil;
    if ([self isFileExitsAtPath:_theVideoPath])  {
        [[NSFileManager defaultManager] removeItemAtPath:_theVideoPath error:&error];
        if (error) {
            DLog(@"移除孕照视频失败");
        }else {
            DLog(@"成功移除孕照视频");
        }
    }
    if ([self isFileExitsAtPath:PregnancyCameraVideoPath_1])  {
        [[NSFileManager defaultManager] removeItemAtPath:PregnancyCameraVideoPath_1 error:&error];
        if (error) {
            DLog(@"移除孕照视频1失败");
        }else {
            DLog(@"成功移除孕照视频1");
        }
    }
    if ([self isFileExitsAtPath:PregnancyCameraVideoPath_2])  {
        [[NSFileManager defaultManager] removeItemAtPath:PregnancyCameraVideoPath_2 error:&error];
        if (error) {
            DLog(@"移除孕照视频2失败");
        }else {
            DLog(@"成功移除孕照视频2");
        }
    }
    if ([self isFileExitsAtPath:PregnancyCameraVideoPath_3])  {
        [[NSFileManager defaultManager] removeItemAtPath:PregnancyCameraVideoPath_3 error:&error];
        if (error) {
            DLog(@"移除孕照视频3失败");
        }else {
            DLog(@"成功移除孕照视频3");
        }
    }
    if ([self isFileExitsAtPath:PregnancyCameraVideoPath_firstTwo])  {
        [[NSFileManager defaultManager] removeItemAtPath:PregnancyCameraVideoPath_firstTwo error:&error];
        if (error) {
            DLog(@"移除孕照视频firstTwo失败");
        }else {
            DLog(@"成功移除孕照视频firstTwo");
        }
    }
    
    
    [self writeImagesAsMovie:_imageArr progressBlock:proBlock andComplationBlock:complationBlock];
}

- (void) writeImagesAsMovie:(NSArray *)array progressBlock:(PjySyncheticVideoProgressBlock)progressBlock andComplationBlock:(PjySyncheticVideoComplationBlock)complationBlock {
    
    dispatch_group_t videoGroup = dispatch_group_create();
    
    for (int m = 0; m<3; m++) {
        
        switch (m) {
            case 0:
                _theVideoPath = PregnancyCameraVideoPath_1;
                break;
            case 1:
                _theVideoPath = PregnancyCameraVideoPath_2;
                break;
            case 2:
                _theVideoPath = PregnancyCameraVideoPath_3;
                break;
            default:
                break;
        }
        
        dispatch_group_enter(videoGroup);

        UIImage *first;
        NSArray * imgArray;
        
        if (m == 0) {
            first = array[0];
            imgArray = [NSArray arrayWithArray:[array subarrayWithRange:NSMakeRange(0, 1)]];
        }else if (m == 1) {
            first = [UIImage imageNamed:array[1]];
            imgArray = [NSArray arrayWithArray:[array subarrayWithRange:NSMakeRange(1, [array count]-2)]];
        }else {
            first = [array lastObject];
            imgArray = [NSArray arrayWithArray:[array subarrayWithRange:NSMakeRange([array count]-1, 1)]];
        }
        
        if (first.size.width != 640 || first.size.height != 960) {
            first = [AVSyntheticVideoManager image:first fitInSize:CGSizeMake(640, 960)];
        }
        
        CGSize frameSize = CGSizeMake(640, 960);
        
        NSError *error = nil;
        AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:
                                      [NSURL fileURLWithPath:_theVideoPath] fileType:AVFileTypeQuickTimeMovie
                                                                  error:&error];
        
        if(error) {
            DLog(@"error creating AssetWriter: %@",[error description]);
        }
        
        NSDictionary * videoSettings = @{AVVideoCodecKey: AVVideoCodecH264,
                                         AVVideoWidthKey: [NSNumber numberWithInt:frameSize.width],
                                         AVVideoHeightKey: [NSNumber numberWithInt:frameSize.height]};
        
        AVAssetWriterInput* writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                                             outputSettings:videoSettings];
        
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        [attributes setObject:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32ARGB] forKey:(NSString*)kCVPixelBufferPixelFormatTypeKey];
        [attributes setObject:[NSNumber numberWithUnsignedInt:frameSize.width] forKey:(NSString*)kCVPixelBufferWidthKey];
        [attributes setObject:[NSNumber numberWithUnsignedInt:frameSize.height] forKey:(NSString*)kCVPixelBufferHeightKey];
        
        AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                         assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput
                                                         sourcePixelBufferAttributes:attributes];
        
        [videoWriter addInput:writerInput];
        
        // fixes all errors
        writerInput.expectsMediaDataInRealTime = YES;
        
        //Start a session:
        [videoWriter startWriting];
        [videoWriter startSessionAtSourceTime:kCMTimeZero];
        
        CVPixelBufferRef buffer;
        buffer = [self pixelBufferFromCGImage:[first CGImage]];
        //    buffer = [self crossFadeImage:[first CGImage] toImage:[secImg CGImage] atSize:frameSize withAlpha:0.1];
        BOOL result = [adaptor appendPixelBuffer:buffer withPresentationTime:kCMTimeZero];
        
        if (result == NO) //failes on 3GS, but works on iphone 4
            DLog(@"failed to append buffer");
        
        if(buffer)
            CVBufferRelease(buffer);
        
        [NSThread sleepForTimeInterval:0.05];

        int fps = 3;

        
        int i = 0;
        for (NSString *imgPath in imgArray)
        {
            UIImage * imgFrame;
            if (m == 0) {
                if (i == 0) {
                    imgFrame = imgArray[0];
                }else {
                    imgFrame = [UIImage imageNamed:imgPath];
                }
            }else if (m == 1) {
                    imgFrame = [UIImage imageNamed:imgPath];
            }else {
                if (i == [imgArray count]-1) {
                    imgFrame = [imgArray lastObject];
                }else {
                    imgFrame = [UIImage imageNamed:imgPath];
                }
            }
            
            CGSize imgSize = imgFrame.size;
            
            DLog(@"%@",NSStringFromCGSize(imgSize));
            if (imgSize.width != 640 || imgSize.height != 960) {
                imgFrame = [AVSyntheticVideoManager image:imgFrame fitInSize:CGSizeMake(640, 960)];
            }
            
            if (adaptor.assetWriterInput.readyForMoreMediaData)
            {
                
                i++;
                DLog(@"inside for loop %d ",i);
                
                CGFloat progress = i*1.0/[imgArray count];
                progressBlock(progress);
                
                CMTime frameTime ;
                if (m == 0) {
                    frameTime = CMTimeMake(3, fps);
                }else if (m == 2) {
                    frameTime = CMTimeMake(3, fps);
                }else {
                    frameTime = CMTimeMake(3, fps);
                }
                CMTime lastTime=CMTimeMake(i, fps);
                CMTime presentTime=CMTimeAdd(lastTime, frameTime);

                
                buffer = [self pixelBufferFromCGImage:[imgFrame CGImage]];
                
                BOOL result = [adaptor appendPixelBuffer:buffer withPresentationTime:presentTime];
                
                if (result == NO) //failes on 3GS, but works on iphone 4
                {
                    DLog(@"failed to append buffer");
                    DLog(@"The error is %@", [videoWriter error]);
                }
                if(buffer)
                    CVBufferRelease(buffer);
                
                
                
                [NSThread sleepForTimeInterval:0.05];
            }
            else
            {
                DLog(@"error");
                i--;
            }
            [NSThread sleepForTimeInterval:0.02];
        }
        
        //Finish the session:
        [writerInput markAsFinished];
        [videoWriter finishWritingWithCompletionHandler:^{
            
            dispatch_group_leave(videoGroup);
            
            
            
        }];
        
        [NSThread sleepForTimeInterval:0.05];
       

        CVPixelBufferPoolRelease(adaptor.pixelBufferPool);
        
    }
    
    dispatch_group_notify(videoGroup, dispatch_get_main_queue(), ^{
        UIImage * lastImg = [UIImage imageNamed:@"lastPage.png"];
        UIImage * pImg = [UIImage imageNamed:array[1]];
        pImg = [AVSyntheticVideoManager image:pImg fitInSize:CGSizeMake(640, 960)];
        [AVAddWatermarkToVideo addWatermarkWithBeginImg:_coverImg andEndImg:lastImg andFirstPImg:pImg WithComplationBlock:complationBlock];

    });
    

    
}


- (CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) image
{
    NSDictionary * options = @{(id)kCVPixelBufferCGImageCompatibilityKey: @(YES),
                               (id)kCVPixelBufferCGBitmapContextCompatibilityKey: @(YES)};
    CVPixelBufferRef pxbuffer = NULL;
    
    CVPixelBufferCreate(kCFAllocatorDefault, CGImageGetWidth(image),
                        CGImageGetHeight(image), kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                        &pxbuffer);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, CGImageGetWidth(image),
                                                 CGImageGetHeight(image), 8, 4*CGImageGetWidth(image), rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipFirst);
    
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
    
    //旋转
    CGAffineTransform flipVertical = CGAffineTransformMake(
                                                           1, 0, 0, 1, 0, 0
                                                           );
    CGContextConcatCTM(context, flipVertical);

    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

//返回调整的缩略图
+ (UIImage *) image: (UIImage *) image fitInSize: (CGSize) viewsize
{
    // calculate the fitted size
    CGSize size = [self fitSize:image.size inSize:viewsize];
    //    CGSize size = [WeChatShare fitSize:CGSizeMake(image.size.width/2, image.size.height/2) inSize:viewsize];
    
    UIGraphicsBeginImageContext(viewsize);
    
    float dwidth = (viewsize.width - size.width) / 2.0f;
    float dheight = (viewsize.height - size.height) / 2.0f;
    
    CGRect rect = CGRectMake(dwidth, dheight, size.width, size.height);
    [image drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

//计算适合的大小。并保留其原始图片大小
+ (CGSize) fitSize: (CGSize)thisSize inSize: (CGSize) aSize
{
    CGFloat scale;
    CGSize newsize = thisSize;
    
    if (newsize.height && (newsize.height > aSize.height))
    {
        scale = aSize.height / newsize.height;
        newsize.width *= scale;
        newsize.height *= scale;
    }
    
    if (newsize.width && (newsize.width >= aSize.width))
    {
        scale = aSize.width / newsize.width;
        newsize.width *= scale;
        newsize.height *= scale;
    }
    
    return newsize;
}


@end
