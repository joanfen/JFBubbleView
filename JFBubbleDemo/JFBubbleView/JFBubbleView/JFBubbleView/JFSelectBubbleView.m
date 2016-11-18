//
//  JFSelectBubbleView.m
//  JFBubbleDemo
//
//  Created by joanfen on 2016/11/16.
//  Copyright © 2016年 joanfen. All rights reserved.
//

#import "JFSelectBubbleView.h"
#import "JFBubbleItem.h"

#pragma mark - Class JFSelectBubbleItem
#pragma mark -

@interface JFSelectBubbleItem : JFBubbleItem

@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) UIColor *hightlightTextColor;
@property (nonatomic, strong) UIColor *normalBgColor;
@property (nonatomic, strong) UIColor *highlightBgColor;

@end

#pragma mark -
@implementation JFSelectBubbleItem

-(instancetype)initWithReuseIdentifier:(NSString *)identifier{
    self = [super initWithReuseIdentifier:identifier];
    if (self) {
        CGFloat normalRGB = 51/255.0;
        self.normalTextColor = [UIColor colorWithRed:normalRGB green:normalRGB blue:normalRGB alpha:1];
        self.hightlightTextColor = [UIColor colorWithRed:33/255.0 green:152/255.0 blue:200/255.0 alpha:1];
        self.normalBgColor = [UIColor clearColor];
        self.highlightBgColor = [UIColor whiteColor];
        self.textLabel.textColor = self.normalTextColor;
        self.layer.borderColor = self.normalTextColor.CGColor;
        self.backgroundColor = self.normalBgColor;
    }
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.textLabel.textColor = self.hightlightTextColor;
        self.layer.borderColor = self.hightlightTextColor.CGColor;
        self.backgroundColor = self.highlightBgColor;
    }
    else{
        self.textLabel.textColor = self.normalTextColor;
        self.layer.borderColor = self.normalTextColor.CGColor;
        self.backgroundColor = self.normalBgColor;
    }
}

@end


#pragma mark - Class JFSelectBubbleView
#pragma mark -

@interface JFSelectBubbleView ()<JFBuddleViewDelegate, JFBuddleViewDataSource>

@end

#pragma mark -

@implementation JFSelectBubbleView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.bubbleDataSource = self;
        self.dataArray = [NSMutableArray new];
        self.allowsMultipleSelection = YES;
    }
    return self;
}

-(void)setDataArray:(NSMutableArray<NSString *> *)dataArray{
    _dataArray = dataArray;
    [self reloadData];
}

#pragma mark - Bubble View Data Source
-(NSInteger)numberOfItemsInBubbleView:(JFBubbleView *)bubbleView{
    return self.dataArray.count;
}

-(JFBubbleItem *)bubbleView:(JFBubbleView *)bubbleView itemForIndex:(NSInteger)index{
    NSString *editReuseIdentifier = @"editBubbleItem";
    JFSelectBubbleItem *item = [bubbleView dequeueReuseItemWithIdentifier:editReuseIdentifier];
    if (item == nil) {
        item = [[JFSelectBubbleItem alloc] initWithReuseIdentifier:editReuseIdentifier];
    }
    item.textLabel.text = [self.dataArray objectAtIndex:index];
    return item;
}


@end
