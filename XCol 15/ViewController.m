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
#import "GraphsViewController.h"

@interface ViewController (){
    NSIndexPath *selectedIndexPath;
    __weak IBOutlet UIButton *buttonAction;
}
@property (nonatomic, strong) NSMutableArray *candidatoPartido;
@property (nonatomic,strong) NSString *datosGuardados;
@end

@implementation ViewController
@synthesize candidatosTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Elecciones Colima";
    self.view.backgroundColor = [UIColor colorWithRed:0.843 green:0.0745 blue:0.5372 alpha:1.0];
    _candidatoPartido = [[NSMutableArray alloc]init];
    [self llenar];
 
    // Do any additional setup after loading the view, typically from a nib.
    candidatosTableView.dataSource =self;
    candidatosTableView.delegate=self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
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
    [candidatosTableView reloadData];
    // to reload selected cell
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 109.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _candidatoPartido.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString * identifier = @"CellImage";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
    Candidato *detalle = _candidatoPartido[indexPath.row];
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    recipeImageView.contentMode = UIViewContentModeScaleToFill;
    recipeImageView.image = [UIImage imageNamed:detalle.photoRoute];
    UILabel *recipeNameLabel = (UILabel *)[cell viewWithTag:102];
    recipeNameLabel.text = detalle.name;
    UILabel *recipeNameLabel2 = (UILabel *)[cell viewWithTag:101];
    recipeNameLabel2.text = detalle.partido;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
  
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
        if ([segue.identifier isEqualToString:@"segueToGraphs"]){
            GraphsViewController *graphs =[segue destinationViewController];
            graphs.candidatos = _candidatoPartido;
            
        }
        else{
            DetailViewController *detailViewController = [segue destinationViewController];
            detailViewController.candidato= _candidatoPartido;
            detailViewController.selected = selectedIndexPath.row;
        }
    }
}

-(void)llenar{
    
    for (int i=0;i<=7;i++){
        Candidato *newCandidato = [Candidato new];
        switch (i) {
            case 0:
            {
                newCandidato.name = @"José Ignacio Peralta";
                newCandidato.partido =@"PRI";
                newCandidato.photoRoute =@"peralta.jpg";
                newCandidato.biografiaRoute =@"biografiaNacho";
                newCandidato.propuestaRoute =@"propuestaNacho";
                newCandidato.porcentaje = @"0%";
                
                break;
            }
            case 1:
            {
                newCandidato.name = @"Jorge Luis Preciado";
                newCandidato.partido =@"PAN";
                newCandidato.photoRoute =@"preciado.jpg";
                newCandidato.biografiaRoute =@"biografiaPreciado";
                newCandidato.propuestaRoute =@"propuestaPreciado";
                  newCandidato.porcentaje = @"0%";
                break;
            }
            case 2:
            {
                newCandidato.name = @"Martha Zepeda";
                newCandidato.partido =@"PRD";
                newCandidato.photoRoute =@"zepeda.jpg";
                newCandidato.biografiaRoute =@"biografiaZepeda";
                newCandidato.propuestaRoute =@"propuestaZepeda";
                  newCandidato.porcentaje = @"0%";
                break;
            }
            case 3:
            {
                newCandidato.name = @"Leoncio Morán";
                newCandidato.partido =@"Movimiento Ciudadano";
                newCandidato.photoRoute =@"moran.jpg";
                newCandidato.biografiaRoute =@"biografiaMoran";
                newCandidato.propuestaRoute =@"propuestaMoran";
                  newCandidato.porcentaje = @"0%";
                
                break;
            }
            case 4:
            {
                newCandidato.name = @"David Munro";
                newCandidato.partido =@"PT";
                newCandidato.photoRoute =@"munro.jpg";
                newCandidato.biografiaRoute =@"biografiaMunro";
                newCandidato.propuestaRoute =@"propuestaMunro";
                  newCandidato.porcentaje = @"0%";
                
                break;
            }
            case 5:
            {
                newCandidato.name = @"José Francisco Gallardo";
                newCandidato.partido =@"Morena";
                newCandidato.photoRoute =@"gallardo.jpg";
                newCandidato.biografiaRoute =@"biografiaGallardo";
                newCandidato.propuestaRoute =@"propuestaGallardo";
                  newCandidato.porcentaje = @"0%";
                
                break;
            }
            case 6:
            {
                newCandidato.name = @"Carlos Barbazán Martínez";
                newCandidato.partido =@"Partido Humanista";
                newCandidato.photoRoute =@"barbasan.jpg";
                newCandidato.biografiaRoute =@"biografiaBarbasan";
                newCandidato.propuestaRoute =@"propuestaBarbasan";
                  newCandidato.porcentaje = @"0%";
                
                break;
            }
            case 7:
            {
                newCandidato.name = @"Gerardo Galván Pinto";
                newCandidato.partido =@"Encuentro Social";
                newCandidato.photoRoute =@"galvan.jpg";
                newCandidato.biografiaRoute =@"biografiaGalvan";
                newCandidato.propuestaRoute =@"propuestaGalvan";
                  newCandidato.porcentaje = @"0%";
                
                break;
            }
                
            default:
                break;
        }
        [_candidatoPartido addObject:newCandidato];
    }

}

- (IBAction)changueView:(id)sender {
    
    if([_datosGuardados isEqualToString:@"YES"]){
        [self performSegueWithIdentifier:@"segueToGraphs" sender:self];
       
    }
    else
    {
            [self performSegueWithIdentifier:@"segueToVoto" sender:self];
    }

}


@end
