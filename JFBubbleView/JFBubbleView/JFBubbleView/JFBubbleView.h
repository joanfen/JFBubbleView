//
//  JFBubbleView.h
//  JFBubbleView
//
//  Created by joanfen on 15/6/11.
//  Copyright (c) 2015年 joanfen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JFBubbleItem;
@protocol JFBuddleViewDataSource, JFBuddleViewDelegate;

@interface JFBubbleView : UIScrollView

@property (nonatomic, weak) id<JFBuddleViewDataSource> bubbleDataSource;
@property (nonatomic, weak) id<JFBuddleViewDelegate> bubbleDelegate;

@property (nonatomic, assign) BOOL allowsMultipleSelection; ///< 是否允许多选，默认 NO

@property (nonatomic, assign) CGFloat itemHeight; ///< item高度 @note 默认33
@property (nonatomic, assign) CGFloat itemSpace;  ///< item之间的横向距离 @note 默认 10
@property (nonatomic, assign) CGFloat lineSpace;  ///< item行之前的距离 @note 默认 10
@property (nonatomic, assign) CGFloat itemPadding; ///< 每行的起始 item 距视图左边的距离 @note 默认 15

@property (nonatomic, assign) UIEdgeInsets edgeInsets; ///< Items 距 自身上下左右的距离，默认 `{15, 15, 15, 15}`

@property (nonatomic, strong) UIView *bubbleHeaderView;

-(id)dequeueReuseItemWithIdentifier:(NSString *)identifier;

-(NSArray *)indexesForSelectedItems;

-(void)removeSelectedItem;
-(void)addBubbleItem:(JFBubbleItem *)item;
-(void)insertBubbleItem:(JFBubbleItem *)item atIndex:(NSInteger)index;

-(void)reloadData;

-(CGRect)adjustItemRect:(CGRect)rect;
-(void)resetContentSize;
-(void)scrollToBottom;

-(void)selectBubbleAtIndex:(NSInteger)index;
-(void)deselectBubbleAtIndex:(NSInteger)index;

@end

#pragma mark - Buddle View Data Source
@protocol JFBuddleViewDataSource <NSObject>

-(NSInteger)numberOfItemsInBubbleView:(JFBubbleView *)bubbleView;

-(JFBubbleItem *)bubbleView:(JFBubbleView *)bubbleView itemForIndex:(NSInteger)index;

@end


#pragma mark - Bubble View Delegate
@protocol JFBuddleViewDelegate <NSObject>

@optional
-(void)bubbleView:(JFBubbleView *)bubbleView didTapItem:(JFBubbleItem *)item;

-(void)bubbleView:(JFBubbleView *)bubbleView didSelectItem:(JFBubbleItem *)item;
-(void)bubbleView:(JFBubbleView *)bubbleView didDeselectItem:(JFBubbleItem *)item;
-(void)bubbleViewRefreshCompleted:(JFBubbleView *)bubbleView;

@end

