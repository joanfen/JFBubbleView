//
//  JFDeleteBubbleItem.m
//  JFBubbleView
//
//  Created by joanfen on 2016/11/15.
//  Copyright © 2016年 joanfen. All rights reserved.
//

#import "JFDeleteBubbleItem.h"

@interface JFDeleteBubbleItem ()
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *blankColor;
@end

@implementation JFDeleteBubbleItem

-(id)initWithReuseIdentifier:(NSString *)identifier{
    self = [super initWithReuseIdentifier:identifier];
    if (self) {
        self.fillColor = [UIColor colorWithRed:33/255.0 green:152/255.0 blue:200/255.0 alpha:1];
        self.blankColor = [UIColor whiteColor];
        self.layer.borderColor = self.fillColor.CGColor;
        self.textLabel.textColor = self.fillColor;
        self.backgroundColor = self.blankColor;
    }
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    if (selected) {
        self.layer.borderColor = self.blankColor.CGColor;
        self.textLabel.textColor = self.blankColor;
        self.backgroundColor = self.fillColor;
    }
    else{
        self.layer.borderColor = self.fillColor.CGColor;
        self.textLabel.textColor = self.fillColor;
        self.backgroundColor = self.blankColor;
    }
}

@end
