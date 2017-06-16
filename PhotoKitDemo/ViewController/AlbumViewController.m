//
//  PushViewController.m
//  PhotoKitDemo
//
//  Created by c4ibD3 on 2017/6/12.
//  Copyright © 2017年 c4ibD3. All rights reserved.
//

#import "AlbumViewController.h"
#import <Photos/Photos.h>
#import "AlbumTableViewCell.h"
#import "UIViewController+NavigationBar.h"
#import "MediaBrowseCollectionViewController.h"
@interface AlbumViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) PHFetchOptions *options;

@property (strong, nonatomic) NSMutableArray *smartFetchResultArray;

@property (strong, nonatomic) NSMutableArray *smartFetchResultTitlt;

@property (strong, nonatomic) PHCachingImageManager *imageManager;

@property (strong, nonatomic) UITableView *albumTableView;

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavigationBarToBack];
    self.title = @"AllAlbums";
    self.view.backgroundColor = [UIColor whiteColor];
    [self getAuthorized];

}
#pragma mark - 处理相册授权
- (void)getAuthorized{
    //判断是否有访问权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    //还没有去做选择
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            //已经授权
            if (status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //利用PhotoKit 获取所有的相册
                    [self getAllAlbums];
                    //创建显示相册列表
                    [self creatTableView];
                });
            }else{
                //做一个没有授权的提示

            }
        }];
    }
    //已经授权
    else if (status == PHAuthorizationStatusAuthorized){
        dispatch_async(dispatch_get_main_queue(), ^{
            //利用PhotoKit 获取所有的相册
            [self getAllAlbums];
            //创建显示相册列表
            [self creatTableView];
        });
    }
    //拒绝访问
    else if (status == PHAuthorizationStatusRestricted){
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    }
}
#pragma mark - TableView Creat
- (void)creatTableView{
    //防止push 之后 pop回来 位置变化
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.albumTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    self.albumTableView.dataSource = self;
    self.albumTableView.delegate = self;
    //去注册单元格
    [self.albumTableView registerClass:[AlbumTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AlbumTableViewCell class])];
    //
    [self.view addSubview:self.albumTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.smartFetchResultArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlbumTableViewCell *albumCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AlbumTableViewCell class]) forIndexPath:indexPath];
    [albumCell updateAlbumImage:self.smartFetchResultArray[indexPath.row] name:self.smartFetchResultTitlt[indexPath.row]];
    return albumCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MediaBrowseCollectionViewController *mediaBrowseVC = [[MediaBrowseCollectionViewController alloc]init];
    mediaBrowseVC.albumTitle = self.smartFetchResultTitlt[indexPath.row];
    mediaBrowseVC.assetFetchResult = self.smartFetchResultArray[indexPath.row];
    [self.navigationController pushViewController:mediaBrowseVC animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 利用PhotoKit 获取所有的相册
- (void)getAllAlbums{
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHCollection *collection in smartAlbums) {
        if ([collection isKindOfClass:[PHCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            
            switch (assetCollection.assetCollectionSubtype) {
                case PHAssetCollectionSubtypeSmartAlbumAllHidden:
                    break;
                case PHAssetCollectionSubtypeSmartAlbumUserLibrary:{
                    PHFetchResult *assetFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:self.options];
                    [self.smartFetchResultArray insertObject:assetFetchResult atIndex:0];
                    [self.smartFetchResultTitlt insertObject:collection.localizedTitle atIndex:0];
                }
                    break;
                default:{
                    PHFetchResult *assetFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:self.options];
                    [self.smartFetchResultTitlt addObject:collection.localizedTitle];
                    [self.smartFetchResultArray addObject:assetFetchResult];
                }
                    break;
            }
        }
    }
}
#pragma mark - Lazy Load
- (PHFetchOptions *)options {
    if (!_options) {
        _options = [[PHFetchOptions alloc] init];
        _options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    }
    return _options;
}
- (NSMutableArray *)smartFetchResultArray {
    if (!_smartFetchResultArray) {
        _smartFetchResultArray = [[NSMutableArray alloc] init];
    }
    return _smartFetchResultArray;
}
- (NSMutableArray *)smartFetchResultTitlt {
    if (!_smartFetchResultTitlt) {
        _smartFetchResultTitlt = [[NSMutableArray alloc] init];
    }
    return _smartFetchResultTitlt;
}
- (PHCachingImageManager *)imageManager {
    if (!_imageManager) {
        _imageManager = [[PHCachingImageManager alloc] init];
    }
    return _imageManager;
}
@end
