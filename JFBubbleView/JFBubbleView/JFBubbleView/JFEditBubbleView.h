//
//  JFEditBubbleView.h
//  JFBubbleView
//
//  Created by joanfen on 2016/11/15.
//  Copyright © 2016年 joanfen. All rights reserved.
//

#import "JFBubbleView.h"
@protocol JFEditBubbleViewDelegate;

@interface JFEditBubbleView : JFBubbleView

@property (nonatomic, weak) id<JFEditBubbleViewDelegate> editBubbleViewDelegate;

@property (nonatomic, strong) NSMutableArray<NSString *> *dataArray;
@property (nonatomic, strong) NSString *placeholder;

@end

@protocol JFEditBubbleViewDelegate <NSObject>

-(void)addItemFinished:(JFBubbleItem *)item;

@end
