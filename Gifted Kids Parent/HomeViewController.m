//
//  HomeViewController.m
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/11.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"

#import "SWRevealViewController.h"
#import "ImageTextCell.h"

#import "StudentLearnedWord.h"
#import "StudentLearnedComponent.h"


@interface HomeViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *progressBarFilled;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filledWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *progressBarEmpty;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emptyWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *consecutiveLabel;

@property (weak, nonatomic) IBOutlet UILabel *wordCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *structureCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *coinCountLabel;

@property (weak, nonatomic) IBOutlet UITableView *newsFeedTableView;



@property (nonatomic, strong) NSManagedObjectContext* context;

@end


@implementation HomeViewController

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
    
    
    // Sign up for server sync update notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(studentInfoUpdated:)
                                                 name:@"StudentInfoUpdated"
                                               object:nil];
    
    
    // Get Managed Object Context
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.context = appDelegate.managedObjectContext;
    
    
    // Check if logged in
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isLoggedIn"];   // TEST PURPOSE
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];   // TEST PURPOSE
    if (! [[[NSUserDefaults standardUserDefaults] objectForKey:@"isLoggedIn"] boolValue]) {
        [self performSegueWithIdentifier:@"showLogIn" sender:self];
    }
    else {
        // Update display
        [self updateDisplay];
    }
}


#pragma mark - StudentInfo Updated

- (void)studentInfoUpdated:(NSNotification*)notification
{
    [self updateDisplay];
}


#pragma mark - Update Display

- (void)updateDisplay
{
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

- (void)updateProgressBar
{
    float screenWidth = self.view.frame.size.width;
    
    int currentCount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"totalActiveDays"] intValue];   // number of days active (not consecutive)
    
    int nextGoal = 3;
    int previousGoal = 0;
    
    [self.progressBarFilled setText:[NSString stringWithFormat:@"%d天", currentCount]];
    [self.progressBarEmpty setText:[NSString stringWithFormat:@"%d天", nextGoal]];
    
    float filledWidth = screenWidth * (currentCount - previousGoal) / (nextGoal - previousGoal);
    float emptyWidth = screenWidth - filledWidth;
    self.filledWidthConstraint.constant = filledWidth;
    self.emptyWidthConstraint.constant = emptyWidth;
}

- (void)updateConsecutiveLabel
{
    int consecutiveDays = [[[NSUserDefaults standardUserDefaults] objectForKey:@"consecutiveActiveDays"] intValue];
    NSMutableAttributedString* message = [self.consecutiveLabel.attributedText mutableCopy];
    UIFont* font = [UIFont systemFontOfSize:60.0];
    NSAttributedString* numberString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", consecutiveDays]
                                                                       attributes:@{NSFontAttributeName : font}];
    [message replaceCharactersInRange:NSMakeRange(3, message.length-5) withAttributedString:numberString];
    [self.consecutiveLabel setAttributedText:message];
}

- (void)updateWordCountLabel
{
    NSError* error = nil;
    NSFetchRequest* request_learnedWord = [NSFetchRequest fetchRequestWithEntityName:@"StudentLearnedWord"];
    request_learnedWord.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    request_learnedWord.propertiesToFetch = [NSArray arrayWithObject:@"allWordsCount"];
    NSArray* match_learnedWord = [self.context executeFetchRequest:request_learnedWord error:&error];
    StudentLearnedWord* slw = [match_learnedWord lastObject];
    
    int wordCount = slw.allWordsCount.intValue;
    [self.wordCountLabel setText:[NSString stringWithFormat:@"%d", wordCount]];
}

- (void)updateStructureCountLabel
{
    NSError* error = nil;
    NSFetchRequest* request_learnedComponent = [NSFetchRequest fetchRequestWithEntityName:@"StudentLearnedComponent"];
    request_learnedComponent.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    request_learnedComponent.propertiesToFetch = [NSArray arrayWithObject:@"allComponentsCount"];
    NSArray* match_learnedComponent = [self.context executeFetchRequest:request_learnedComponent error:&error];
    StudentLearnedComponent* slc = [match_learnedComponent lastObject];
    
    int structureCount = slc.allComponentsCount.intValue;
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
