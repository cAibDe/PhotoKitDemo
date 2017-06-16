//
//  ViewController.m
//  PhotoKitDemo
//
//  Created by c4ibD3 on 2017/6/12.
//  Copyright © 2017年 c4ibD3. All rights reserved.
//

#import "ViewController.h"
#import "AlbumViewController.h"
#import "UIViewController+NavigationBar.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavigationBarToBack];
    self.title = @"PhotoKitDemo";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *pushButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 30)];
    pushButton.backgroundColor = [UIColor grayColor];
    [pushButton setTitle:@"PUSH" forState:UIControlStateNormal];
    [pushButton addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushButton];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)pushAction{
    AlbumViewController *albumVC = [[AlbumViewController alloc]init];
    [self.navigationController pushViewController:albumVC animated:YES];
}

@end
