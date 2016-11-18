//
//  JFEditBubbleView.m
//  JFBubbleView
//
//  Created by joanfen on 2016/11/15.
//  Copyright © 2016年 joanfen. All rights reserved.
//

#import "JFEditBubbleView.h"
#import "JFInputBubbleItem.h"

@interface JFDeleteBubbleItem : JFBubbleItem
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

#pragma mark - 
@interface JFEditBubbleView ()<JFBuddleViewDelegate, JFBuddleViewDataSource, JFInputBubbleItemDelegate>
@property (nonatomic, assign) NSInteger selectedIndex;
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

-(BOOL)resignFirstResponder{
    JFInputBubbleItem *item = [self itemAtIndex:self.dataArray.count];
    [item.inputLabelField resignFirstResponder];
    return YES;
}

-(void)setDataArray:(NSMutableArray<NSString *> *)dataArray{
    _dataArray = dataArray;
    [self reloadData];
}

// 强制单选
-(void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection{
    [super setAllowsMultipleSelection:NO];
}

-(void)setEditBubbleActive{
    JFInputBubbleItem *item = [self itemAtIndex:self.dataArray.count];
    [item.inputLabelField becomeFirstResponder];
}

-(void)reloadData{
    [super reloadData];
    [self deselectBubbleAtIndex:self.selectedIndex];
}

-(NSInteger)selectedIndex{
    return [self.indexesForSelectedItems.lastObject integerValue];
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

- (JFInputBubbleItem *)bubbleView:(JFBubbleView *)bubbleView editItemForIndex:(NSInteger)index{
    
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

-(void)bubbleViewRefreshCompleted:(JFBubbleView *)bubbleView{
    if (self.editBubbleViewDelegate && [self.editBubbleViewDelegate respondsToSelector:@selector(bubbleViewRefreshCompleted:)]) {
        [self.editBubbleViewDelegate bubbleViewRefreshCompleted:bubbleView];
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
    }
    else{
        [self selectBubbleAtIndex:self.dataArray.count-1];
        [self setEditBubbleActive];
    }
}

#pragma mark - append
-(void)appendText:(NSString *)text{

    if ([self.dataArray containsObject:text]) {
        JFInputBubbleItem *item = [self itemAtIndex:self.dataArray.count];
        item.inputLabelField.text = @"";
        return;
    }
    [self.dataArray addObject:text];
   
    if (self.editBubbleViewDelegate && [self.editBubbleViewDelegate respondsToSelector:@selector(addItemWithTextFinished:)]) {
        [self.editBubbleViewDelegate addItemWithTextFinished:text];
    }
    [self reloadData];
    [self scrollToBottom];
    [self setEditBubbleActive];
}
#pragma  mark - delete

-(void)deleteBubble:(id)sender{
    [[UIMenuController sharedMenuController] setMenuVisible:NO];
    NSInteger index = self.selectedIndex;
    JFBubbleItem *item = [self itemAtIndex:index];
    [self.dataArray removeObjectAtIndex:index];
    
    [self removeItem:item animated:YES];
    if (self.editBubbleViewDelegate && [self.editBubbleViewDelegate respondsToSelector:@selector(deleteItemWithTextFinished:)]) {
        [self.editBubbleViewDelegate deleteItemWithTextFinished:item.textLabel.text];
    }
    [self setEditBubbleActive];

}

-(void)popMenuControllerWithTargetRect:(CGRect)frame{

    UIMenuController *menu = [UIMenuController sharedMenuController];
    [self becomeFirstResponder];

    menu.menuItems = @[[[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteBubble:)]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDismiss:) name:UIMenuControllerWillHideMenuNotification object:nil];
    [menu setTargetRect:frame inView:self];
    [menu setMenuVisible:YES animated:YES];
    
    [self setEditBubbleActive];

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
