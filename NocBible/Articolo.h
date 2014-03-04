//
//  Articolo.h
//  TestDB
//
//  Created by Massimiliano Gorreri on 14/02/14.
//  Copyright (c) 2014 I.Motion s.r.l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Articolo : NSObject {
    
}

@property (strong, nonatomic) NSString *immagine;
@property (strong, nonatomic) NSString *codice;
@property (strong, nonatomic) NSString *modello;
@property (strong, nonatomic) NSString *ricerca;
@property (strong, nonatomic) NSData *image0;

@property (strong, nonatomic) NSString *annoriferimento;
@property (strong, nonatomic) NSString *numeromatricola;
@property (strong, nonatomic) NSString *finitura;
@property (strong, nonatomic) NSString *obiettivo;
@property (strong, nonatomic) NSString *innesto;
@property (strong, nonatomic) NSString *otturatore;
@property (strong, nonatomic) NSString *levacarica;
@property (strong, nonatomic) NSString *mirino;
@property (strong, nonatomic) NSString *autoscatto;
@property (strong, nonatomic) NSString *occhielli;
@property (strong, nonatomic) NSString *notesito;
@property (strong, nonatomic) NSString *tempi;

@property (strong, nonatomic) NSString *lughezzafocale;
@property (strong, nonatomic) NSString *aperturadiaframma;
@property (strong, nonatomic) NSString *numerolenti;
@property (strong, nonatomic) NSString *angolocampo;
@property (strong, nonatomic) NSString *distanzaminima;
@property (strong, nonatomic) NSString *montatura;
@property (strong, nonatomic) NSString *filtri;
@property (strong, nonatomic) NSString *paraluce;
@property (strong, nonatomic) NSString *codice6bit;

@property (strong, nonatomic) NSMutableArray *immagini;

- (NSData *)loadImage:(NSString *)img imageData:(NSData *)imageData;
- (BOOL)findarticolo:(NSString *)searchText;
- (BOOL)callArticolo:(NSString *)codice;
- (BOOL)caricaImmagini;
@end
