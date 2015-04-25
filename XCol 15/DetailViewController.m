//
//  DetailViewController.m
//  XCol 15
//
//  Created by HECTOR ALFONSO on 25/04/15.
//  Copyright (c) 2015 SHDH. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize informationWebView;
@synthesize candidat,segmentControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = candidat.name;
    // Do any additional setup after loading the view.
    
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

- (IBAction)segmentSwitch:(UISegmentedControl*)sender {
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    if (selectedSegment == 0) {
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:candidat.biografiaRoute ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [self.informationWebView loadHTMLString:htmlString baseURL:nil];
           }
    else{
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:candidat.propuestaRoute ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [self.informationWebView loadHTMLString:htmlString baseURL:nil];
    }
    [UIView commitAnimations];
}

@end
