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


@interface ReportViewController () <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *totalWordLineGraph;

@property (nonatomic, strong) NSArray* days;

@property (nonatomic, strong) NSArray* words;

@end


@implementation ReportViewController

- (void)viewDidLoad
{
    // Set up SWRevealController
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.days = [NSArray arrayWithObjects:@"Day 1", @"Day 2", @"Day 3", @"Day 4", @"Day 5", nil];
    self.words = [NSArray arrayWithObjects:[NSNumber numberWithInt:238], [NSNumber numberWithInt:242], [NSNumber numberWithInt:253], [NSNumber numberWithInt:260], [NSNumber numberWithInt:269], nil];
    
    self.totalWordLineGraph.delegate = self;
    self.totalWordLineGraph.dataSource = self;
    
    [self configureGraph];
}

- (void)configureGraph
{
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
//    UIColor* themeColor = [UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0];
    UIColor* themeColor = [UIColor orangeColor];
    
    self.totalWordLineGraph.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    self.totalWordLineGraph.colorTop = themeColor;
    self.totalWordLineGraph.colorBottom = themeColor;
    self.totalWordLineGraph.colorLine = [UIColor whiteColor];
    self.totalWordLineGraph.colorXaxisLabel = [UIColor whiteColor];
    self.totalWordLineGraph.colorYaxisLabel = [UIColor whiteColor];
    self.totalWordLineGraph.widthLine = 3.0;
    self.totalWordLineGraph.enableTouchReport = YES;
    self.totalWordLineGraph.enablePopUpReport = YES;
    self.totalWordLineGraph.enableBezierCurve = NO;
    self.totalWordLineGraph.enableYAxisLabel = YES;
    self.totalWordLineGraph.autoScaleYAxis = YES;
    self.totalWordLineGraph.alwaysDisplayDots = YES;
    self.totalWordLineGraph.enableReferenceXAxisLines = NO;
    self.totalWordLineGraph.enableReferenceYAxisLines = YES;
    self.totalWordLineGraph.enableReferenceAxisFrame = YES;
    self.totalWordLineGraph.animationGraphStyle = BEMLineAnimationDraw;
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
    return 0;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSString *label = [self.days objectAtIndex:index];
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
