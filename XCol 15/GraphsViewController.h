//
//  GraphsViewController.h
//  XCol 15
//
//  Created by HECTOR ALFONSO on 29/04/15.
//  Copyright (c) 2015 SHDH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GraphsViewControllerDelegate;

@interface GraphsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableViewcontroller;
@property (nonatomic,strong) NSMutableArray *candidatos;

@property (nonatomic, assign) id<GraphsViewControllerDelegate> delegate;
@end

@protocol GraphsViewControllerDelegate <NSObject>
@required
- (void)graphsViewControllerDidRequestBeingClosed:(GraphsViewController *)viewController;

@end