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

@interface DetailViewController ()
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueToVoto2"]) {
        VotaViewController *votaViewController = [segue destinationViewController];
        votaViewController.candidatos = candidato;
    }else{
            GraphsViewController *graphs =[segue destinationViewController];
            graphs.candidatos = [[NSMutableArray alloc]initWithArray:candidato];
        
    }
}


- (IBAction)changeView:(id)sender {
    if([_datosGuardados isEqualToString:@"YES"]){
        [self performSegueWithIdentifier:@"segueToGraphs2" sender:self];
        
    }
    else
    {
        [self performSegueWithIdentifier:@"segueToVoto2" sender:self];
    }
}
@end
