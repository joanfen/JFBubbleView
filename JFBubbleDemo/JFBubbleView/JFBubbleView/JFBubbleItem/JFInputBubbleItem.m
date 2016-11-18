//
//  JFInputBubbleItem.m
//  JFBubbleView
//
//  Created by joanfen on 2016/11/15.
//  Copyright © 2016年 joanfen. All rights reserved.
//

#import "JFInputBubbleItem.h"

#pragma mark -
@implementation JFDeleteTextField

-(void)deleteBackward{
    NSString *textBeforeDelete = self.text;
    [super deleteBackward];
    if (textBeforeDelete.length == 0) {
        if (_deleteDelegate && [_deleteDelegate respondsToSelector:@selector(blankTextFieldDelete)]) {
            [_deleteDelegate blankTextFieldDelete];
        }
    }
    if (_deleteDelegate && [_deleteDelegate respondsToSelector:@selector(textFieldDidDelete)]) {
        [_deleteDelegate textFieldDidDelete];
    }
}
@end

#pragma mark - Class JFInputBubbleItem
#pragma mark -

static NSInteger const KJFMaxInputLength = 30;
static NSInteger const kJFMinInputBubbleWidth = 50;
#define KJFDefalutHighlightColor [UIColor colorWithRed:33/255.0 green:152/255.0 blue:200/255.0 alpha:1]

@interface JFInputBubbleItem ()<JFTextDeleteDelegate, UITextFieldDelegate>

@end

#pragma mark -
@implementation JFInputBubbleItem

-(id)initWithReuseIdentifier:(NSString *)identifier{
    self = [super initWithReuseIdentifier:identifier];
    if (self) {
        self.inputLabelField = ({
            JFDeleteTextField *textField = [[JFDeleteTextField alloc] init];
            textField.deleteDelegate = self;
            textField.returnKeyType = UIReturnKeyDone;
            textField.delegate = self;
            textField.font = KJFDefaultLabelFont;
            [textField addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
            [self addSubview:textField];
            textField;
        });
        
        self.backgroundColor = [UIColor clearColor];
        
        self.layerColor = [UIColor clearColor];
    }
    return self;
}

-(id)init{
    return [super initWithReuseIdentifier:nil];
}

-(void)setPlaceholder:(NSString *)placeholder{
    if (!placeholder || placeholder.length == 0) {
        placeholder = @"请输入";
    }
    _placeholder = placeholder;
    self.inputLabelField.placeholder = placeholder;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.inputLabelField.frame = self.bounds;
    
}

-(void)setLayerColor:(UIColor *)layerColor{
    _layerColor = layerColor;
    self.layer.borderColor = self.layerColor.CGColor;
}

-(CGFloat)widthByHeight:(CGFloat)height{
    NSString *fieldText = self.inputLabelField.text;
    if (fieldText.length == 0) {
        fieldText = self.placeholder;
    }
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:fieldText attributes:self.inputLabelField.typingAttributes];
    CGFloat width = [string widthByFont:self.inputLabelField.font maxHeight:height];
    return MAX(kJFMinInputBubbleWidth, width);
}

#pragma mark - TextField
-(void)textDidChanged:(UITextField *)textField{
    if (textField.text.length > KJFMaxInputLength) {
        textField.text = [textField.text substringToIndex:KJFMaxInputLength];
    }
    CGFloat width = [self widthByHeight:self.frame.size.height];
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
    if (self.bubbleItemDelegate && [self.bubbleItemDelegate respondsToSelector:@selector(inputBubbleItem:widthDidChanged:)]) {
        [self.bubbleItemDelegate inputBubbleItem:self widthDidChanged:width];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *validFieldText = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *validInputText = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (validFieldText.length == 0 && validInputText.length == 0) {
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    // 去掉前后的空格
    NSString *validText = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (validText.length == 0) {
        return YES;
    }
    textField.text = @"";
    
    if (self.bubbleItemDelegate && [self.bubbleItemDelegate respondsToSelector:@selector(appendText:)]) {
        [self.bubbleItemDelegate appendText:validText];
    }
    return YES;
}

-(void)textFieldDidDelete{
    if (self.inputLabelField.text.length>0) {
        if (self.bubbleItemDelegate && [self.bubbleItemDelegate respondsToSelector:@selector(inputBubbleItem:widthDidChanged:)]) {
            [self.bubbleItemDelegate inputBubbleItem:self widthDidChanged:[self widthByHeight:self.frame.size.height]];
        }
    }
}

-(void)blankTextFieldDelete{
    if (self.bubbleItemDelegate && [self.bubbleItemDelegate respondsToSelector:@selector(prepareDeletItem)]) {
        [self.bubbleItemDelegate prepareDeletItem];
    }
}

@end

