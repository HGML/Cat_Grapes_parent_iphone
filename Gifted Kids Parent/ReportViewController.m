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


@property (nonatomic, strong) NSArray* weeklyAllWords;

@property (nonatomic, strong) NSArray* monthlyAllWords;

@property (nonatomic, strong) NSArray* yearlyAllWords;

@property (nonatomic, strong) NSArray* weeklyDailyWords;

@property (nonatomic, strong) NSArray* monthlyDailyWords;

@property (nonatomic, strong) NSArray* yearlyDailyWords;

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
    NSDate* endDate = [DateManager today];
    NSDate* yearlyStartDate = [DateManager dateDays:-364 afterDate:endDate];
    NSError* error = nil;
    
    
    // Get total words and daily new words for the past year
    NSFetchRequest* request_year = [NSFetchRequest fetchRequestWithEntityName:@"StudentLearnedWord"];
    request_year.predicate = [NSPredicate predicateWithFormat:@"%@ <= date && date <= %@", yearlyStartDate, endDate];
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
    self.yearlyAllWords = dailyTotal;
    self.yearlyDailyWords = dailyNew;
    
    // Calculate daily and total words for the past month and the past week
    self.monthlyAllWords = [dailyTotal subarrayWithRange:NSMakeRange(dailyTotal.count-30, 30)];
    self.monthlyDailyWords = [dailyNew subarrayWithRange:NSMakeRange(dailyNew.count-30, 30)];
    self.weeklyAllWords = [dailyTotal subarrayWithRange:NSMakeRange(dailyTotal.count-7, 7)];
    self.weeklyDailyWords = [dailyNew subarrayWithRange:NSMakeRange(dailyNew.count-7, 7)];
    
    
    // Load Graph
    self.currentData = self.weeklyDailyWords;
    [self.wordLineGraph reloadGraph];
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
            switch (self.period) {
                case week:
                    self.currentData = self.weeklyDailyWords;
                    break;
                    
                case month:
                    self.currentData = self.monthlyDailyWords;
                    break;
                    
                case year:
                    self.currentData = self.yearlyDailyWords;
                    break;
                    
                default:
                    break;
            }
            break;
            
        case total:
            switch (self.period) {
                case week:
                    self.currentData = self.weeklyAllWords;
                    break;
                    
                case month:
                    self.currentData = self.monthlyAllWords;
                    break;
                    
                case year:
                    self.currentData = self.yearlyAllWords;
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
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
    return (int)[self.currentData count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.currentData objectAtIndex:index] floatValue];
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    switch (self.period) {
        case week:
            return 1;
            break;
            
        case month:
            return 5;
            break;
            
        case year:
            return 30;
            
        default:
            return 0;
            break;
    }
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSString *label = [NSString stringWithFormat:@"Day %ld", index + 1];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
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
