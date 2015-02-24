//
//  ReportViewController.m
//  Gifted Kids Parent
//
//  Created by Yi Emma Li on 2/13/15.
//  Copyright (c) 2015 Yi Li. All rights reserved.
//

#import "AppDelegate.h"
#import "ReportViewController.h"
#import "SWRevealViewController.h"

#import "BEMSimpleLineGraphView.h"
#import "DateManager.h"

#import "StudentLearnedWord.h"


typedef enum{added = 0, total} CountType;

typedef enum{week = 0, month, year} CountPeriod;


@interface ReportViewController () <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *wordLineGraph;

@property (weak, nonatomic) IBOutlet UISegmentedControl *countTypeSegmentedControl;

@property (weak, nonatomic) IBOutlet UISegmentedControl *countPeriodSegmentedControl;

@property (nonatomic) CountType type;

@property (nonatomic) CountPeriod period;

@property (nonatomic, strong) NSArray* currentData;


@property (nonatomic, strong) NSManagedObjectContext* context;


@property (nonatomic, strong) NSArray* weekAllWords;

@property (nonatomic, strong) NSArray* monthAllWords;

@property (nonatomic, strong) NSArray* yearAllWords;

@property (nonatomic, strong) NSArray* weekDailyWords;

@property (nonatomic, strong) NSArray* monthDailyWords;

@property (nonatomic, strong) NSArray* yearWeeklyWords;

@end


@implementation ReportViewController

- (void)viewDidLoad
{
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
    
    // Set up graph
    self.wordLineGraph.delegate = self;
    self.wordLineGraph.dataSource = self;
    [self configureGraph];
    
    // Set up segmented control
    [self.countTypeSegmentedControl addTarget:self
                                       action:@selector(countTypeChanged:)
                             forControlEvents:UIControlEventValueChanged];
    [self.countPeriodSegmentedControl addTarget:self
                                         action:@selector(countPeriodChanged:)
                               forControlEvents:UIControlEventValueChanged];
    
    
    // Get Managed Object Context
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.context = appDelegate.managedObjectContext;
    
    
    // Load Data
    NSDate* yearlyStartDate = [DateManager dateDays:-364 afterDate:[DateManager today]];
    NSError* error = nil;
    
    
    // Get total words and daily new words for the past year
    NSFetchRequest* request_year = [NSFetchRequest fetchRequestWithEntityName:@"StudentLearnedWord"];
    request_year.predicate = [NSPredicate predicateWithFormat:@"date >= %@", yearlyStartDate];
    request_year.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    request_year.propertiesToFetch = [NSArray arrayWithObjects:@"dailyNewWordsCount", @"allWordsCount", nil];
    NSArray* match_yearly = [self.context executeFetchRequest:request_year error:&error];
    
    // Calculate daily new words and total words for every day in the past year
    NSMutableArray* dailyTotal = [NSMutableArray array];
    NSMutableArray* dailyNew = [NSMutableArray array];
    for (size_t index = 0; index < match_yearly.count; ++index) {
        StudentLearnedWord* obj = [match_yearly objectAtIndex:index];
        [dailyTotal addObject:obj.allWordsCount];
        [dailyNew addObject:obj.dailyNewWordsCount];
    }
    
    // Fill daily new and total words to 365 days
    while (dailyTotal.count < 365) {
        [dailyTotal insertObject:[NSNumber numberWithInt:-1] atIndex:0];
    }
    while (dailyNew.count < 365) {
        [dailyNew insertObject:[NSNumber numberWithInt:-1] atIndex:0];
    }
    
    // Calculate daily and total words for the past week and the past month
    self.weekAllWords = [dailyTotal subarrayWithRange:NSMakeRange(dailyTotal.count-7, 7)];
    self.weekDailyWords = [dailyNew subarrayWithRange:NSMakeRange(dailyNew.count-7, 7)];
    self.monthAllWords = [dailyTotal subarrayWithRange:NSMakeRange(dailyTotal.count-30, 30)];
    self.monthDailyWords = [dailyNew subarrayWithRange:NSMakeRange(dailyNew.count-30, 30)];
    
    // Calculate weekly total words for every week in the past year
    NSMutableArray* weeklyTotalWords = [NSMutableArray arrayWithCapacity:52];
    for (size_t index = dailyTotal.count - 7 * 52 + 6; index < dailyTotal.count; index += 7) {
        [weeklyTotalWords addObject:[dailyTotal objectAtIndex:index]];
    }
    self.yearAllWords = weeklyTotalWords;
    
    // Calculate weekly new words for every week in the past year
    NSMutableArray* weeklyNewWords = [NSMutableArray array];
    for (size_t index = dailyNew.count - 7 * 52; index < dailyNew.count; index += 7) {
        size_t sum = 0;
        BOOL valid = NO;
        for (size_t day = 0; day < 7; ++day) {
            NSInteger added = [[dailyNew objectAtIndex:index + day] integerValue];
            if (added >= 0) {
                sum += added;
                valid = YES;
            }
        }
        if (! valid) {
            [weeklyNewWords addObject:[NSNumber numberWithInteger:-1]];
        }
        else {
            [weeklyNewWords addObject:[NSNumber numberWithInteger:sum]];
        }
    }
    self.yearWeeklyWords = weeklyNewWords;
    
    
    // Load Graph
    [self reloadData];
//    self.currentData = self.weekDailyWords;
//    [self.wordLineGraph reloadGraph];
}


#pragma mark - Segmented Control

- (void)countTypeChanged:(UISegmentedControl*)control
{
    self.type = (int)control.selectedSegmentIndex;
    [self reloadData];
}

- (void)countPeriodChanged:(UISegmentedControl*)control
{
    self.period = (int)control.selectedSegmentIndex;
    [self reloadData];
}

- (void)reloadData
{
    switch (self.type) {
        case added:
            self.wordLineGraph.enableBezierCurve = YES;
            switch (self.period) {
                case week:
                    self.currentData = self.weekDailyWords;
                    break;
                    
                case month:
                    self.currentData = self.monthDailyWords;
                    break;
                    
                case year:
                    self.currentData = self.yearWeeklyWords;
                    break;
                    
                default:
                    break;
            }
            break;
            
        case total:
            self.wordLineGraph.enableBezierCurve = NO;
            switch (self.period) {
                case week:
                    self.currentData = self.weekAllWords;
                    break;
                    
                case month:
                    self.currentData = self.monthAllWords;
                    break;
                    
                case year:
                    self.currentData = self.yearAllWords;
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
    // Remove -1
    if ([self.currentData containsObject:[NSNumber numberWithInteger:-1]]) {
        NSMutableArray* mutableCurrentData = [self.currentData mutableCopy];
        [mutableCurrentData removeObject:[NSNumber numberWithInteger:-1]];
        self.currentData = [mutableCurrentData copy];
    }
    
    // Reload graph
    [self.wordLineGraph reloadGraph];
}


#pragma mark - Configure Graph

- (void)configureGraph
{
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    UIColor* themeColor = [UIColor redColor];
//    UIColor* themeColor = [UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0];
    
    self.wordLineGraph.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    self.wordLineGraph.colorTop = themeColor;
    self.wordLineGraph.colorBottom = themeColor;
    self.wordLineGraph.colorLine = [UIColor whiteColor];
    self.wordLineGraph.colorXaxisLabel = [UIColor whiteColor];
    self.wordLineGraph.colorYaxisLabel = [UIColor whiteColor];
    self.wordLineGraph.widthLine = 3.0;
    self.wordLineGraph.enableTouchReport = YES;
    self.wordLineGraph.enablePopUpReport = YES;
    self.wordLineGraph.enableBezierCurve = YES;
    self.wordLineGraph.enableYAxisLabel = YES;
    self.wordLineGraph.autoScaleYAxis = YES;
    self.wordLineGraph.alwaysDisplayDots = NO;
    self.wordLineGraph.enableReferenceXAxisLines = NO;
    self.wordLineGraph.enableReferenceYAxisLines = YES;
    self.wordLineGraph.enableReferenceAxisFrame = YES;
    self.wordLineGraph.animationGraphStyle = BEMLineAnimationDraw;
}


#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.currentData.count;
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.currentData objectAtIndex:index] floatValue];
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.currentData.count / 10;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    if (self.period == year) {
        return [NSString stringWithFormat:@"Wk\n%ld", index + 1];
    }
    else {
        return [NSString stringWithFormat:@"Day\n%ld", index + 1];
    }
}

- (NSInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph
{
    return 7;
}

//- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
//    self.labelValues.text = [NSString stringWithFormat:@"%@", [self.arrayOfValues objectAtIndex:index]];
//    self.labelDates.text = [NSString stringWithFormat:@"in %@", [self.arrayOfDates objectAtIndex:index]];
//}

//- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.labelValues.alpha = 0.0;
//        self.labelDates.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
//        self.labelDates.text = [NSString stringWithFormat:@"between %@ and %@", [self.arrayOfDates firstObject], [self.arrayOfDates lastObject]];
//        
//        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            self.labelValues.alpha = 1.0;
//            self.labelDates.alpha = 1.0;
//        } completion:nil];
//    }];
//}

//- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {
//    self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
//    self.labelDates.text = [NSString stringWithFormat:@"between %@ and %@", [self.arrayOfDates firstObject], [self.arrayOfDates lastObject]];
//}

@end
