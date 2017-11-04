//
//  INKThreeAnimationView.h
//  INKSDK
//
//  Created by CreditPayHome on 2017/4/12.
//  Copyright © 2017年 CreditPayHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface INKThreeAnimationView : UIView
/**
 * param imageArr : 需要添加的图片数组
 * param backgroundColor : 视图的背景颜色
 * param lineColor : 边线的颜色
 * param radius : 圈的半径（需要传三个参数，形式为 const CGFloat radius[] = {75.0, 32.5, 22.5};）
 * param count : 半径的个数，must be three
 */
- (instancetype _Nullable )initWithFrame:(CGRect)frame imageArr:(NSArray <UIImage *>*_Nullable)imageArr backgroundColor:(UIColor *_Nullable)backgroundColor lineColor:(UIColor *_Nullable)lineColor radius:(const CGFloat* _Nullable )radius count:(size_t)count;

-(void)playAnimation;
@end


/**
1.添加图片如果是中心图片marr请放在最后一位👇
2.const CGFloat radius[] = {75.0, 32.5, 22.5}; 第一个是大圈的半径，第二个是中心图片的半径，第三个是三个图片的半径

 
NSMutableArray *marr = [NSMutableArray array];
for (int i = 0; i < 3; i++) {
    [marr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d", i]]];
}
[marr addObject:[UIImage imageNamed:@""]];

const CGFloat radius[] = {75.0, 32.5, 22.5};
INKThreeAnimationView *V = [[INKThreeAnimationView alloc] initWithFrame:CGRectMake(100, 100, 150, 150) imageArr:marr backgroundColor:[UIColor yellowColor] lineColor:[UIColor blackColor] radius:radius count:3];
V.backgroundColor= [UIColor blackColor];
[self.view addSubview:V];
*/
