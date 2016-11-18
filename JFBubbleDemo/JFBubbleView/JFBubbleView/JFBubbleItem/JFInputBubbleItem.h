//
//  JFInputBubbleItem.h
//  JFBubbleView
//
//  Created by joanfen on 2016/11/15.
//  Copyright © 2016年 joanfen. All rights reserved.
//

#import "JFBubbleItem.h"

@class JFDeleteTextField;

@protocol JFInputBubbleItemDelegate;

@interface JFInputBubbleItem : JFBubbleItem

@property (nonatomic, strong) JFDeleteTextField *inputLabelField;

@property (nonatomic, strong) UIColor *layerColor;
@property (nonatomic, strong) NSString *placeholder;

@property (nonatomic, weak) id<JFInputBubbleItemDelegate> bubbleItemDelegate;

@end

#pragma mark - Input Bubble Item Delegate

@protocol JFInputBubbleItemDelegate <NSObject>

@optional

-(void)inputBubbleItem:(JFBubbleItem *)item widthDidChanged:(CGFloat)width;
-(void)prepareDeletItem;
-(void)appendText:(NSString *)text;

@end

#pragma mark - Text Delete Delegate
#pragma mark -
@protocol JFTextDeleteDelegate <NSObject>

@optional
- (void)textFieldDidDelete;
- (void)blankTextFieldDelete;
@end


#pragma mark - Class XRDeleteTextField
#pragma mark -

@interface JFDeleteTextField : UITextField

@property (nonatomic, assign) id<JFTextDeleteDelegate> deleteDelegate;
@property (nonatomic, assign) CGFloat width;

@end
