//
//  GraphsViewController.m
//  XCol 15
//
//  Created by HECTOR ALFONSO on 29/04/15.
//  Copyright (c) 2015 SHDH. All rights reserved.
//

#import "GraphsViewController.h"
#import <JGProgressHUD.h>
#import "Candidato.h"
#import <SystemConfiguration/SystemConfiguration.h>
#define kSITIO_WEB "www.google.com"

@interface GraphsViewController ()
@property (nonatomic, strong) JGProgressHUD * progressHud;
@property (nonatomic, strong) NSMutableArray *loscandidatos;
@end

@implementation GraphsViewController
@synthesize tableViewcontroller,candidatos;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewcontroller.dataSource = self;
    self.tableViewcontroller.delegate= self;
    //ProgressHud definition
    _progressHud = [JGProgressHUD progressHUDWithStyle:(JGProgressHUDStyleDark)];
    [[_progressHud textLabel] setText:@"Actualizando"];
    // Do any additional setup after loading the view.
    if([self conexion]){
        [self downloadData];
    }
    
    self.navigationItem.leftBarButtonItem = [self backButtonItem];
}


#pragma mark - Methods

- (void)backButtonItemTapped
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(graphsViewControllerDidRequestBeingClosed:)]) {
        [self.delegate graphsViewControllerDidRequestBeingClosed:self];
    }
}


#pragma mark - Getters

- (UIBarButtonItem *)backButtonItem
{
    return [[UIBarButtonItem alloc] initWithTitle:@"Cerrar" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonItemTapped)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return candidatos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Candidato *detalle = candidatos[indexPath.row];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    recipeImageView.contentMode = UIViewContentModeScaleToFill;
    recipeImageView.image = [UIImage imageNamed:detalle.photoRoute];
    UILabel *recipeNameLabel = (UILabel *)[cell viewWithTag:101];
    recipeNameLabel.text = @"X";
    UILabel *porcent = (UILabel *)[cell viewWithTag:102];
    porcent.text = detalle.porcentaje;
    return cell;
}


-(void) downloadData{
    [_progressHud showInView:[self view] animated:YES];
    NSURL *url = [NSURL URLWithString:@"http://52.10.114.97/votaciones-api/index.php/get/gobernador"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(!error){
            NSError *JSONerror = nil;
            NSDictionary *JSONDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&JSONerror];
            
            if(JSONDict[@"percent"]){
                for(NSDictionary *candidato in JSONDict[@"percent"]){
                    
                    Candidato *detalle2 =candidatos[[[candidato objectForKey:@"id_candidate"]integerValue]-1];
                    Candidato *newCandidato = [Candidato new];
                    newCandidato.name = detalle2.name;
                    newCandidato.biografiaRoute = detalle2.biografiaRoute;
                    newCandidato.propuestaRoute= detalle2.propuestaRoute;
                    newCandidato.photoRoute =detalle2.photoRoute;
                    newCandidato.partido= detalle2.partido;
                    NSString *porcentaje=[NSString stringWithFormat:@"%@ ",[candidato objectForKey:@"percent"]];
                    if(porcentaje.length > 4){
                        porcentaje = [porcentaje substringToIndex:4];
                    }
                    porcentaje= [NSString stringWithFormat:@"%@ %@", porcentaje,@"%"];
                    newCandidato.porcentaje = porcentaje;
                    
                    [candidatos replaceObjectAtIndex:[[candidato objectForKey:@"id_candidate"] integerValue]-1 withObject:newCandidato];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableViewcontroller reloadData];
                    [_progressHud dismissAnimated:YES];
                    
                });
                
                
            }
            
        }
    }];
    
    [dataTask resume];
    
}
- (BOOL)conexion{
    SCNetworkReachabilityRef referencia = SCNetworkReachabilityCreateWithName (kCFAllocatorDefault, kSITIO_WEB);
    
    SCNetworkReachabilityFlags resultado;
    SCNetworkReachabilityGetFlags ( referencia, &resultado );
    
    CFRelease(referencia);
    
    if (resultado & kSCNetworkReachabilityFlagsReachable) {
        return YES;
        
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Conectividad"
                                                        message:@"No tienes conexión a internet para actualizar los resultados"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    
}
@end
