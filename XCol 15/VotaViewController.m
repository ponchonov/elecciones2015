//
//  VotaViewController.m
//  XCol 15
//
//  Created by HECTOR ALFONSO on 25/04/15.
//  Copyright (c) 2015 SHDH. All rights reserved.
//

#import "VotaViewController.h"
#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#define kSITIO_WEB "www.google.com"
#import <JGProgressHUD.h>

@interface VotaViewController ()
@property NSIndexPath *indexP;
@property NSString *datosGuardados;
@property (weak, nonatomic) IBOutlet UIButton *buttonVotar;
@property (nonatomic, strong) JGProgressHUD * progressHud;
@end

@implementation VotaViewController
@synthesize votosTableView,candidatos;

- (void)viewDidLoad {
    [super viewDidLoad];
    votosTableView.dataSource = self;
    votosTableView.delegate= self;
    self.title = @"Por quién Votarías?";
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _datosGuardados = [defaults objectForKey:@"dataSaved"];
    NSLog(@"los datos guardados son: %@",_datosGuardados);
    //ProgressHud definition
    _progressHud = [JGProgressHUD progressHUDWithStyle:(JGProgressHUDStyleDark)];
    [[_progressHud textLabel] setText:@"Registrando"];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [self backButtonItem];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Methods

- (void)backButtonItemTapped
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(VotaViewControllerDidRequestBeingClosed:)]) {
        [self.delegate VotaViewControllerDidRequestBeingClosed:self];
    }
}


#pragma mark - Getters

- (UIBarButtonItem *)backButtonItem
{
    return [[UIBarButtonItem alloc] initWithTitle:@"Cerrar" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonItemTapped)];
}


#pragma mark Data for the tableView

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return candidatos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"CellImage";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    Candidato *detalle = candidatos[indexPath.row];
    cell.textLabel.text = detalle.name;
    if([indexPath isEqual:_indexP]){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _indexP = indexPath;
    [votosTableView reloadData];
    
}
- (IBAction)votarAction:(id)sender {
    Candidato *candidatoToVote = candidatos[_indexP.row];
    
    UIAlertView * alerta = [[UIAlertView alloc]
                            initWithTitle:@"Voto"
                            message:[NSString stringWithFormat:@"Estas Segur@ que quieres votar por %@",candidatoToVote.name]
                            delegate:self
                            cancelButtonTitle:@"Cancelar"
                            otherButtonTitles:@"Votar", nil];
    
    //Mostramos la alerta.
    [alerta show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Cancelar"])
    {
        //Lo que queremos que haga una vez que pulsamos cancelar.
    }
    else if([title isEqualToString:@"Votar"])
    {
        if([self conexion])
        {
            [_progressHud showInView:[self view] animated:YES];
            [self sendDataforVoto];
            
        }
        
    }
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
                                                        message:@"No tienes conexión a internet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    
}

-(void) sendDataforVoto
{
    NSString *idDevice = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *idCandidate =[NSString stringWithFormat:@"%ld", (long)_indexP.row+1] ;
    NSLog(@"Id Device: %@",idDevice);
    // NSString *post = @"no_control=%@&password=PONCHOC";
    NSString *post = [NSString stringWithFormat:@"id_device=%@&id_candidate=%@&election=gobernador",idDevice,idCandidate];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSURL *url = [NSURL URLWithString:@"http://52.10.114.97/votaciones-api/index.php/save/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(!error){
            NSError *JSONerror = nil;
            NSDictionary *JSONDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&JSONerror];
            
            NSLog(@"%@",JSONDict);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
            if(JSONDict[@"results"]){
                [_progressHud dismissAnimated:YES];
                if(JSONDict[@"results"][@"error"])
                            {
                                                     NSString *resultado =JSONDict[@"results"][@"error"];
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error"
                                                                                message:resultado
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                                [alert show];
                            }
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                    message:@"Voto registrado correctamente"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"dataSaved"];
                
                _buttonVotar.hidden = YES;
                
            }
                });
            });
        }
    }];
    
    [dataTask resume];

    
}
@end
