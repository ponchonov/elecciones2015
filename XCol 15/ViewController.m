//
//  ViewController.m
//  XCol 15
//
//  Created by HECTOR ALFONSO on 25/04/15.
//  Copyright (c) 2015 SHDH. All rights reserved.
//

#import "ViewController.h"
#import "Candidato.h"
#import "DetailViewController.h"
#import "VotaViewController.h"

@interface ViewController (){
    NSIndexPath *selectedIndexPath;
}
@property (nonatomic, strong) NSMutableArray *candidatoPartido;
@end

@implementation ViewController
@synthesize candidatosTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Candidatos";
    _candidatoPartido = [[NSMutableArray alloc]init];
    [self llenar];
    // Do any additional setup after loading the view, typically from a nib.
    candidatosTableView.delegate = self;
    candidatosTableView.dataSource= self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _candidatoPartido.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"CellImage";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
   // CustomCell *cell = [candidatosTableView dequeueReusableCellWithIdentifier:identifier];
   /*if(!cell)
   {
       cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
   }*/
    
    candidato *detalle = _candidatoPartido[indexPath.row];
    
    cell.textLabel.text = detalle.name;
    //cell.detailTextLabel.text = detalle.partido;
   // cell.nameLabel.text = detalle.name;
    UIImage *img = [UIImage imageNamed:detalle.photoRoute];
    [cell.imageView setImage:img];
    
   // [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
   // [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueToVoto"]) {
        VotaViewController *votaViewController = [segue destinationViewController];
        votaViewController.candidatos = _candidatoPartido;
    }else{
        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.candidat= _candidatoPartido[selectedIndexPath.row];
    }
}

-(void)llenar{
    
    for (int i=0;i<=7;i++){
        candidato *newCandidato = [candidato new];
        switch (i) {
            case 0:
            {
                newCandidato.name = @"José Ignacio Peralta";
                newCandidato.partido =@"PRI";
                newCandidato.photoRoute =@"peralta.jpg";
                newCandidato.biografiaRoute =@"biografiaNacho";
                newCandidato.propuestaRoute =@"propuestaNacho";
                break;
            }
            case 1:
            {
                newCandidato.name = @"Jorge Luis Preciado";
                newCandidato.partido =@"PAN";
                newCandidato.photoRoute =@"preciado.jpg";
                newCandidato.biografiaRoute =@"biografiaPreciado";
                newCandidato.propuestaRoute =@"propuestaPreciado";
                break;
            }
            case 2:
            {
                newCandidato.name = @"Martha Zepeda";
                newCandidato.partido =@"PRD";
                newCandidato.photoRoute =@"zepeda.jpg";
                newCandidato.biografiaRoute =@"biografiaZepeda";
                newCandidato.propuestaRoute =@"propuestaZepeda";
                break;
            }
            case 3:
            {
                newCandidato.name = @"Leoncio Morán";
                newCandidato.partido =@"Movimiento Ciudadano";
                newCandidato.photoRoute =@"moran.jpg";
                newCandidato.biografiaRoute =@"biografiaMoran";
                newCandidato.propuestaRoute =@"propuestaMoran";
                
                break;
            }
            case 4:
            {
                newCandidato.name = @"David Munro";
                newCandidato.partido =@"Movimiento Ciudadano";
                newCandidato.photoRoute =@"munro.jpg";
                newCandidato.biografiaRoute =@"biografiaMunro";
                newCandidato.propuestaRoute =@"propuestaMunro";
                
                break;
            }
            case 5:
            {
                newCandidato.name = @"José Francisco Gallardo";
                newCandidato.partido =@"Movimiento Ciudadano";
                newCandidato.photoRoute =@"gallardo.jpg";
                newCandidato.biografiaRoute =@"biografiaGallardo";
                newCandidato.propuestaRoute =@"propuestaGallardo";
                
                break;
            }
            case 6:
            {
                newCandidato.name = @"Carlos Barbazán Martínez";
                newCandidato.partido =@"Movimiento Ciudadano";
                newCandidato.photoRoute =@"barbasan.jpg";
                newCandidato.biografiaRoute =@"biografiaBaarbasan";
                newCandidato.propuestaRoute =@"propuestaBarbasan";
                
                break;
            }
            case 7:
            {
                newCandidato.name = @"Gerardo Galván Pinto";
                newCandidato.partido =@"Movimiento Ciudadano";
                newCandidato.photoRoute =@"galvan.jpg";
                newCandidato.biografiaRoute =@"biografiaGalvan";
                newCandidato.propuestaRoute =@"propuestaGalvan";
                
                break;
            }
                
            default:
                break;
        }
        [_candidatoPartido addObject:newCandidato];
    }
}

- (IBAction)changueView:(id)sender {
    
    [self performSegueWithIdentifier:@"segueToVoto" sender:self];
}


@end
