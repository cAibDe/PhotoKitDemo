//
//  ImageViewController.h
//  asd
//
//  Created by 张鹏 on 2017/6/2.
//  Copyright © 2017年 张鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@interface ImageViewController : UIViewController

@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) PHAsset *asset;
@end
