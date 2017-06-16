//
//  AlbumTableViewCell.m
//  PhotoKitDemo
//
//  Created by c4ibD3  on 2017/6/15.
//  Copyright © 2017年 c4ibD3. All rights reserved.
//

#import "AlbumTableViewCell.h"
#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self
@interface AlbumTableViewCell ()
@property (strong, nonatomic) PHCachingImageManager *imageManager;
@end
@implementation AlbumTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.contentView addSubview:self.albumImageView];
    [self.contentView addSubview:self.albumNameLabel];
    [self.contentView addSubview:self.albumCountLabel];
    
}
- (void)updateAlbumImage:(PHFetchResult *)fetchResult
                    name:(NSString *)name{
    if (fetchResult.count>0) {
        PHAsset *asset = fetchResult[fetchResult.count-1];
        WeakSelf(weakSelf);
        [self.imageManager requestImageForAsset:asset targetSize:CGSizeMake(self.bounds.size.height, self.bounds.size.height) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            weakSelf.albumImageView.image = result;
        }];
    }else{
        self.albumImageView.image = [UIImage imageNamed:@"blank"];
    }
    self.albumNameLabel.text = name;
    self.albumCountLabel.text = [NSString stringWithFormat:@" (%ld) ",fetchResult.count];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
#pragma mark - Lazy Load
- (UIImageView *)albumImageView{
    if (!_albumImageView) {
        _albumImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height)];
    }
    return _albumImageView;
}
- (UILabel *)albumNameLabel{
    if(!_albumNameLabel){
        _albumNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.height, 0, 150, self.bounds.size.height)];
    }
    return _albumNameLabel;
}
-(UILabel *)albumCountLabel{
    if (!_albumCountLabel) {
        _albumCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.height+150, 0, 100, self.bounds.size.height)];
    }
    return _albumCountLabel;
}
- (PHCachingImageManager *)imageManager {
    if (!_imageManager) {
        _imageManager = [[PHCachingImageManager alloc] init];
    }
    return _imageManager;
}
@end
