//
//  DetailViewController.m
//  XCol 15
//
//  Created by HECTOR ALFONSO on 25/04/15.
//  Copyright (c) 2015 SHDH. All rights reserved.
//

#import "DetailViewController.h"
#import "VotaViewController.h"
#import "GraphsViewController.h"

@interface DetailViewController () <GraphsViewControllerDelegate, VotaViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageCandidate;
@property (weak, nonatomic) IBOutlet UIButton *buttonAction;
@property (nonatomic,strong) NSString *datosGuardados;
@end

@implementation DetailViewController
@synthesize informationWebView;
@synthesize candidato,segmentControl,buttonAction;

- (void)viewDidLoad {
    [super viewDidLoad];
    Candidato *candidat = candidato[_selected];
   buttonAction.backgroundColor = [UIColor colorWithRed:0.843 green:0.0745 blue:0.5372 alpha:1.0];
    self.title = candidat.name;
    _imageCandidate.image = [UIImage imageNamed:candidat.photoRoute];
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:candidat.biografiaRoute ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.informationWebView loadHTMLString:htmlString baseURL:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _datosGuardados = [defaults objectForKey:@"dataSaved"];
    if([_datosGuardados isEqualToString:@"YES"]){
        [buttonAction setTitle:@"Resultados de nuestra encuesta" forState:UIControlStateNormal];
    }
    else{
        [buttonAction setTitle:@"Participa en nuestra Encuesta" forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _datosGuardados = [defaults objectForKey:@"dataSaved"];
    if([_datosGuardados isEqualToString:@"YES"]){
        [buttonAction setTitle:@"Resultados de nuestra encuesta" forState:UIControlStateNormal];
    }
    else{
        [buttonAction setTitle:@"Participa en nuestra Encuesta" forState:UIControlStateNormal];
    }
    // to reload selected cell
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)segmentSwitch:(UISegmentedControl*)sender {
    Candidato *candidat = candidato[_selected];
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


- (IBAction)changeView:(id)sender {
    UINavigationController *navController;
    
    if([_datosGuardados isEqualToString:@"YES"]){
        GraphsViewController *graphsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Graphs"];
        graphsViewController.candidatos = [[NSMutableArray alloc] initWithArray:candidato];
        graphsViewController.delegate = self;
        navController = [[UINavigationController alloc] initWithRootViewController:graphsViewController];
    }
    else
    {
        VotaViewController *votaViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Vota"];
        votaViewController.candidatos = candidato;
        votaViewController.delegate = self;
        navController = [[UINavigationController alloc] initWithRootViewController:votaViewController];
    }
    navController.navigationBar.barTintColor = [UIColor colorWithRed:45/255 green:62/255 blue:76/255 alpha:1.0];
    
    [self presentViewController:navController animated:YES completion:nil];
}


#pragma mark - Graphs View Controller Delegate

- (void)graphsViewControllerDidRequestBeingClosed:(GraphsViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Vota View Controller Delegate
- (void)VotaViewControllerDidRequestBeingClosed:(VotaViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
