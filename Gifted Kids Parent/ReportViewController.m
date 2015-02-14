//
//  ReportViewController.m
//  Gifted Kids Parent
//
//  Created by Yi Emma Li on 2/13/15.
//  Copyright (c) 2015 Yi Li. All rights reserved.
//

#import "ReportViewController.h"
#import "SWRevealViewController.h"

#import "BEMSimpleLineGraphView.h"


typedef enum{added = 0, total} CountType;

typedef enum{week = 0, month, year} CountPeriod;


@interface ReportViewController () <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *wordLineGraph;

@property (weak, nonatomic) IBOutlet UISegmentedControl *countTypeSegmentedControl;

@property (weak, nonatomic) IBOutlet UISegmentedControl *countPeriodSegmentedControl;

@property (nonatomic) CountType type;

@property (nonatomic) CountPeriod period;


@property (nonatomic, strong) NSArray* words;

@property (nonatomic, strong) NSArray* allWords;

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
    
    // Load graph data
    self.allWords = [NSArray arrayWithObjects:@"238", @"242", @"253", @"260", @"269", @"272", @"282", @"238", @"242", @"253", @"260", @"269", @"272", @"282", @"238", @"242", @"253", @"260", @"269", @"272", @"282", @"238", @"242", @"253", @"260", @"269", @"272", @"282", @"238", @"242", @"253", @"260", @"269", @"272", @"282", @"238", @"242", @"253", @"260", @"269", @"272", @"282", @"238", @"242", @"253", @"260", @"269", @"272", @"282", @"238", @"242", @"253", @"260", @"269", @"272", @"282", @"238", @"242", @"253", @"260", @"269", @"272", @"282", @"238", @"242", @"253", @"260", @"269", @"272", @"282", nil];
    [self reloadData];
}

- (void)reloadData
{
    switch (self.type) {
        case added:
            switch (self.period) {
                case week:
                    self.words = [NSArray arrayWithObjects:@"8", @"4", @"11", @"7", @"9", @"3", @"10", nil];
                    break;
                    
                case month:
                    
                    break;
                    
                case year:
                    
                    break;
                    
                default:
                    break;
            }
            break;
            
        case total:
            switch (self.period) {
                case week:
                    self.words = [self.allWords subarrayWithRange:NSMakeRange(0, 7)];
                    break;
                    
                case month:
                    self.words = [self.allWords subarrayWithRange:NSMakeRange(0, 30)];
                    break;
                    
                case year:
                    self.words = self.allWords;
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
    return (int)[self.words count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.words objectAtIndex:index] floatValue];
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
