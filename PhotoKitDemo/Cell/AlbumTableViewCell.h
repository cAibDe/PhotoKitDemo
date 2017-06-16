//
//  AlbumTableViewCell.h
//  PhotoKitDemo
//
//  Created by c4ibD3  on 2017/6/15.
//  Copyright © 2017年 c4ibD3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@interface AlbumTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *albumImageView;
@property (nonatomic, strong) UILabel *albumNameLabel;
@property (nonatomic, strong) UILabel *albumCountLabel;

- (void)updateAlbumImage:(PHFetchResult *)fetchResult name:(NSString *)name;

@end
