# PhotoKitDemo
* * *
#前言
* * *
我们公司做了一个DLNA的投屏软件，但是iOS是不能跨应用访问数据的，所以对于局域网投屏视频和图片需要把图片或者视频写入到应用的沙盒路径下。
在我之前的前辈用的是AssetsLibrary，他是在进入界面之前写入，等到完全都写完了才会去显示。之前拍照的照片大小不是很大，而且手机的存储空间也不大，对于用户来说这么处理完全是没有问题的。但是，后来有用户反馈说在本地媒体界面一直都有那个“菊花转”。后来我们发现可能是用户的本地媒体数据过于大，倒是程序假死。
我们老大说，你把这个功能优化一下，目标就是像微信那样是最好的。后来我们就选用的PhotoKit这个框架。
* * *
#研究
* * *
之前并没有具体用过这个框架，所以就现在网上研究了一下。很幸运，我找到了一个很类似的DEMO。
我们只要在相应的控制器界面导入`#import <Photos/Photos.h>`就行。我们还需要在info.plist中添加相册的访问权限。
![在info.plist添加相册授权](http://upload-images.jianshu.io/upload_images/2368708-a15664f0ac5d2174.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
之后，我们建立一个二级控制器就可以了。
* * *
#初用
* * *
#####弯路1：
当我们添加授权之后再相应的界面就会出现这么一个弹框
![相册访问授权](http://upload-images.jianshu.io/upload_images/2368708-f39bfc983fd30dff.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
当我点击好的时候 界面并没有数据，但是当我第二期进入界面的时候数据就显示出来了。
#####解决1：
我们需要对这个弹框的点击事件进行处理，这里我们直接上代码：
```objc
- (void)getAuthorized{
    //判断是否有访问权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    //还没有去做选择
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            //已经授权
            if (status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
              //已经授权，显示相册 或者图片
                });
            }else{
                //做一个没有授权的提示
            }
        }];
    }
    //已经授权
    else if (status == PHAuthorizationStatusAuthorized){
        dispatch_async(dispatch_get_main_queue(), ^{
          //已经授权，显示相册 或者图片
        });
    }
    //拒绝访问
    else if (status == PHAuthorizationStatusRestricted){
        dispatch_async(dispatch_get_main_queue(), ^{
        //做一个没有授权的提示
        });
    }
}

```
那么接了下来我们继续。
这里我们先去做了获取相册的功能：
```objc
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
```
这里的`self.smartFetchResultTitlt`是用来存储相册标题的数组；`self.smartFetchResultArray`是用来存储相册内容的；`self.options`需要设置一下，代码如下：
```objc
- (PHFetchOptions *)options {
    if (!_options) {
        _options = [[PHFetchOptions alloc] init];
        _options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    }
    return _options;
}
```
#####弯路2：
在上面获取到的相册的名称，我在控制台打出来的都是英文的
![英文相册名](http://upload-images.jianshu.io/upload_images/2368708-4ee3e94fef55016c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
但是我们想要的并不是英文的。
#####解决2：
依旧是在`info.plist`中，如下图：
![修改属性](http://upload-images.jianshu.io/upload_images/2368708-fa662662cc283a83.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

显示图片，这里用PhototKit自身的PHCachingImageManager做显示就可以了。
我是用了一个collectionView做显示。方法如下：
```objc
    [self.imageManager requestImageForAsset:asset targetSize:CGSizeMake(self.bounds.size.width, self.bounds.size.width) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        weakSelf.imageView.image = result;
    }];
```
这里显示的只是一个缩略图，并不是很清晰，如果放到满屏看就会很模糊，那么还有另一种方式去获得清晰的图片：
```objc
WeakSelf(weakSelf);
    [[PHImageManager defaultManager]requestImageDataForAsset:self.asset                                                             options:nil
                                               resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                                   
                                                   UIImage *selectedImage = [UIImage imageWithData:imageData];
                                                   weakSelf.imageView.image = selectedImage;
                                                   weakSelf.title = [[info objectForKey:@"PHImageFileURLKey"] lastPathComponent];
                                               }];
```
这样不仅获得了图片，还可以获得这个照片的名字。
***
#上面说的都是图片，接下来说说视频。
我么可以用下面这个方法去获取视频：
```objc
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
```
#####弯路3：
就是这个方法的等待时间比较长，用户体验不太好。
***
#Live Photo
这个功能出现了有一段时间，我知道的软件只有微博支持了Live Photo的功能（小人可能见识短浅，有盆友知到别的软件也支持的话可以 私聊告诉我)，我看PhotoKit支持Live Photo，那么我就小小的研究了一下。
但是在这个过程中我也是遇到了一些问题的，
我们看源码中给本地媒体分了很多种类型：
```objc
typedef NS_ENUM(NSInteger, PHAssetMediaType) {
    PHAssetMediaTypeUnknown = 0,
    PHAssetMediaTypeImage   = 1,
    PHAssetMediaTypeVideo   = 2,
    PHAssetMediaTypeAudio   = 3,
} PHOTOS_ENUM_AVAILABLE_IOS_TVOS(8_0, 10_0);

typedef NS_OPTIONS(NSUInteger, PHAssetMediaSubtype) {
    PHAssetMediaSubtypeNone               = 0,
    
    // Photo subtypes
    PHAssetMediaSubtypePhotoPanorama      = (1UL << 0),
    PHAssetMediaSubtypePhotoHDR           = (1UL << 1),
    PHAssetMediaSubtypePhotoScreenshot PHOTOS_AVAILABLE_IOS_TVOS(9_0, 10_0) = (1UL << 2),
    PHAssetMediaSubtypePhotoLive PHOTOS_AVAILABLE_IOS_TVOS(9_1, 10_0) = (1UL << 3),
    PHAssetMediaSubtypePhotoDepthEffect PHOTOS_AVAILABLE_IOS_TVOS(10_2, 10_1) = (1UL << 4),

    // Video subtypes
    PHAssetMediaSubtypeVideoStreamed      = (1UL << 16),
    PHAssetMediaSubtypeVideoHighFrameRate = (1UL << 17),
    PHAssetMediaSubtypeVideoTimelapse     = (1UL << 18),
} PHOTOS_AVAILABLE_IOS_TVOS(8_0, 10_0);
```
#####弯路4：
首先LivePhoto应该是属于`PHAssetMediaTypeImage `的，然后是属于`PHAssetMediaSubtypePhotoLive `的。
正常的理解就是这样对不对，但是在我的LivePhoto的相册中有的竟然会识别不出来。我去了本地媒体相册看了一下识别不出来的那些照片的类型，左上角竟然有两个标识，一个是`Live`，另一个是`HDR`。
后来我就是把所有的类型都打印了一下，我发现这样的相片不属于任何一个类型。
#####解决4：
我在控制器打了一下看了一下子媒体类型的值，LivePhoto的类型值是8，既是LivePhoto又是HDR的类型值是10。我之前的媒体类型判断是：
```objc
asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive
```
而改成：
```objc
asset.mediaSubtypes >= PHAssetMediaSubtypePhotoLive
```
就可以了
***
下面来说我们怎么显示Live Photo：
```objc
PHLivePhotoRequestOptions *options = [[PHLivePhotoRequestOptions alloc]init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = YES;
    options.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
        NSLog(@"progress = %f",progress);
    };
    [[PHImageManager defaultManager]requestLivePhotoForAsset:self.asset targetSize:self.livePhotoView.bounds.size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
        self.livePhotoView.livePhoto = livePhoto;
        NSLog(@"info = %@",info);
    }];
```
这里的self.livephotoview 是`PHLivePhotoView`这个类 ，就和普通的View初始化一样。
这样你现实出来的LivePhoto就可以了，这时你只要按住照片，照片就会动起来，这里你也可以设置你的播放设置，我是这样设置的：
```objc
 [self.livePhotoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleHint];
```
这样设置的效果就是进来界面，livePhoto就会自动播放一次。

#####弯路5：
我先通过上面的方法打印info里面的信息，但是控制台给我这样的信息：
```objc
error reading settings archive file: <ISRootSettings: /var/mobile/Containers/Data/Application/BCAA7EBA-543E-4B9E-B945-D8C4C509C491/Documents/com.C4ibD3.PhotoKitDemo.settings/ISRootSettings_10.plist>
2017-06-16 09:00:16.433082+0800 PhotoKitDemo[1444:307243] info = {
}
```
不知道是为什么？


希望各位要是知道如何解决弯路3，5的 请告知小弟
