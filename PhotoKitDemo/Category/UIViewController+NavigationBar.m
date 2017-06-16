//
//  UIViewController+NavigationBar.m
//  50+sh
//
//  Created by c4ibD3 on 15/12/3.
//  Copyright © 2015年 c4ibD3. All rights reserved.
//

#import "UIViewController+NavigationBar.h"
#import "UIButton+Block.h"
#define kNavigationBarDefaultTitleColor [UIColor whiteColor]
#define kNavigationBarDefaultTitleFont  [UIFont systemFontOfSize:16.0f]
#define kNavigationBarDefaultHeight 44.0f
#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self

@implementation UIViewController (NavigationBar)

- (void)setLeftNavigationBarToBack {
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:nil action:nil];
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backButtonItem;

}

/**
 *  设置左侧Navigationbar为“返回”(使用leftbarbutton)
 *
 *  @param block 点击时执行的block代码
 */
- (void)setLeftNavigationBarToBackWithBlock:(void (^)())block {
    
    [self setNavigationBar:NavigationBarPositionLeft withImageName:@"nav_icon_return" touched:^{
        if (block) {
            block();
        }
    }];
    
}

/**
 *  为左侧后退Navigationbar增加确认提示框
 */
- (void)setLeftNavigationBarToBackWithConfirmDialog {

    WeakSelf(weakSelf);
    [self setNavigationBar:NavigationBarPositionLeft withImageName:@"nav_icon_return" touched:^{
        [weakSelf.view endEditing:YES];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您确认要放弃编辑吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }]];
        
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)setNavigationBar:(NavigationBarPosition)position withText:(NSString *)text touched:(void (^)())block {
    [self setNavigationBar:position withText:text withColor:kNavigationBarDefaultTitleColor touched:block];
}

- (void)setNavigationBar:(NavigationBarPosition)position withText:(NSString *)text withColor:(UIColor *)color touched:(void (^)())block {
    [self setNavigationBar:position withText:text withColor:color withFont:kNavigationBarDefaultTitleFont touched:block];
}

- (void)setNavigationBar:(NavigationBarPosition)position withText:(NSString *)text withColor:(UIColor *)color withFont:(UIFont *)font touched:(void (^)())block {
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn.titleLabel setFont:font];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitle:text forState:UIControlStateNormal];
    
    CGSize size = CGSizeMake(MAXFLOAT, kNavigationBarDefaultHeight);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:btn.titleLabel.font,NSFontAttributeName,nil];
    CGSize  actualsize =[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    btn.frame = CGRectMake(0.0f, 0.0f, actualsize.width+16, 30);
    
    if (block) {
        [btn handleControlEvent:UIControlEventTouchUpInside withBlock:block];
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width=-15;
    
    if (NavigationBarPositionRight == position) {
        self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:negativeSpacer,item, nil];
    }
    else if(NavigationBarPositionLeft == position){
        self.navigationItem.leftBarButtonItems=[NSArray arrayWithObjects:negativeSpacer,item, nil];
    }
}

/**
 *  设置NavigationBar（图片）
 *
 *  @param position  位置
 *  @param imageName 图片名称
 *  @param block     点击后执行的代码
 */
- (void)setNavigationBar:(NavigationBarPosition)position withImageName:(NSString *)imageName touched:(void (^)())block {
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *img = [UIImage imageNamed:imageName];
    [btn setImage:img forState:UIControlStateNormal];
    
    CGFloat width = MAX(img.size.width, 22);
    btn.frame = CGRectMake(0.0f, 0.0f, width, kNavigationBarDefaultHeight);
    
    if (block) {
        [btn handleControlEvent:UIControlEventTouchUpInside withBlock:block];
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -8;
    
    if (NavigationBarPositionRight == position) {
        self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:negativeSpacer,item, nil];
    }
    else if(NavigationBarPositionLeft == position){
        self.navigationItem.leftBarButtonItems=[NSArray arrayWithObjects:negativeSpacer,item, nil];
    }
}
/**
 *  设置NavigationBar（图片）
 *
 *  @param position  位置
 *  @param imageName 图片名称
 *  @param block     点击后执行的代码
 */
- (void)setNavigationBar:(NavigationBarPosition)position withImageName:(NSString *)imageName spacing:(NSInteger)spacing touched:(void (^)())block {
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0.0f, 0.0f, 44.0f, kNavigationBarDefaultHeight);
    
    if (block) {
        [btn handleControlEvent:UIControlEventTouchUpInside withBlock:block];
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    negativeSpacer.width=-7;
    negativeSpacer.width = -(spacing);
    
    if (NavigationBarPositionRight == position) {
        self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:negativeSpacer,item, nil];
    }
    else if(NavigationBarPositionLeft == position){
        self.navigationItem.leftBarButtonItems=[NSArray arrayWithObjects:negativeSpacer,item, nil];
    }
}

/**
 *  设置NavigationBar隐藏或显示
 *
 *  @param position 位置
 *  @param hidden   YES：隐藏 NO：显示
 */
- (void)hiddenNavigationBar:(NavigationBarPosition)position hidden:(BOOL)hidden {
    NSArray *buttonArray = nil;
    
    if (NavigationBarPositionLeft == position) {
        buttonArray = self.navigationItem.leftBarButtonItems;
        self.navigationItem.hidesBackButton = hidden;
    }else if(NavigationBarPositionRight == position){
        buttonArray = self.navigationItem.rightBarButtonItems;
    }
    
    if (buttonArray != nil && buttonArray.count > 0) {
        for (UIBarButtonItem *btn in buttonArray) {
            btn.customView.hidden = hidden;
        }
    }
}

- (void)popToViewController:(Class)viewControllerClass {
    NSArray *arr = self.navigationController.viewControllers;
    for (int i=0;i<arr.count;i++) {
        UIViewController *v = [self.navigationController.viewControllers objectAtIndex:i];
        if([v isKindOfClass:viewControllerClass])
        {
            [self.navigationController popToViewController:v animated:YES];
            break;
        }
    }
}
/**
 *  移除navigationbutton
 *
 *  @param position 位置
 */
- (void)removeNavigationBarBar:(NavigationBarPosition)position {
    NSArray *buttonArray = nil;
    if (NavigationBarPositionLeft == position) {
        
        self.navigationItem.leftBarButtonItems = buttonArray;
        
    }else if(NavigationBarPositionRight == position){
        
        self.navigationItem.rightBarButtonItems = buttonArray;
        
    }
}


/**
 *  NavigationController里上一个ViewController
 *
 */
- (UIViewController *)previosViewController {
    
    NSUInteger index = [self.navigationController.viewControllers indexOfObject:self];
    if (index >= 1) {
    
        return [self.navigationController.viewControllers objectAtIndex:(index-1)];
    }

    return nil;
}

/**
 *  移除当前NavigationController里ViewController的上一个ViewController
 */
- (void)removePreviosViewControllerInNavigationControllers {

    NSUInteger index = [self.navigationController.viewControllers indexOfObject:self];
    if (index > 1) {
        
        NSMutableArray *navigationArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        if (navigationArray.count >1) {
            [navigationArray removeObjectAtIndex:index-1];
        }
        self.navigationController.viewControllers = navigationArray;
    }
}

/**
 *  添加多个按钮时
 *
 *  @param position 位置
 *  @param array    buttonImageNameAndButtonTypeArray
 *  @param target   目标
 *  @param selector 响应方法
 */
- (void) setNavigationBar:(NavigationBarPosition)position withImageNameAndButtonTypeArray:(NSArray *)array target:(id)target selectors:(SEL)selector{
    
//    NSMutableArray * items = [[NSMutableArray alloc]init];
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    negativeSpacer.width = -19;
//    [items addObject:negativeSpacer];
//    for (int i = 0; i <array.count; i++) {
//        KeyValueModel * model = [array objectAtIndex:i];
//        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setImage:[UIImage imageNamed:model.valve] forState:UIControlStateNormal];
//        btn.frame = CGRectMake(0.0f, 0.0f, 44.0f, kNavigationBarDefaultHeight);
//        btn.tag = model.key;
//        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
//        [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
//        [items addObject:item];
////        if (btn.tag == NativigationButtonTypeShare) {
////            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -30)];
////        }
//        if (i > 0) {
//            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -30)];
//        }
//    }
//    if (NavigationBarPositionRight == position) {
//        self.navigationItem.rightBarButtonItems= items;
//    }
//    else if(NavigationBarPositionLeft == position){
//        self.navigationItem.leftBarButtonItems= items;
//    }
}
@end
