//
//  ViewController.m
//  AVFoundation-Video
//
//  Created by 佟莎莎 on 16/9/6.
//  Copyright © 2016年 asha. All rights reserved.
//

#import "ViewController.h"
#import "AVSyntheticVideoManager.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton * btn;

@property (nonatomic, strong) NSArray * imgNameArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btn = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.view addSubview:button];
        [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [self.btn setTitle:@"生成视频" forState:UIControlStateNormal];
    [self.btn sizeToFit];
    
    CGRect btnRect = self.btn.frame;
    btnRect.origin.y = 100;
    btnRect.origin.x = 100;
    self.btn.frame = btnRect;
    self.btn.backgroundColor = [UIColor greenColor];
    
    
    self.imgNameArray = @[@"IMG_01.jpg", @"IMG_02.jpg", @"IMG_03.jpg",@"IMG_04.jpg", @"IMG_05.jpg", @"IMG_06.jpg"];
    

}

-(void)buttonClickAction:(UIButton *)button
{
    
    AVSyntheticVideoManager * videoManager = [[AVSyntheticVideoManager alloc] initWithAnimaArray:_imgNameArray andCoverImg:[UIImage imageNamed:@"firstPage"]];
    [videoManager syntheticViewWithprogressBlock:^(CGFloat progress) {
        
    } andComplationBlock:^(NSError *error) {
        NSLog(@"生成完成，去相册查看");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
