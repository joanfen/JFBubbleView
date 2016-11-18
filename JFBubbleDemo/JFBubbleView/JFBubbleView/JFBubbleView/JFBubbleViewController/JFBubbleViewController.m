//
//  SetTagsViewController.m
//  JFLabelBubble
//
//  Created by joanfen on 2016/11/17.
//  Copyright © 2016年 joanfen. All rights reserved.
//

#import "JFBubbleViewController.h"
#import "JFBubbleHeader.h"
#import "DemoEditBubbleView.h"
#import "DemoSelectBubbleView.h"
@interface JFBubbleViewController ()<JFEditBubbleViewDelegate, JFBuddleViewDelegate, UIScrollViewDelegate>
{
    DemoEditBubbleView *editBubbleView;
    DemoSelectBubbleView *selectBubbleView;
    NSMutableArray<NSString *> *tagsWillBeAdd;
    
}
@end

@implementation JFBubbleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self addEditBubbleView];
    [self addSelectBubbleView];
}

-(void)addEditBubbleView{
    editBubbleView = [[DemoEditBubbleView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 50)];
    editBubbleView.editBubbleViewDelegate = self;
    [self.view addSubview:editBubbleView];
    [self resizeEditBubbleFrame];
}

-(void)addSelectBubbleView{
    selectBubbleView = [[DemoSelectBubbleView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(editBubbleView.frame), self.view.bounds.size.width, 300)];
    selectBubbleView.bubbleDelegate = self;
    selectBubbleView.delegate = self;
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 21)];
    header.text = @"所有分组";
    header.font = [UIFont systemFontOfSize:14];
    selectBubbleView.bubbleHeaderView = header;
    
    [self.view addSubview:selectBubbleView];
    NSArray *array = [editBubbleView.dataArray copy];
    
    for (NSString *text in array) {
        [selectBubbleView highlightItemWithText:text];

    }
}
- (IBAction)saveCilcked:(id)sender {
    [selectBubbleView addTags:tagsWillBeAdd];
    [editBubbleView writeSelectedBubbles];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Edit Bubble Delegate

-(void)addItemWithTextFinished:(NSString *)text{
    // 高亮添加的tag，如果无法高亮，说明该tag 不存在，存入 tagsWillBeAdd 数组 中，在最后保存时存入所有 tags 中
    BOOL canBeHighlight  = [selectBubbleView highlightItemWithText:text];
    if (canBeHighlight) {
        return;
    }
    if (!tagsWillBeAdd) {
        tagsWillBeAdd = [NSMutableArray new];
    }
    [tagsWillBeAdd addObject:text];
}

-(void)deleteItemWithTextFinished:(NSString *)text{

    BOOL canBeCancelHighlight  = [selectBubbleView cancelHighlightItemWithText:text];
    if (canBeCancelHighlight) {
        return;
    }
    if ([tagsWillBeAdd containsObject:text]) {
        [tagsWillBeAdd removeObject:text];
    }
}

#pragma mark - Bubble Delegate

-(void)bubbleView:(JFBubbleView *)bubbleView didSelectItem:(JFBubbleItem *)item{
    if (bubbleView == selectBubbleView) {
        if (![editBubbleView.dataArray containsObject:item.textLabel.text]) {
            [editBubbleView.dataArray addObject:item.textLabel.text];
            [editBubbleView reloadData];
        }
    }
}

-(void)bubbleView:(JFBubbleView *)bubbleView didDeselectItem:(JFBubbleItem *)item{
    if (bubbleView == selectBubbleView) {
        [editBubbleView.dataArray removeObject:item.textLabel.text];
        [editBubbleView reloadData];
    }
}

-(void)bubbleViewRefreshCompleted:(JFBubbleView *)bubbleView{
    if (bubbleView == editBubbleView) {
        [self resizeEditBubbleFrame];
        CGFloat selectBubbleY =  CGRectGetMaxY(bubbleView.frame) + 10;
        selectBubbleView.frame = CGRectMake(0, selectBubbleY, self.view.bounds.size.width, self.view.bounds.size.height - selectBubbleY);
    }
}

// 重置
-(void)resizeEditBubbleFrame{
    CGFloat editBubbleMaxHeight = 150;
    CGFloat bubbleViewFullHeight = editBubbleView.contentSize.height;
    CGRect rect = editBubbleView.frame;
    rect.size.height = MIN(editBubbleMaxHeight, bubbleViewFullHeight);
    editBubbleView.frame = rect;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [editBubbleView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
