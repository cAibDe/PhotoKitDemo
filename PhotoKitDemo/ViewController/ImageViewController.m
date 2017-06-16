//
//  ImageViewController.m
//  asd
//
//  Created by 张鹏 on 2017/6/2.
//  Copyright © 2017年 张鹏. All rights reserved.
//

#import "ImageViewController.h"
#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self

@interface ImageViewController ()
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64
                                        )];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    WeakSelf(weakSelf);
    [[PHImageManager defaultManager]requestImageDataForAsset:self.asset                                                             options:nil
                                               resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                                   
                                                   UIImage *selectedImage = [UIImage imageWithData:imageData];
                                                   weakSelf.imageView.image = selectedImage;
                                                   weakSelf.title = [[info objectForKey:@"PHImageFileURLKey"] lastPathComponent];
                                               }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
