//
//  ShowVIdeoViewController.h
//  TestDemo
//
//  Created by 张鹏 on 2017/5/30.
//  Copyright © 2017年 常逞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLVideoView.h"
#import <AVFoundation/AVFoundation.h>

@interface ShowVIdeoViewController : UIViewController

@property (nonatomic, strong) SLVideoView *videoView;

@property (nonatomic, strong) NSDictionary *videoDic;

@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) AVAsset *asset;

@property (nonatomic, copy) NSString *fileName;

@end
