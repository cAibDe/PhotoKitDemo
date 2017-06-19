//
//  ShowVIdeoViewController.m
//  TestDemo
//
//  Created by 张鹏 on 2017/5/30.
//  Copyright © 2017年 常逞. All rights reserved.
//

#import "ShowVIdeoViewController.h"
#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )
@interface ShowVIdeoViewController ()<SLVideoViewDelegate>{
    AVMutableComposition *mutableComposition;
    AVMutableVideoComposition *mutableVideoComposition;
}

@end

@implementation ShowVIdeoViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.videoView pause];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.fileName;
    [self creatVideoView];
}
-(void)creatVideoView{
//    self.videoView = [[SLVideoView alloc]initWithFrame:CGRectMake(5.f, 60.f, self.view.bounds.size.width - 20.f,300.f) contentUrl:[self.videoDic objectForKey:@"path"]];
//    
//    self.videoView = [[SLVideoView alloc]initWithFrame:CGRectMake(5.f, 60.f, self.view.bounds.size.width - 20.f,300.f) avasset:self.asset];
    
    self.videoView = [[SLVideoView alloc]initWithFrame:CGRectMake(5.f, 60.f, self.view.bounds.size.width - 20.f,300.f) playerItem:self.playerItem];
    
    self.videoView.delegate = self;
    
    
    [self.view addSubview:self.videoView];
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setFrame:self.videoView.bounds];
    playButton.center = self.videoView.center;
    [playButton setImage:[UIImage imageNamed:@"本地媒体视频播放按钮"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"本地媒体视频空白按钮"] forState:UIControlStateSelected];
    _playButton = playButton;
    [playButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoView addSubview:playButton];
    [self.videoView bringSubviewToFront:playButton];

}
- (void)buttonAction:(UIButton *)button{
    
    if (button == _playButton) {
        /*视频本地播放*/
        switch (self.videoView.playbackState)
        {
            case LSVideoPlayerPlaybackStatePaused:
            {
                [self.videoView play];
                _playButton.selected = YES;
            }
                break;
            case LSVideoPlayerPlaybackStatePlaying:
            {
                [self.videoView pause];
                _playButton.selected = NO;
            }
                break;
            case LSVideoPlayerPlaybackStateStopped:
            {
                [self.videoView repeatPlaying];
                _playButton.selected = YES;
            }
                break;
            case LSVideoPlayerPlaybackStateFailed:
            {
                [self.videoView pause];
                _playButton.selected = NO;
            }
                break;
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
