//
//  JFBubbleItem.h
//  JFBubbleView
//
//  Created by joanfen on 15/6/15.
//  Copyright (c) 2015年 joanfen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+calculate.h"

#define KJFDefaultLabelFont         [UIFont systemFontOfSize:15 weight:UIFontWeightLight]
#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)

@interface JFBubbleItem : UIView

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, assign) CGFloat textPadding; // textLabel 距气泡边框的左右距离

@property (nonatomic, readonly) BOOL isSelected;

@property (nonatomic, assign) NSInteger index;

/// 重载此方法来改变选中状态的样式
-(void)setSelected:(BOOL)selected animated:(BOOL)animated;

-(void)prepareItemForReuse;

-(instancetype)initWithReuseIdentifier:(NSString *)identifier;

-(CGFloat)widthByHeight:(CGFloat)height;
@end
