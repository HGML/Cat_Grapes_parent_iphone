//
//  HomeViewController.m
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/11.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *progressBarFilled;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filledWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *progressBarEmpty;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emptyWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *consecutiveLabel;

@property (weak, nonatomic) IBOutlet UILabel *wordCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *structureCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *coinCountLabel;

@property (weak, nonatomic) IBOutlet UITableView *recentNewsTableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Update progress bar
    [self updateProgressBar];
    
    // Update consecutive days label
    [self updateConsecutiveLabel];
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
    NSLog(@"%.f-%.f", filledWidth, emptyWidth);
    
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