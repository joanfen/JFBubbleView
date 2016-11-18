//
//  NSAttributedString+calculate.m
//  私人专科医生
//
//  Created by joanfen on 15/1/13.
//  Copyright (c) 2015年 Xingren. All rights reserved.
//

#import "NSAttributedString+calculate.h"


@implementation NSAttributedString (calculate)

-(CGFloat)heightByMaxWidth:(CGFloat)width{
    CGSize autoSize = CGSizeMake(width, 10000);
    CGSize final = [self sizeByAutoSize:autoSize];
    return final.height;
}

-(CGFloat)widthByMaxHeight:(CGFloat)height{
    CGSize autoSize = CGSizeMake(1000, height);
    CGSize final = [self sizeByAutoSize:autoSize];
    return final.width;
}

-(CGFloat)heightByFont:(UIFont *)font maxWidth:(CGFloat)width{
    CGSize autoSize = CGSizeMake(width, 10000);
    NSDictionary *fontAttribute = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:self.string attributes:fontAttribute];
    CGSize final =  [attributeStr sizeByAutoSize:autoSize];
    return final.height;
    
    
}


-(CGFloat)widthByFont:(UIFont *)font maxHeight:(CGFloat)height{
    CGSize autoSize = CGSizeMake(1000, height);
    NSDictionary *fontAttribute = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:self.string attributes:fontAttribute];
    CGSize final =  [attributeStr sizeByAutoSize:autoSize];
    return final.width;
}


-(CGSize)sizeByAutoSize:(CGSize)autoSize{
    
    CGRect rect = [self boundingRectWithSize:autoSize
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     context:nil];
    
    
    return rect.size;
}
@end
