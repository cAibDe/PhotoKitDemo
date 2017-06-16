//
//  MediaBrowseCollectionViewController.m
//  PhotoKitDemo
//
//  Created by c4ibD3 on 2017/6/15.
//  Copyright © 2017年 c4ibD3. All rights reserved.
//

#import "MediaBrowseCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import "LivePhotoViewController.h"
#import "ImageViewController.h"
#import "ShowVIdeoViewController.h"
#import "UIViewController+NavigationBar.h"
#define kItemWith ([UIScreen mainScreen].bounds.size.width-20)/3
#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self
@interface MediaBrowseCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *mediaCollectionView;

@end

@implementation MediaBrowseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavigationBarToBack];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.albumTitle;
    [self creatCollectionView];
}
#pragma mark - CollectionView Creat
- (void)creatCollectionView{
    //防止push 之后 pop回来 位置变化
    self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc]init];
    flowLayOut.minimumLineSpacing = 10;
    flowLayOut.minimumInteritemSpacing = 10;
    flowLayOut.itemSize = CGSizeMake(kItemWith, kItemWith);
    
    self.mediaCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) collectionViewLayout:flowLayOut];
    self.mediaCollectionView.dataSource = self;
    self.mediaCollectionView.delegate = self;
    //注册单元格
    [self.mediaCollectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([PhotoCollectionViewCell class])];
    //
    self.mediaCollectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mediaCollectionView];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assetFetchResult.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PhotoCollectionViewCell class]) forIndexPath:indexPath];
    [photoCell updatePhotoCellWith:self.assetFetchResult[indexPath.item]];
    return photoCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(weakSelf);
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    PHAsset *asset = self.assetFetchResult[indexPath.item];
    //判断媒体类型
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        PHVideoRequestOptions *phVideoRequestOptions = [[PHVideoRequestOptions alloc]init];
        phVideoRequestOptions.version = PHImageRequestOptionsVersionCurrent;
        phVideoRequestOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:asset options:phVideoRequestOptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            ShowVIdeoViewController *shouwVideoVC = [[ShowVIdeoViewController alloc]init];
            shouwVideoVC.asset = asset;
            shouwVideoVC.fileName =[[info objectForKey:@"PHImageFileSandboxExtensionTokenKey"] lastPathComponent];
            [weakSelf.navigationController pushViewController:shouwVideoVC animated:YES];
        }];
    }else if (asset.mediaType == PHAssetMediaTypeImage){
        //照片中细分是不是LivePhoto
        if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
            LivePhotoViewController *livePhotoVC = [[LivePhotoViewController alloc]init];
            livePhotoVC.asset = asset;
            [self.navigationController pushViewController:livePhotoVC animated:YES];
        }else{
            ImageViewController *imageViewVC = [[ImageViewController alloc]init];
            imageViewVC.asset = asset;
            [self.navigationController pushViewController:imageViewVC animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
