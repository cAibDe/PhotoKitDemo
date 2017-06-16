//
//  PhotoCollectionViewCell.h
//  PhotoKitDemo
//
//  Created by c4ibD3 on 2017/6/15.
//  Copyright © 2017年 c4ibD3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@interface PhotoCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;

-(void)updatePhotoCellWith:(PHAsset *)asset;

@end
