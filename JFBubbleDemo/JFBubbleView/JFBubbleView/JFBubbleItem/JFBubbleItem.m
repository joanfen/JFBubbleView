//
//  JFBubbleItem.m
//  JFBubbleView
//
//  Created by joanfen on 15/6/15.
//  Copyright (c) 2015年 joanfen. All rights reserved.
//

#import "JFBubbleItem.h"
#define SingleColor(C,A)  [UIColor colorWithRed:C/255.0 green:C/255.0 blue:C/255.0 alpha:A]
#define KJFDefault_Unselected_Color SingleColor(153, 1)
#define KJFDefault_Bg_Color [UIColor whiteColor]


@interface JFBubbleItem ()

@end

@implementation JFBubbleItem
-(id)init{
    return [self initWithReuseIdentifier:nil];
}
-(id)initWithFrame:(CGRect)frame{
    return [self init];
}

-(instancetype)initWithReuseIdentifier:(NSString *)identifier{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _identifier = identifier;
        self.textPadding = 10;
        self.textLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
            label.font = KJFDefaultLabelFont;
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            label;
        });
        
        self.backgroundColor = [UIColor clearColor];
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = SINGLE_LINE_WIDTH;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(self.textPadding, 0, self.frame.size.width - self.textPadding*2, self.frame.size.height);
}

-(BOOL)becomeFirstResponder{
    return YES;
}
-(void)prepareItemForReuse{
    self.textLabel.text = nil;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    _isSelected = selected;
}

-(CGFloat)widthByHeight:(CGFloat)height{
    return [self.textLabel.text widthByFont:self.textLabel.font maxHeight:height] + _textPadding*2;
}

@end


