//
//  JFSelectBubbleView.h
//  JFBubbleDemo
//
//  Created by joanfen on 2016/11/16.
//  Copyright © 2016年 joanfen. All rights reserved.
//

#import "JFBubbleView.h"

@interface JFSelectBubbleView : JFBubbleView

/*!
 * @note setDataArray 方法会触发 `reloadData` 方法
 * @note 如果是 addObject 或是 removeObject，均需手动 `reloadData`
 */
@property (nonatomic, strong) NSMutableArray<NSString *> *dataArray;

@end
