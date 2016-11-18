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
static CGFloat const KJFDefaultInsetsValue = 15;
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
    UIEdgeInsets edgeInsets;
    
    NSInteger lineNumber;
    NSMutableArray<JFBubbleItem *> *selectedItemsArray;
}
@property (nonatomic, strong) NSMutableArray<JFBubbleItem *> *itemsArray;
@end

@implementation JFBubbleView

@synthesize itemHeight,itemSpace, lineSpace, edgeInsets;
@synthesize bubbleDataSource, bubbleDelegate, itemsArray;


-(void)defaultSizes{
    itemHeight = 33.0f;
    itemSpace = 10;
    lineSpace = 10;
    edgeInsets = UIEdgeInsetsMake(KJFDefaultInsetsValue, KJFDefaultInsetsValue, KJFDefaultInsetsValue, KJFDefaultInsetsValue);
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
        self.alwaysBounceVertical = YES;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.bubbleHeaderView.frame = CGRectMake(edgeInsets.left, edgeInsets.top, self.frame.size.width - edgeInsets.left, self.bubbleHeaderView.frame.size.height);
    contentView.frame = CGRectMake(0, CGRectGetMaxY(self.bubbleHeaderView.frame), self.bounds.size.width, self.contentSize.height - CGRectGetMaxY(self.bubbleHeaderView.frame));
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

-(id)itemAtIndex:(NSInteger)index{
    return [itemsArray objectAtIndex:index];
}

-(void)setEdgeInsets:(UIEdgeInsets)theEdgeInsets{
    edgeInsets = theEdgeInsets;
    [self reloadData];
}

-(void)setBubbleHeaderView:(UIView *)bubbleHeaderView{
    bubbleHeaderView.frame = CGRectMake(edgeInsets.left, edgeInsets.top, self.frame.size.width - edgeInsets.left, bubbleHeaderView.frame.size.height);
    _bubbleHeaderView = bubbleHeaderView;

    [self addSubview:_bubbleHeaderView];

}

#pragma mark - add

-(void)addBubbleItem:(JFBubbleItem *)item{
    [self insertBubbleItem:item atIndex:itemsArray.count animated:YES];
}

-(void)insertBubbleItem:(JFBubbleItem *)item atIndex:(NSInteger)index animated:(BOOL)animated{
    [itemsArray addObject:item];

    for (JFBubbleItem *bubble in itemsArray) {
        bubble.index = index;
        index++;
    }
    [self renderBubblesAnimated:animated];
}

-(void)addBubbleItemWithText:(JFBubbleItem *)item{
    [self insertBubbleItem:item atIndex:itemsArray.count - 1 animated:YES];
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
    [self renderBubblesAnimated:animated];
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
        nextBubbleX += bubbleWidth + itemSpace;
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
            nextBubbleY += itemHeight + lineSpace;
        }
        lineNumber ++;
        
    }
    else  if ((bubbleWidth + nextBubbleX) > maxWidth){
        lineNumber ++;
        nextBubbleX = edgeInsets.left;
        if (lineNumber != 1) {
            nextBubbleY += itemHeight + lineSpace;
        }
    }
    CGRect bubbleFrame = CGRectMake(nextBubbleX, nextBubbleY, bubbleWidth, itemHeight);
    return bubbleFrame;
}


-(void)resetContentSize{
    CGFloat contentHeight = lineNumber * (lineSpace + itemHeight) + edgeInsets.top + edgeInsets.bottom;
    
    CGRect rect = contentView.frame;
    rect.origin.y = CGRectGetMaxY(self.bubbleHeaderView.frame);
    rect.size.height = contentHeight - CGRectGetMaxY(self.bubbleHeaderView.frame);
    contentView.frame = rect;
    
    self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetMaxY(contentView.frame));
    if (self.bubbleDelegate && [self.bubbleDelegate respondsToSelector:@selector(bubbleViewRefreshCompleted:)]) {
        [self.bubbleDelegate bubbleViewRefreshCompleted:self];
    }
    [self scrollToBottom];
}

-(void)scrollToBottom{
    CGRect visibleRect = self.itemsArray.lastObject.frame;
    visibleRect.origin.y += edgeInsets.bottom;
    
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
    if (index<itemsArray.count) {
        JFBubbleItem *item = [itemsArray objectAtIndex:index];
        [self selectBubbleItem:item];
    }
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

