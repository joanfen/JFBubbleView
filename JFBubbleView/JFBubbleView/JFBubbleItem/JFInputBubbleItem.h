//
//  JFInputBubbleItem.h
//  JFBubbleView
//
//  Created by joanfen on 2016/11/15.
//  Copyright © 2016年 joanfen. All rights reserved.
//

#import "JFBubbleItem.h"

@protocol JFInputBubbleItemDelegate;

@interface JFInputBubbleItem : JFBubbleItem

@property (nonatomic, strong) UIColor *layerColor;
@property (nonatomic, strong) NSString *placeholder;

@property (nonatomic, weak) id<JFInputBubbleItemDelegate> bubbleItemDelegate;

@end

#pragma mark - Edit Bubble Item Delegate

@protocol JFInputBubbleItemDelegate <NSObject>

@optional

-(void)inputBubbleItem:(JFBubbleItem *)item widthDidChanged:(CGFloat)width;
-(void)prepareDeletItem;
-(void)appendText:(NSString *)text;

@end
