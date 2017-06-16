//
//  SLVideoView.m
//  SLVideoPlay
//
//  Created by shuaili on 14-7-11.
//  Copyright (c) 2014年 shuaili. All rights reserved.
//
void *LSPlayer =&LSPlayer;
#import "SLVideoView.h"

@interface SLVideoView ()
{
    AVPlayer * _player;
    CGFloat  _currentTime;
}

@end
@implementation SLVideoView
@synthesize contentUrl=_contentUrl;
@synthesize playbackState=_playbackState;
@synthesize delegate=_delegate;
@synthesize totalTime=_totalTime;
@synthesize videoModel=_videoModel,timeScale=_timeScale;
- (void)dealloc
{
    [_player release];
    [_videoModel release];
    [_delegate release];
    [_contentUrl release];
    [super dealloc];

}
#pragma mark ---init
- (id)initWithFrame:(CGRect)frame contentUrl:(NSString *)url;
{

    self =[super initWithFrame:frame];
    if (self) {
        self.contentUrl=url;
    
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame avasset:(AVAsset *)asset{
    self =[super initWithFrame:frame];
    if (self) {
        [self _setAssert:asset];
    }
    return self;
}
#pragma mark ---Public Func
- (void)play
{
    [_player play];
    _playbackState=LSVideoPlayerPlaybackStatePlaying;
 
}
- (void)pause
{
    [_player pause];
    
    _playbackState =LSVideoPlayerPlaybackStatePaused;

}

- (void)repeatPlaying
{

   [_player seekToTime:kCMTimeZero];

    [_player play];
    _playbackState=LSVideoPlayerPlaybackStatePlaying;
    
}
- (void)speed:(CMTime)speedTime
{
 
   [_player.currentItem seekToTime:speedTime];
   
}
#pragma mark - getters/setters

- (void)setVideoModel:(NSString *)videoModel
{
    if (videoModel==_videoModel||videoModel==nil) {
        return;
    }
    _videoModel=videoModel;
    
    [self _setVideoModel:_player];
}
- (void)setContentUrl:(NSString *)contentUrl
{
   
    if (!contentUrl||[contentUrl length] == 0)
    {
        return;
    }
    
        NSURL *videoURL = [NSURL URLWithString:contentUrl];
        if (!videoURL || ![videoURL scheme])
        {
            videoURL = [NSURL fileURLWithPath:contentUrl];
        }
        
        AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
        [self  _setAssert:movieAsset];
   
     _contentUrl = contentUrl;
}

#pragma mark _set
- (void)_setAssert:(AVAsset *)assert
{
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:assert];
    _player =[AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer * playerLayer =[self _setVideoModel:_player];
     playerLayer.frame=self.frame;
     _videoModel=AVLayerVideoGravityResizeAspectFill;
    [_player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:LSPlayer];

    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges"options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter  defaultCenter]addObserver:self  selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    
    [self.layer addSublayer:playerLayer];
}

- (AVPlayerLayer*)_setVideoModel:(AVPlayer *)player
{
    AVPlayerLayer *playerLayer =[AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.videoGravity=_videoModel;
    return playerLayer;
}

#pragma mark ---Notification func

- (void)moviePlayDidEnd:(NSNotification *)nac
{
      _playbackState=LSVideoPlayerPlaybackStateStopped;
    
    if ([_delegate respondsToSelector:@selector(playEnd:)])
    {
        [_delegate playEnd:self];
    }
}

#pragma mark ---observeValueForKeyPath
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    
    if ([keyPath isEqualToString:@"status"])
    {
        
        if ([playerItem status] == AVPlayerStatusReadyToPlay)
        {
           
            [_player pause];
            _timeScale = playerItem.currentTime.timescale;
            CMTime duration = _player.currentItem.duration;
            
            _totalTime=CMTimeGetSeconds(duration);
            if ([_delegate respondsToSelector:@selector(canStartPlaying:)])
            {
                [_delegate canStartPlaying:self];
            }
            _playbackState =LSVideoPlayerPlaybackStatePaused;
            
         
            [self monitoringPlayback:_player.currentItem];
            
        } else if ([playerItem status] == AVPlayerStatusFailed)
        {
            if ([_delegate respondsToSelector:@selector(dontPlayer:)])
            {
                [_delegate dontPlayer:self];
            }
        }
        
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"])
    {
        
        NSTimeInterval timeInterval = [self availableDuration];
        if ([_delegate respondsToSelector:@selector(bufferTimeLengh:)])
        {
            [_delegate bufferTimeLengh:timeInterval];
        }
        
        int rate =[[NSString stringWithFormat:@"%f",_player.rate] intValue];
       
        if (_playbackState==LSVideoPlayerPlaybackStatePlaying&&rate==0)
        {
            
            if ([_delegate respondsToSelector:@selector(networkNotBest:)])
            {
                [_delegate networkNotBest:self];
            }
            float ti =[[NSString stringWithFormat:@"%f",timeInterval] floatValue];
            if (ti >_currentTime+2) {
                [_player play];
            }
        }
    }
}
#pragma mark ---prite func
- (NSTimeInterval)availableDuration
{
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;
    return result;
}
- (void)monitoringPlayback:(AVPlayerItem *)playerItem
{
    
    id  obj = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time)
    {
        
        CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;
        _currentTime = currentSecond;
               if ([_delegate respondsToSelector:@selector(currentPlayerTimeLengh:)])
               {
                   [_delegate  currentPlayerTimeLengh:currentSecond];
               }
        
    }];
    if (obj) {
        return;
    }

}

@end
