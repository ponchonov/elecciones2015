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

@interface VotaViewController ()
@property NSMutableArray *candidatoPartido;
@property NSIndexPath *indexP;
@end

@implementation VotaViewController
@synthesize votosTableView,candidatos,buttonForVote;

- (void)viewDidLoad {
    [super viewDidLoad];
    votosTableView.dataSource = self;
    votosTableView.delegate= self;
    self.title = @"Por quién Votarías?";
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
    candidato *detalle = candidatos[indexPath.row];
    cell.textLabel.text = detalle.name;
    NSLog(@"UNO: %@ DOS: %@",indexPath,_indexP);
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
    candidato *candidatoToVote = candidatos[_indexP.row];
    
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
    NSLog(@"%@",idCandidate);
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
            
              NSLog(@"%@", JSONDict);
            if(JSONDict[@"status"]){
                for(NSDictionary *user in JSONDict[@"status"]){
                    NSLog(@"%@", user);
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }
        }
    }];
    
    [dataTask resume];

    
}
@end
