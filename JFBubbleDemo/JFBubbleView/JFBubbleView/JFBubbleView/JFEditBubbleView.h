//
//  JFEditBubbleView.h
//  JFBubbleView
//
//  Created by joanfen on 2016/11/15.
//  Copyright © 2016年 joanfen. All rights reserved.
//

#import "JFBubbleView.h"
@protocol JFEditBubbleViewDelegate;

/// @note 不要设置JFEditBubbleView 的 dataSource 和 delegate，如需要拦截事件，请重载此类
@interface JFEditBubbleView : JFBubbleView

@property (nonatomic, weak) id<JFEditBubbleViewDelegate> editBubbleViewDelegate;
@property (nonatomic, strong) NSMutableArray<NSString *> *dataArray;
@property (nonatomic, strong) NSString *placeholder;

@end


@protocol JFEditBubbleViewDelegate <NSObject>

@optional

/*!
 * @brief 通过输入框添加 bubble 成功后回调
 * @param text 被添加的bubble的文字
 * @note 只有通过输入框添加才会触发此方法，被动添加（外部条件触发，代码处理）均不会触发此方法
 */
-(void)addItemWithTextFinished:(NSString *)text;

-(void)deleteItemWithTextFinished:(NSString *)text;

-(void)bubbleViewRefreshCompleted:(JFBubbleView *)bubbleView;


@end
