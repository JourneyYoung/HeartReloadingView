//
//  ViewController.m
//  PullDownAnimationDemo
//
//  Created by Journey on 2018/1/12.
//  Copyright © 2018年 GoDap. All rights reserved.
//

#import "ViewController.h"
#import <MJRefresh.h>
#import "GDRefreshNormalHeader.h"

@interface ViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildTableView];
    GDRefreshNormalHeader *header = [GDRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    header.ignoredScrollViewContentInsetTop = 242 - 64 ;
    header.stateLabel.textColor = [UIColor whiteColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.tableView.mj_header = header;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)loadNewData{
    NSLog(@"Refresh End");
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:3.f];
}

- (void)endRefresh{
    [self.tableView.mj_header endRefreshing];
}

- (void)buildTableView{
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.backgroundView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
