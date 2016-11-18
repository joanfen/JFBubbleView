//
//  JFBubbleView.m
//  JFBubbleView
//
//  Created by joanfen on 15/6/11.
//  Copyright (c) 2015年 joanfen. All rights reserved.
//

#import "JFBubbleView.h"
#import "JFBubbleItem.h"
#import "NSString+calculate.h"

static CGFloat const KJFBubbleAnmationDuration = 0.4;

@interface JFBubbleView (){
    @public
    NSMutableArray *reuseQueue;
    NSMutableArray *itemsArray;
    id<JFBuddleViewDataSource> __weak bubbleDataSource;
    id<JFBuddleViewDelegate> __weak bubbleDelegate;

    UIView *contentView;
    CGFloat itemHeight;
    CGFloat itemSpace;
    CGFloat lineSpace;
    CGFloat itemPadding;
    UIEdgeInsets edgeInsets;
    
    NSInteger lineNumber;
    NSMutableArray<JFBubbleItem *> *selectedItemsArray;
}
@property (nonatomic, strong) NSMutableArray<JFBubbleItem *> *itemsArray;
@end

@implementation JFBubbleView

@synthesize itemHeight,itemSpace, lineSpace, itemPadding, edgeInsets;
@synthesize bubbleDataSource, bubbleDelegate, itemsArray;


-(void)defaultSizes{
    itemHeight = 33.0f;
    itemSpace = 10;
    lineSpace = 10;
    itemPadding = 15;
    edgeInsets = UIEdgeInsetsMake(itemPadding, itemPadding, itemPadding, itemPadding);
}

-(id)init{
    return [self initWithFrame:CGRectZero];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultSizes];
        self.backgroundColor = [UIColor clearColor];
        reuseQueue = [NSMutableArray new];
        itemsArray = [NSMutableArray new];
        selectedItemsArray = [NSMutableArray new];
        self.allowsMultipleSelection = NO;
    }
    return self;
}


-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(id)dequeueReuseItemWithIdentifier:(NSString *)identifier{
    id reuseItem = nil;
    for (JFBubbleItem *item in reuseQueue) {
        if ([item.identifier isEqualToString:identifier]) {
            reuseItem = item;
            break;
        }
    }

    if (reuseItem != nil) {
        [reuseQueue removeObject:reuseItem];
    }
    
    [reuseItem prepareItemForReuse];
    return reuseItem;
}

-(NSArray *)indexesForSelectedItems{
    return [selectedItemsArray valueForKey:@"index"];
}
-(void)setEdgeInsets:(UIEdgeInsets)theEdgeInsets{
    edgeInsets = theEdgeInsets;
    [self reloadData];
}

-(void)setBubbleHeaderView:(UIView *)bubbleHeaderView{
    _bubbleHeaderView = bubbleHeaderView;
    [self addSubview:_bubbleHeaderView];
    _bubbleHeaderView.frame = CGRectMake(0, 0, self.frame.size.width, bubbleHeaderView.frame.size.height);
}

#pragma mark - add

-(void)insertBubbleItem:(JFBubbleItem *)item atIndex:(NSInteger)index{
    [itemsArray addObject:item];

    for (JFBubbleItem *bubble in itemsArray) {
        bubble.index = index;
        index++;
    }
    [self renderBubblesAnimated:YES];
}

-(void)addBubbleItem:(JFBubbleItem *)item{
    [self insertBubbleItem:item atIndex:itemsArray.count - 1];
}

#pragma mark - remove
-(void)removeSelectedItem{
    NSArray *selectItems = selectedItemsArray;
    [selectItems enumerateObjectsUsingBlock:^(JFBubbleItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeItem:obj animated:YES];
    }];
}
-(void)removeItem:(JFBubbleItem *)item animated:(BOOL)animated
{
    [item removeFromSuperview];
    [itemsArray removeObject:item];
    
    for(NSInteger index = item.index; index<itemsArray.count; index++){
        JFBubbleItem *bubble = itemsArray[index];
        bubble.index = index;
        index++;
    }
    [self renderBubblesAnimated:YES];
}

#pragma mark - reload

-(void)reloadData{
    if (!contentView) {
        contentView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:contentView];
    }
    NSInteger bubbleCount = 0;
    if (bubbleDataSource && [bubbleDataSource respondsToSelector:@selector(numberOfItemsInBubbleView:)]) {
        bubbleCount = [bubbleDataSource numberOfItemsInBubbleView:self];
    }
    
    for (JFBubbleItem *oldItem in itemsArray) {
        [reuseQueue addObject:oldItem];
        [oldItem removeFromSuperview];
    }
    [itemsArray removeAllObjects];
    
    for (NSInteger index = 0; index < bubbleCount; index++) {
        if (bubbleDataSource && [bubbleDataSource respondsToSelector:@selector(bubbleView:itemForIndex:)]) {
            
            JFBubbleItem *bubble = [bubbleDataSource bubbleView:self itemForIndex:index];
            [itemsArray addObject:bubble];
            bubble.index = index;
            bubble.frame = CGRectZero;
            [contentView addSubview:bubble];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBegin:)];
            [bubble addGestureRecognizer:tap];
        }
    }
    
    [self renderBubblesAnimated:NO];
}

- (void)renderBubblesAnimated:(BOOL)animated{
    
    CGFloat nextBubbleX = edgeInsets.left;
    CGFloat nextBubbleY = edgeInsets.top;

    lineNumber = 1;
    
    for (NSInteger index = 0; index < itemsArray.count; index++) {
        JFBubbleItem *bubble = itemsArray[index];
        CGFloat bubbleWidth = [bubble widthByHeight:itemHeight];
        

        CGRect bubbleFrame = [self adjustItemRect:CGRectMake(nextBubbleX, nextBubbleY, bubbleWidth, itemHeight)];
        nextBubbleX = bubbleFrame.origin.x;
        nextBubbleY = bubbleFrame.origin.y;
        bubbleWidth = bubbleFrame.size.width;
       
        if (animated) {
            [UIView beginAnimations:@"bubbleRendering" context:@"bubbleItems"];
            [UIView setAnimationDuration:KJFBubbleAnmationDuration];
            bubble.frame = bubbleFrame;
            
            [UIView commitAnimations];
        }
        else{
            bubble.frame = bubbleFrame;
        }
        nextBubbleX += bubbleWidth + itemPadding;
    }
    
    selectedItemsArray = [NSMutableArray new];
    [self.itemsArray enumerateObjectsUsingBlock:^(JFBubbleItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected) {
            [selectedItemsArray addObject:obj];
        }
    }];
    [self resetContentSize];
}



#pragma mark -
-(CGRect)adjustItemRect:(CGRect)rect{
    CGFloat nextBubbleX = rect.origin.x;
    CGFloat nextBubbleY = rect.origin.y;
    CGFloat bubbleWidth = rect.size.width;
    CGFloat maxWidth = CGRectGetWidth(self.frame) - edgeInsets.left - edgeInsets.right;
    
    if (bubbleWidth > maxWidth) {
        bubbleWidth = maxWidth;
        nextBubbleX = edgeInsets.left;
        
        if (lineNumber != 1) {
            nextBubbleY += itemHeight + itemPadding;
        }
        lineNumber ++;
        
    }
    else  if ((bubbleWidth + nextBubbleX) > maxWidth){
        lineNumber ++;
        nextBubbleX = edgeInsets.left;
        if (lineNumber != 1) {
            nextBubbleY += itemHeight + itemPadding;
        }
    }
    CGRect bubbleFrame = CGRectMake(nextBubbleX, nextBubbleY, bubbleWidth, itemHeight);
    return bubbleFrame;
}


-(void)resetContentSize{
    CGFloat contentHeight = lineNumber * (lineSpace + itemHeight) + edgeInsets.top + edgeInsets.bottom;
    
    CGRect rect = contentView.frame;
    rect.origin.y = CGRectGetMaxY(self.bubbleHeaderView.frame);
    rect.size.height = contentHeight;
    contentView.frame = rect;
    
    self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetMaxY(contentView.frame));

    [self scrollToBottom];
    if (self.bubbleDelegate && [self.bubbleDelegate respondsToSelector:@selector(bubbleViewRefreshCompleted:)]) {
        [self.bubbleDelegate bubbleViewRefreshCompleted:self];
    }
}

-(void)scrollToBottom{
    CGRect visibleRect = self.itemsArray.lastObject.frame;
    visibleRect.origin.y += itemPadding;
    
    [self scrollRectToVisible:visibleRect animated:YES];
}

#pragma mark - Select
#pragma mark -

-(void)tapBegin:(UITapGestureRecognizer *)tap{
    JFBubbleItem *item = (JFBubbleItem *)tap.view;
    BOOL selected = !item.isSelected;
    if (selected) {
        [self selectBubbleItem:item];
    }
    else{
        [self deselectBubbleItem:item];
    }
    if (self.bubbleDelegate && [self.bubbleDelegate respondsToSelector:@selector(bubbleView:didTapItem:)]) {
        [self.bubbleDelegate bubbleView:self didTapItem:item];
    }
}

-(void)selectBubbleAtIndex:(NSInteger)index{
    JFBubbleItem *item = [itemsArray objectAtIndex:index];
    [self selectBubbleItem:item];
}

-(void)deselectBubbleAtIndex:(NSInteger)index{
    JFBubbleItem *item = [itemsArray objectAtIndex:index];
    [self deselectBubbleItem:item];
}

-(void)selectBubbleItem:(JFBubbleItem *)item{
    if (!self.allowsMultipleSelection) {
        [selectedItemsArray enumerateObjectsUsingBlock:^(JFBubbleItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self deselectBubbleItem:obj];
        }];
    }
    
    [item setSelected:YES animated:YES];
    [selectedItemsArray addObject:item];
    if (self.bubbleDelegate && [self.bubbleDelegate respondsToSelector:@selector(bubbleView:didSelectItem:)]) {
        [self.bubbleDelegate bubbleView:self didSelectItem:item];
    }
}

-(void)deselectBubbleItem:(JFBubbleItem *)item{
    [item setSelected:NO animated:NO];
    
    NSMutableArray *array = selectedItemsArray;
    [array removeObject:item];
    selectedItemsArray = array;
    if (self.bubbleDelegate && [self.bubbleDelegate respondsToSelector:@selector(bubbleView:didDeselectItem:)]) {
        [self.bubbleDelegate bubbleView:self didDeselectItem:item];
    }
}
@end

