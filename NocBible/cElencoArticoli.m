//
//  cElencoArticoli.m
//  TestDB
//
//  Created by Massimiliano Gorreri on 14/02/14.
//  Copyright (c) 2014 I.Motion s.r.l. All rights reserved.
//

#import "cElencoArticoli.h"
#import "cGestService.h"


@implementation cElencoArticoli


- (id)init
{
    self = [super init];
    if (self) {
        Elenco=[[NSMutableArray alloc] init];
        FilterElenco=[[NSMutableArray alloc]init];
    }
    _tipo=@"CO";
    return self;
}

-(void)removeAllObjects
{
    [Elenco removeAllObjects];
}

- (TBXMLElement *) traverseElement:(TBXMLElement *)element nodename:(NSString *)nodename {
    
    TBXMLElement *elemento=nil;
    do {
        // Display the name of the element
        NSLog(@"%@",[TBXML elementName:element]);
        NSString *elementname=[TBXML elementName:element];
        if([elementname isEqualToString:nodename])
            return element;
        // Obtain first attribute from element
        TBXMLAttribute * attribute = element->firstAttribute;
        
        // if attribute is valid
        while (attribute) {
        // Obtain the next attribute
            attribute = attribute->next;
        }
        
        // if the element has child elements, process them
        if (element->firstChild)
            elemento=[self traverseElement:element->firstChild nodename:nodename];
        
        // Obtain next sibling element
    } while ((element = element->nextSibling));
    return elemento;
}

- (Articolo *)getArticolo:(long)index {
    return [Elenco objectAtIndex:index];
}
- (long)getCountArticoli {
    return [Elenco count];
}

- (void)addArticolo:(Articolo *)articolo
{
    [Elenco addObject:articolo];
}

- (cElencoArticoli *)find:(NSString *)searchtext
{
    cElencoArticoli *filtro=[[cElencoArticoli alloc]init];
    [filtro removeAllObjects];
    for(Articolo *art in Elenco) {
        if([art findarticolo:searchtext]==YES)
            [filtro addArticolo:art];
    }
    return filtro;
}

- (NSString *)readFileXml:(NSString *)Comando
{
    cGestService *service=[[cGestService alloc]init];
    NSString *filexml;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Upload"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
    
    NSString *fullPath =nil;
    
    fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Upload/%@",Comando]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        filexml = [NSString stringWithContentsOfFile:fullPath
                                                      encoding:NSUTF8StringEncoding
                                                         error:NULL];
        if([filexml length]==0) {
            filexml=[[NSString alloc] initWithString:[service callMethod:Comando]];
            if(!filexml)
                return @"";
            [[filexml dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fullPath atomically:NO];
        }
        return filexml;
    } else {
        filexml=[[NSString alloc] initWithString:[service callMethod:Comando]];
        if(!filexml)
            return @"";
         [[filexml dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fullPath atomically:NO];
        return filexml;
    }
}

-(void)ScaricaImmagini
{
    for(Articolo *art in Elenco) {
        [art callArticolo:art.codice];
        [art caricaImmagini];
    }
}

-(void)LeggeCorpi
{
    [self LeggeCorpi:NO];
}

-(void)LeggeObbiettivi
{
    [self LeggeObbiettivi:NO];
}

- (void)LeggeCorpi:(BOOL)offline;
{
    NSData *parsedata;
   
    NSString *risultato=[[NSString alloc] initWithString:[self readFileXml:@"ElencoCorpi"]];
    if(!risultato) {
        return;
    }
    
    parsedata=[risultato dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    TBXML *tbxml=[TBXML newTBXMLWithXMLData:parsedata error:&error];
    TBXMLElement *root=tbxml.rootXMLElement;
    
    if(!root) return;
    TBXMLElement *articolo=[self traverseElement:tbxml.rootXMLElement nodename:@"Modello"];
  
    while(articolo!=nil)
    {
        
        Articolo *_prod=[[Articolo  alloc] init];
        
        TBXMLElement * desc = [TBXML childElementNamed:@"Codice" parentElement:articolo];
        if (desc != nil)
            _prod.codice = [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
        
        desc = [TBXML childElementNamed:@"oModello" parentElement:articolo];
        if (desc != nil)
            _prod.modello =[[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
        
        desc = [TBXML childElementNamed:@"Ricerca" parentElement:articolo];
        if (desc != nil)
            _prod.ricerca = [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
        
        desc = [TBXML childElementNamed:@"Thumbnail" parentElement:articolo];
        if (desc != nil) {
             _prod.immagine = [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
            _prod.image0=[_prod loadImage:_prod.immagine imageData:_prod.image0];
        }
        @try {
            [Elenco addObject:_prod];
        } @catch(NSException *exception) {}
        articolo=[TBXML nextSiblingNamed:@"Modello" searchFromElement:articolo];
    }
    if(offline==YES)
        if([Elenco count]>0)
            [self ScaricaImmagini];
}


- (void)LeggeObbiettivi:(BOOL)offline
{
    NSData *parsedata;
    
    NSString *risultato=[[NSString alloc] initWithString:[self readFileXml:@"ElencoObiettivi"]];
    if(!risultato) {
        return;
    }
    
    parsedata=[risultato dataUsingEncoding:NSUTF8StringEncoding];
    
    
    TBXML *tbxml=[TBXML newTBXMLWithXMLData:parsedata error:nil];
    TBXMLElement *root=tbxml.rootXMLElement;
    
    if(!root) return;
    TBXMLElement *articolo=[self traverseElement:tbxml.rootXMLElement nodename:@"Modello"];
    
    while(articolo!=nil)
    {
        
        Articolo *_prod=[[Articolo  alloc] init];
        
        TBXMLElement * desc = [TBXML childElementNamed:@"Codice" parentElement:articolo];
        if (desc != nil)
            _prod.codice = [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
        
        desc = [TBXML childElementNamed:@"oModello" parentElement:articolo];
        if (desc != nil)
            _prod.modello =[[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
        
        desc = [TBXML childElementNamed:@"Ricerca" parentElement:articolo];
        if (desc != nil)
            _prod.ricerca = [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
        
        desc = [TBXML childElementNamed:@"Thumbnail" parentElement:articolo];
        if (desc != nil) {
            _prod.immagine = [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
            _prod.image0=[_prod loadImage:_prod.immagine imageData:_prod.image0];
        }
        
        [Elenco addObject:_prod];
        articolo=[TBXML nextSiblingNamed:@"Modello" searchFromElement:articolo];
    }
    if(offline==YES)
        if([Elenco count]>0)
            [self ScaricaImmagini];
}

@end
