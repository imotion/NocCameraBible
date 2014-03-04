//
//  cElencoArticoli.h
//  TestDB
//
//  Created by Massimiliano Gorreri on 14/02/14.
//  Copyright (c) 2014 I.Motion s.r.l. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"
#import "Articolo.h"

@interface cElencoArticoli : NSObject {
    NSMutableArray *Elenco;
    NSMutableArray *FilterElenco;
}

- (void)removeAllObjects;
- (void)LeggeCorpi;
- (void)LeggeCorpi:(BOOL)offline;
- (void)LeggeObbiettivi;
- (void)LeggeObbiettivi:(BOOL)offline;
- (void)addArticolo:(Articolo *)articolo;

@property (strong, nonatomic) NSString *tipo;

-(Articolo *)getArticolo:(long) index;
-(long)getCountArticoli;
- (cElencoArticoli *)find:(NSString *)searchtext;

@end
