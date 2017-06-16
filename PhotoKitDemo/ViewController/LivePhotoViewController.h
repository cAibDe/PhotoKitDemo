//
//  LivePhotoViewController.h
//  PhotoKitDemo
//
//  Created by 张鹏 on 2017/6/15.
//  Copyright © 2017年 张鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface LivePhotoViewController : UIViewController
@property (nonatomic, strong) PHAsset *asset;
@end
