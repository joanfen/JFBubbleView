//
//  searchTagsViewController.m
//  JFBubbleDemo
//
//  Created by joanfen on 2016/11/18.
//  Copyright © 2016年 joanfen. All rights reserved.
//

#import "searchTagsViewController.h"
#import "JFBubbleHeader.h"
@interface searchTagsViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) JFBubbleView *searchTagsView;
@end

@implementation searchTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UITableViewCell new];
}

@end
