//
//  SLVideoView.h
//  SLVideoPlay
//
//  Created by shuaili on 14-7-11.
//  Copyright (c) 2014年 shuaili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
typedef NS_ENUM(NSInteger, LSVideoPlayerPlaybackState) {
    LSVideoPlayerPlaybackStateStopped = 0,//播放结束状态
    LSVideoPlayerPlaybackStatePlaying,//正在播放状态
    LSVideoPlayerPlaybackStatePaused,//暂停播放状态
    LSVideoPlayerPlaybackStateFailed,//播放失败状态(视频损坏或无法识别)
};
@class SLVideoView;

@protocol  SLVideoViewDelegate <NSObject>

@optional
- (void)canStartPlaying:(SLVideoView *)slVideoView;
- (void)networkNotBest:(SLVideoView *)slVideoView;
- (void)dontPlayer:(SLVideoView *)slVideoView;
- (void)bufferTimeLengh:(CGFloat)time;
- (void)currentPlayerTimeLengh:(CGFloat)time;
- (void)playEnd:(SLVideoView *)slVideoView;
@end
@interface SLVideoView : UIView
{
    
    id<SLVideoViewDelegate>_delegate;
    
    NSString *_videoModel;
    CMTimeScale _timeScale;
}
@property (nonatomic,retain)id<SLVideoViewDelegate>delegate;
@property (nonatomic,assign) LSVideoPlayerPlaybackState playbackState;
@property (nonatomic,copy) NSString *contentUrl;
@property (assign,readonly) CGFloat   totalTime;
@property (nonatomic,readonly)CMTimeScale  timeScale;
@property (nonatomic,copy) NSString *videoModel;

- (id)initWithFrame:(CGRect)frame contentUrl:(NSString *)url ;
- (id)initWithFrame:(CGRect)frame avasset:(AVAsset*)asset;

- (void)speed:(CMTime)speedValue;
- (void)play;
- (void)pause;
- (void)repeatPlaying;
@end
