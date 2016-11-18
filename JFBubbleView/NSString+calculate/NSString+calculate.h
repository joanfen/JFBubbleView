//
//  NSString+calculate.h
//  私人专科医生
//
//  Created by joanfen on 15/1/13.
//  Copyright (c) 2015年 Xingren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSAttributedString+calculate.h"

@interface NSString (calculate)

/*!
 *  @Author joanfen, 15-01-13 10:01:02
 *
 *  @brief  计算某个string在固定宽度下需要自适应的高度
 *
 *  @param font  显示string的字体大小
 *  @param width 固定宽度
 *
 *  @return 自适应的高度
 */
-(CGFloat)heightByFont:(UIFont *)font maxWidth:(CGFloat)width;


/*!
 *  @Author joanfen, 15-01-13 10:01:14
 *
 *  @brief  计算某个string在固定高度下需要自适应的宽度
 *
 *  @param font   显示string的字体大小
 *  @param height 固定高度
 *
 *  @return 自适应的宽度
 */
-(CGFloat)widthByFont:(UIFont *)font maxHeight:(CGFloat)height;


@end
