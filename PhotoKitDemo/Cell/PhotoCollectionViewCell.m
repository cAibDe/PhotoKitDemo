//
//  PhotoCollectionViewCell.m
//  PhotoKitDemo
//
//  Created by c4ibD3 on 2017/6/15.
//  Copyright © 2017年 c4ibD3. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self
@interface PhotoCollectionViewCell()
@property (strong, nonatomic) PHCachingImageManager *imageManager;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIImageView *livePhotoImageView;
@end
@implementation PhotoCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        ;
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.durationLabel];
    [self.contentView addSubview:self.livePhotoImageView];
}
- (void)updatePhotoCellWith:(PHAsset *)asset{
    WeakSelf(weakSelf);
    [self.imageManager requestImageForAsset:asset targetSize:CGSizeMake(self.bounds.size.width, self.bounds.size.width) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        weakSelf.imageView.image = result;
    }];
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        self.durationLabel.hidden = NO;
        self.livePhotoImageView.hidden = YES;
        NSInteger min = asset.duration / 60;
        NSInteger sec = (NSInteger)asset.duration % 60;
        NSInteger hour = min/60;
        min = min - 60 * hour;
        self.durationLabel.text = (hour>0)?[NSString stringWithFormat:@"%ld小时%ld分%ld秒",(long)hour,(long)min,(long)sec]:[NSString stringWithFormat:@"%ld分%ld秒",(long)min,(long)sec];
    }else if (asset.mediaType == PHAssetMediaTypeImage){
        self.durationLabel.hidden = YES;
        self.livePhotoImageView.hidden = YES;
        if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
            self.livePhotoImageView.hidden = NO;
            NSLog(@"PHAssetMediaSubtypePhotoLive");
        }else if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoPanorama){
            NSLog(@"PHAssetMediaSubtypePhotoPanorama");
        }else if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoHDR){
            NSLog(@"PHAssetMediaSubtypePhotoHDR");
        }else if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoScreenshot){
            NSLog(@"PHAssetMediaSubtypePhotoScreenshot");
        }else if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoDepthEffect){
            NSLog(@"PHAssetMediaSubtypePhotoDepthEffect");
        }else if (asset.mediaSubtypes == PHAssetMediaSubtypeNone){
            NSLog(@"PHAssetMediaSubtypeNone");
        }
    }
    

}
#pragma mark - Lazy Load
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width)];
    }
    return _imageView;
}
- (PHCachingImageManager *)imageManager {
    if (!_imageManager) {
        _imageManager = [[PHCachingImageManager alloc] init];
    }
    return _imageManager;
}
- (UILabel*)durationLabel{
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.width-30, self.bounds.size.width, 30)];
        _durationLabel.backgroundColor = [UIColor blackColor];
        _durationLabel.alpha = 0.4;
        _durationLabel.textColor = [UIColor whiteColor];
        _durationLabel.textAlignment = NSTextAlignmentRight;
    }
    return _durationLabel;
}
- (UIImageView *)livePhotoImageView{
    if (!_livePhotoImageView) {
        _livePhotoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width-30, self.bounds.size.width-30, 30, 30)];
        _livePhotoImageView.image = [UIImage imageNamed:@"timg"];
    }
    return _livePhotoImageView;
}
@end
