//
//  NSAttributedString+calculate.h
//  私人专科医生
//
//  Created by joanfen on 15/1/13.
//  Copyright (c) 2015年 Xingren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
@interface NSAttributedString (calculate)

-(CGFloat)heightByMaxWidth:(CGFloat)width;

-(CGFloat)widthByMaxHeight:(CGFloat)height;

-(CGFloat)heightByFont:(UIFont *)font maxWidth:(CGFloat)width;

-(CGFloat)widthByFont:(UIFont *)font maxHeight:(CGFloat)height;

@end
