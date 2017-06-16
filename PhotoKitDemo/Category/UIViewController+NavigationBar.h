//
//  UIViewController+NavigationBar.h
//  50+sh
//
//  Created by c4ibD3 on 15/12/3.
//  Copyright © 2015年 c4ibD3. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NavigationBarPosition){
    NavigationBarPositionLeft,
    NavigationBarPositionRight
};

/**
 *  nativigation按钮的类型
 */
typedef NS_ENUM(NSInteger, NativigationButtonType) {
    /**
     *  更多按钮
     */
    NativigationButtonTypeMore,
    /**
     *  分享按钮
     */
    NativigationButtonTypeShare,
   
};


@interface UIViewController (NavigationBar)

/**
 *  设置左侧Navigationbar为“返回”（使用backBarButtonItem）
 */
- (void)setLeftNavigationBarToBack;

/**
 *  设置左侧Navigationbar为“返回”(使用leftbarbutton)
 *
 *  @param block 点击时执行的block代码
 */
- (void)setLeftNavigationBarToBackWithBlock:(void (^)())block;

/**
 *  为左侧后退Navigationbar增加确认提示框
 */
- (void)setLeftNavigationBarToBackWithConfirmDialog;

/**
 *  设置NavigationBar（文字）
 *
 *  @param position 位置
 *  @param text     文字
 *  @param block    点击后执行的代码
 */
- (void)setNavigationBar:(NavigationBarPosition)position withText:(NSString *)text touched:(void (^)())block;

/**
 *  设置NavigationBar（图片）
 *
 *  @param position  位置
 *  @param imageName 图片名称
 *  @param block     点击后执行的代码
 */

- (void)setNavigationBar:(NavigationBarPosition)position withImageName:(NSString *)imageName touched:(void (^)())block;
/**
 *  设置NavigationBar（图片）
 *
 *  @param position  位置
 *  @param imageName 图片名称
 *  @param block     点击后执行的代码
 */
- (void)setNavigationBar:(NavigationBarPosition)position withImageName:(NSString *)imageName spacing:(NSInteger)spacing touched:(void (^)())block;

/**
 *  设置NavigationBar（文字）
 *
 *  @param position 位置
 *  @param text     文字
 *  @param color    文字颜色
 *  @param block    点击后执行的代码
 */
- (void)setNavigationBar:(NavigationBarPosition)position withText:(NSString *)text withColor:(UIColor *)color touched:(void (^)())block;

/**
 *  设置NavigationBar（文字）
 *
 *  @param position 位置
 *  @param text     文字
 *  @param color    文字颜色
 *  @param font     字体
 *  @param block    点击后执行的代码
 */
- (void)setNavigationBar:(NavigationBarPosition)position withText:(NSString *)text withColor:(UIColor *)color withFont:(UIFont *)font touched:(void (^)())block;

/**
 *  设置NavigationBar隐藏或显示
 *
 *  @param position 位置
 *  @param hidden   YES：隐藏 NO：显示
 */
- (void)hiddenNavigationBar:(NavigationBarPosition)position hidden:(BOOL)hidden;

/**
 *  跳转到指定的ViewController
 *
 *  @param viewControllerClass
 */
- (void)popToViewController:(Class)viewControllerClass;

/**
 *  NavigationController里上一个ViewController
 *
 */
- (UIViewController *)previosViewController;

/**
 *  移除当前NavigationController里ViewController的上一个ViewController
 */
- (void)removePreviosViewControllerInNavigationControllers;

/**
 *  添加多个按钮时
 *
 *  @param position 位置
 *  @param array    buttonImageNameAndButtonTypeArray
 *  @param target   目标
 *  @param selector 响应方法
 */

- (void)setNavigationBar:(NavigationBarPosition)position withImageNameAndButtonTypeArray:(NSArray *)array target:(id)target selectors:(SEL)selector;

/**
 *  移除navigationbutton
 *
 *  @param position 位置
 */
- (void)removeNavigationBarBar:(NavigationBarPosition)position;

@end
