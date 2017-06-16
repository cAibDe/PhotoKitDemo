//
//  LivePhotoViewController.m
//  PhotoKitDemo
//
//  Created by 张鹏 on 2017/6/15.
//  Copyright © 2017年 张鹏. All rights reserved.
//

#import "LivePhotoViewController.h"

@interface LivePhotoViewController ()
@property (nonatomic, strong) PHLivePhoto *livePhoto;
@property (nonatomic, assign) BOOL muted;
@property (nonatomic, strong) UIGestureRecognizer *playbackGestureRecognizer;
@property (nonatomic, strong) PHLivePhotoView *livePhotoView;
@end

@implementation LivePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.livePhotoView = [[PHLivePhotoView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.livePhotoView];
    self.livePhotoView.contentMode = UIViewContentModeScaleAspectFit;
    [self.livePhotoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleHint];
    
    PHLivePhotoRequestOptions *options = [[PHLivePhotoRequestOptions alloc]init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = YES;
    options.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
        NSLog(@"progress = %f",progress);
    };
    [[PHImageManager defaultManager]requestLivePhotoForAsset:self.asset targetSize:self.livePhotoView.bounds.size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
        self.livePhotoView.livePhoto = livePhoto;
        NSLog(@"info = %@",info);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
