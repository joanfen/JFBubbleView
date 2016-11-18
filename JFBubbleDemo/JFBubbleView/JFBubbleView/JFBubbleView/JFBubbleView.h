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

@property (nonatomic, assign) UIEdgeInsets edgeInsets; ///< Items 距 自身上下左右的距离，默认 `{15, 15, 15, 15}`

@property (nonatomic, strong) UIView *bubbleHeaderView;

-(id)dequeueReuseItemWithIdentifier:(NSString *)identifier;

-(NSArray *)indexesForSelectedItems;///< 选中的 index 值，不能多选时只有一个值

-(id)itemAtIndex:(NSInteger)index;

-(void)removeSelectedItem;
-(void)removeItem:(JFBubbleItem *)item animated:(BOOL)animated;

-(void)addBubbleItem:(JFBubbleItem *)item; ///< 在最末添加一个 BubbleItem

-(void)reloadData;


-(CGRect)adjustItemRect:(CGRect)rect;///< 调整 bubbleItem 的坐标 @note 超出视图宽度换行
-(void)resetContentSize; ///< 重置滚动区域
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
/*!
 * @brief 点击 item 的回调方法
 * @note 与 didSelectItem 方法的区别是 didSelectItem 可以外部触发，但是 didTapItem必须是手指触碰才会触发
 */
-(void)bubbleView:(JFBubbleView *)bubbleView didTapItem:(JFBubbleItem *)item;

/*!
 * @brief item 被选中时回调
 */
-(void)bubbleView:(JFBubbleView *)bubbleView didSelectItem:(JFBubbleItem *)item;
-(void)bubbleView:(JFBubbleView *)bubbleView didDeselectItem:(JFBubbleItem *)item;

/*!
 * @brief bubbleView Reload 后的回调
 * @note 可以在此回调中对 frame 的变化进行监控
 */
-(void)bubbleViewRefreshCompleted:(JFBubbleView *)bubbleView;

@end

