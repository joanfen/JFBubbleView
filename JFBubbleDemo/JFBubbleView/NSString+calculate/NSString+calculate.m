//
//  NSString+calculate.m
//  私人专科医生
//
//  Created by joanfen on 15/1/13.
//  Copyright (c) 2015年 Xingren. All rights reserved.
//

#import "NSString+calculate.h"
#import "NSAttributedString+calculate.h"

@implementation NSString (calculate)

-(CGFloat)widthByFont:(UIFont *)font maxHeight:(CGFloat)height{
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:self];
    CGFloat width = [str widthByFont:font maxHeight:height];
    return width;
}

-(CGFloat)heightByFont:(UIFont *)font maxWidth:(CGFloat)width{
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:self];
    CGFloat height = [str heightByFont:font maxWidth:width];
    return height;
}

@end
