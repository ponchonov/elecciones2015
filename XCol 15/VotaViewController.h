//
//  VotaViewController.h
//  XCol 15
//
//  Created by HECTOR ALFONSO on 25/04/15.
//  Copyright (c) 2015 SHDH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Candidato.h"
@protocol VotaViewControllerDelegate;

@interface VotaViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *votosTableView;
@property (nonatomic,strong) NSArray *candidatos;
@property (nonatomic,assign) id<VotaViewControllerDelegate> delegate;
@end

@protocol VotaViewControllerDelegate <NSObject>
@required
- (void)VotaViewControllerDidRequestBeingClosed:(VotaViewController *)viewController;

@end
