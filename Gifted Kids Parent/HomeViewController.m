//
//  HomeViewController.m
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/11.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import "HomeViewController.h"

#import "SWRevealViewController.h"
#import "ImageTextCell.h"


@interface HomeViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UILabel *progressBarFilled;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filledWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *progressBarEmpty;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emptyWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *consecutiveLabel;

@property (weak, nonatomic) IBOutlet UILabel *wordCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *structureCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *coinCountLabel;

@property (weak, nonatomic) IBOutlet UITableView *newsFeedTableView;

@end


@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up SWRevealController
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    // Update progress bar
    [self updateProgressBar];
    
    // Update consecutive days label
    [self updateConsecutiveLabel];
    
    // Update word count, structure count, and coin count labels
    [self updateWordCountLabel];
    [self updateStructureCountLabel];
    [self updateCoinCountLabel];
    
    // Update news feed table
    [self updateNewsFeedTable];
}


#pragma mark - Setup

- (void)updateProgressBar
{
    float screenWidth = self.view.frame.size.width;
    
    int currentCount = 27;   // number of days active (not consecutive)
    int nextGoal = 30;
    int previousGoal = 20;
    
    [self.progressBarFilled setText:[NSString stringWithFormat:@"%d天", currentCount]];
    [self.progressBarEmpty setText:[NSString stringWithFormat:@"%d天", nextGoal]];
    
    float filledWidth = screenWidth * (currentCount - previousGoal) / (nextGoal - previousGoal);
    float emptyWidth = screenWidth - filledWidth;
    self.filledWidthConstraint.constant = filledWidth;
    self.emptyWidthConstraint.constant = emptyWidth;
}

- (void)updateConsecutiveLabel
{
    int consecutiveDays = 24;
    NSMutableAttributedString* message = [self.consecutiveLabel.attributedText mutableCopy];
    UIFont* font = [UIFont systemFontOfSize:60.0];
    NSAttributedString* numberString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", consecutiveDays]
                                                                       attributes:@{NSFontAttributeName : font}];
    [message replaceCharactersInRange:NSMakeRange(3, message.length-5) withAttributedString:numberString];
    [self.consecutiveLabel setAttributedText:message];
}

- (void)updateWordCountLabel
{
    int wordCount = 267;
    [self.wordCountLabel setText:[NSString stringWithFormat:@"%d", wordCount]];
}

- (void)updateStructureCountLabel
{
    int structureCount = 32;
    [self.structureCountLabel setText:[NSString stringWithFormat:@"%d", structureCount]];
}

- (void)updateCoinCountLabel
{
    int coinCount = 1867;
    [self.coinCountLabel setText:[NSString stringWithFormat:@"%d", coinCount]];
}

- (void)updateNewsFeedTable
{
    self.newsFeedTableView.dataSource = self;
}


#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
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


#pragma mark - Memory Warning

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
