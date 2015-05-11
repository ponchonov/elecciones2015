//
//  candidato.h
//  XCol 15
//
//  Created by HECTOR ALFONSO on 25/04/15.
//  Copyright (c) 2015 SHDH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Candidato : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *partido;
@property (nonatomic, strong) NSString *photoRoute;
@property (nonatomic, strong) NSString *biografiaRoute;
@property (nonatomic, strong) NSString *propuestaRoute;
@property (nonatomic, strong) NSString *porcentaje;

@end
