//
//  JFEditBubbleView.m
//  JFBubbleView
//
//  Created by joanfen on 2016/11/15.
//  Copyright © 2016年 joanfen. All rights reserved.
//

#import "JFEditBubbleView.h"
#import "JFDeleteBubbleItem.h"
#import "JFInputBubbleItem.h"

@interface JFEditBubbleView ()<JFBuddleViewDelegate, JFBuddleViewDataSource, JFInputBubbleItemDelegate>

@end

@implementation JFEditBubbleView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.bubbleDataSource = self;
        self.bubbleDelegate = self;
        self.dataArray = [NSMutableArray new];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)setDataArray:(NSMutableArray<NSString *> *)dataArray{
    _dataArray = dataArray;
    [self reloadData];
}
#pragma mark - Bubble View Data Source
- (NSInteger)numberOfItemsInBubbleView:(JFBubbleView *)bubbleView{
    return self.dataArray.count + 1;
}

- (JFBubbleItem *)bubbleView:(JFBubbleView *)bubbleView itemForIndex:(NSInteger)index{
    
    if (index < self.dataArray.count) {
        return [self bubbleView:bubbleView deleteItemForIndex:index];
    }
   
    return [self bubbleView:bubbleView editItemForIndex:index];
}

- (JFBubbleItem *)bubbleView:(JFBubbleView *)bubbleView deleteItemForIndex:(NSInteger)index{
    NSString *itemId = @"bubble";
    JFDeleteBubbleItem *item = (JFDeleteBubbleItem *)[bubbleView dequeueReuseItemWithIdentifier:itemId];
    if (item == nil) {
        item = [[JFDeleteBubbleItem alloc] initWithReuseIdentifier:itemId];
    }
    
    item.textLabel.text = self.dataArray[index];
    return item;
}

- (JFBubbleItem *)bubbleView:(JFBubbleView *)bubbleView editItemForIndex:(NSInteger)index{
    
    NSString *editReuseIdentifier = @"editBubbleItem";
    JFInputBubbleItem *item = [bubbleView dequeueReuseItemWithIdentifier:editReuseIdentifier];
    if (item == nil) {
        item = [[JFInputBubbleItem alloc] initWithReuseIdentifier:editReuseIdentifier];
        item.placeholder = self.placeholder;
        item.bubbleItemDelegate = self;
    }
    return item;
}

#pragma mark - Bubble View Delegate

-(void)bubbleView:(JFBubbleView *)theBubbleView didTapItem:(JFBubbleItem *)item{
    if (item.isSelected) {
        [self popMenuControllerWithTargetRect:item.frame];
    }
    else{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
}

#pragma mark - Bubble Item Delegate

-(void)editBubbleItem:(JFBubbleItem *)item widthDidChanged:(CGFloat)width{
    item.frame = [self adjustItemRect:item.frame];
    [self resetContentSize];
}

-(void)prepareDeletItem{
    
    NSArray *index = [self indexesForSelectedItems];
    if (index && index.count>0) {
        [self deleteBubble:self];
        return;
    }
    else{
        [self selectBubbleAtIndex:self.dataArray.count-1];
    }
}


#pragma mark - append
-(void)appendText:(NSString *)text{
    [self.dataArray addObject:text];
    [self reloadData];
    [self scrollToBottom];
}
#pragma  mark - delete

-(void)popMenuControllerWithTargetRect:(CGRect)frame{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [self becomeFirstResponder];
    menu.menuItems = @[[[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteBubble:)]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDismiss:) name:UIMenuControllerWillHideMenuNotification object:nil];
    [menu setTargetRect:frame inView:self];
    [menu setMenuVisible:YES animated:YES];
}

-(void)deleteBubble:(id)sender{
    NSArray *index = [self indexesForSelectedItems];
    [index enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataArray removeObjectAtIndex:[obj integerValue]];
    }];
    [self removeSelectedItem];
}
#pragma mark - menu
-(void)menuDismiss:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
    UIMenuController *menuController = notification.object;
    [menuController setMenuItems:nil];
    [self resignFirstResponder];
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

@end
