//
//  UIButton+Block.h
//  50+sh
//
//  Created by c4ibD3 on 15/12/3.
//  Copyright © 2015年 c4ibD3. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionBlock)();

@interface UIButton (Block)


- (void) handleControlEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)action;


@end
