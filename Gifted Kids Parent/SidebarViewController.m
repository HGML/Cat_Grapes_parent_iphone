//
//  SidebarViewController.m
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/13.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import "SidebarViewController.h"
#import "ImageTextCell.h"

#import "SWRevealViewController.h"
#import "HomeViewController.h"
#import "NewsFeedController.h"


@interface SidebarViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;

@end


@implementation SidebarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuTableView.dataSource = self;
    
    CGRect frame = self.menuTableView.frame;
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 44 * 4);
    [self.menuTableView setFrame:frame];
}


#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageTextCell *cell;
    
    switch (indexPath.row) {
        case 0:
            cell = (ImageTextCell*)[tableView dequeueReusableCellWithIdentifier:@"homeCell" forIndexPath:indexPath];
            [cell.image setImage:[UIImage imageNamed:@"Home_56766.png"]];
            [cell.label setText:@"主页"];
            break;
            
        case 1:
            cell = (ImageTextCell*)[tableView dequeueReusableCellWithIdentifier:@"achievementCell" forIndexPath:indexPath];
            [cell.image setImage:[UIImage imageNamed:@"Achievement_55588.png"]];
            [cell.label setText:@"成绩"];
            break;
            
        case 2:
            cell = (ImageTextCell*)[tableView dequeueReusableCellWithIdentifier:@"reportCell" forIndexPath:indexPath];
            [cell.image setImage:[UIImage imageNamed:@"Report_20789.png"]];
            [cell.label setText:@"报告"];
            break;
            
        case 3:
            cell = (ImageTextCell*)[tableView dequeueReusableCellWithIdentifier:@"contractCell" forIndexPath:indexPath];
            [cell.image setImage:[UIImage imageNamed:@"Contract_59244.png"]];
            [cell.label setText:@"约定"];
            break;
            
        default:
            break;
    }
    
    return cell;
}


#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showHome"]) {
        
    }
    else if ([segue.identifier isEqualToString:@"showNewsFeed"]) {
        
    }
}

@end
