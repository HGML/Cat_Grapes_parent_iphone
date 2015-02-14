//
//  NewsFeedController.m
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/13.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import "NewsFeedController.h"
#import "ImageTextCell.h"

#import "SWRevealViewController.h"


@interface NewsFeedController ()

@end


@implementation NewsFeedController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up navigation bar
    UIBarButtonItem* sidebarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu.png"]
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self.revealViewController
                                                                     action:@selector(revealToggle:)];
    [self.navigationItem setLeftBarButtonItem:sidebarButton];
    
    
    // Set up SWRevealController
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageTextCell *cell = (ImageTextCell*)[tableView dequeueReusableCellWithIdentifier:@"newsFeedCell" forIndexPath:indexPath];
    
    if (indexPath.row % 3 == 0) {
        [cell.image setImage:[UIImage imageNamed:@"Alarm_small_11222.png"]];
        [cell.label setText:@"小明今天主动准时复习了！"];
    }
    else if (indexPath.row % 3 == 1) {
        [cell.image setImage:[UIImage imageNamed:@"Sentence_small_59929.png"]];
        [cell.label setText:@"昨天说对了一句中考句子！"];
    }
    else {
        [cell.image setImage:[UIImage imageNamed:@"Coin_small_99355.png"]];
        [cell.label setText:@"昨天挣了86个金币！"];
    }
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
