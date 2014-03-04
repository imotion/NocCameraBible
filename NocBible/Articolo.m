//
//  Articolo.m
//  TestDB
//
//  Created by Massimiliano Gorreri on 14/02/14.
//  Copyright (c) 2014 I.Motion s.r.l. All rights reserved.
//

#import "Articolo.h"
#import "cGestService.h"
#import "TBXML.h"
@implementation Articolo

- (NSData *)loadImage:(NSString *)img imageData:(NSData *)imageData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Upload"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
    
    NSString *fullPath =nil;
    
    fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",img]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath])
    {
        imageData=[NSData dataWithContentsOfFile:fullPath];
    } else {
        NSString *urlstring=[[NSMutableString alloc] initWithFormat:@"http://test.newoldcamera.it/%@",img];
        NSURL *url=[NSURL URLWithString:urlstring];
        if(url==nil)
            return nil;
        NSError* error = nil;
        @try {
            imageData=[[NSData alloc] initWithContentsOfURL:url options:NSUncachedRead error:&error];
        }
        @catch (NSException *exception) {
            return nil;
        } @finally {
       
        }
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
    }
    return imageData;
}

- (BOOL)findarticolo:(NSString *)searchText
{
    NSString *ricerca=[NSString stringWithFormat:@"%@ %@",_modello,_notesito];
    NSRange nameRange = [ricerca rangeOfString:searchText options:NSCaseInsensitiveSearch];
    if (nameRange.location != NSNotFound)
        return YES;
    return NO;
}

- (TBXMLElement *) traverseElement:(TBXMLElement *)element nodename:(NSString *)nodename {
    
    TBXMLElement *elemento=nil;
    do {
        // Display the name of the element
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

- (BOOL)caricaImmagini
{
    NSData *parsedata;
    
    _immagini=[[NSMutableArray alloc]init];
    
    NSString *risultato=[self readFileXml:_codice suffix:@"img"];
    if(!risultato) {
        return NO;
    }
    
    parsedata=[risultato dataUsingEncoding:NSUTF8StringEncoding];
    
    TBXML *tbxml=[TBXML newTBXMLWithXMLData:parsedata error:nil];
    TBXMLElement *root=tbxml.rootXMLElement;
    
    if(!root) return NO;
    
    TBXMLElement *articolo=[self traverseElement:tbxml.rootXMLElement nodename:@"Immagine"];
    
    while(articolo!=nil)
    {
        NSString *immagine;
        
        TBXMLElement * desc = [TBXML childElementNamed:@"FileNameRel" parentElement:articolo];
        if (desc != nil)
            immagine= [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
        @try {
            NSData *imageData;
            [_immagini addObject:immagine];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
            
            NSString *urlstring=[[NSMutableString alloc] initWithFormat:@"http://test.newoldcamera.it/%@",immagine];
            NSURL *url=[NSURL URLWithString:urlstring];
            NSString* fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",immagine]];
            if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath])
            {
                if(url==nil)
                    return NO;
                NSError* error = nil;
                @try {
                    imageData=[[NSData alloc] initWithContentsOfURL:url options:NSUncachedRead error:&error];
                }
                @catch (NSException *exception) {
                    return NO;
                } @finally {
                
                }
                NSFileManager *fileManager = [NSFileManager defaultManager];
                [fileManager createFileAtPath:fullPath contents:imageData attributes:nil];
            }
        }@catch(NSException *exception) {}
        articolo=[TBXML nextSiblingNamed:@"Immagine" searchFromElement:articolo];
    }
    return YES;
}

- (NSString *)readFileXml:(NSString *)Comando suffix:(NSString *)suffix
{
    cGestService *service=[[cGestService alloc]init];
    NSString *filexml;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Upload"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
    
    NSString *fullPath =nil;
    
    fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Upload/%@%@",Comando,suffix]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        filexml = [NSString stringWithContentsOfFile:fullPath
                                            encoding:NSUTF8StringEncoding
                                               error:NULL];
        if([filexml length]==0) {
            if([suffix isEqual:@"art"])
                filexml=[[NSString alloc] initWithString:[service callMethodParam:@"ArticoloO" parametro:@"codice" valore:Comando]];
            else
                filexml=[[NSString alloc] initWithString:[service callMethodParam:@"GalleriaImmaginiO" parametro:@"codice" valore:Comando]];
            if(!filexml)
                return @"";
            [[filexml dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fullPath atomically:NO];
        }
        return filexml;
    } else {
        if([suffix isEqual:@"art"])
            filexml=[[NSString alloc] initWithString:[service callMethodParam:@"ArticoloO" parametro:@"codice" valore:Comando]];
        else
            filexml=[[NSString alloc] initWithString:[service callMethodParam:@"GalleriaImmaginiO" parametro:@"codice" valore:Comando]];
        if(!filexml)
            return @"";
        [[filexml dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fullPath atomically:NO];
        return filexml;
    }
}

- (BOOL)callArticolo:(NSString *)codice {
    NSData *parsedata;
    
    NSString *risultato=[self readFileXml:codice suffix:@"art"];
    if(!risultato) {
        return NO;
    }
    
    parsedata=[risultato dataUsingEncoding:NSUTF8StringEncoding];
    
    TBXML *tbxml=[TBXML newTBXMLWithXMLData:parsedata error:nil];
    TBXMLElement *root=tbxml.rootXMLElement;
    
    if(!root) return NO;

    TBXMLElement * desc = [self traverseElement:tbxml.rootXMLElement nodename:@"Codice"];
    if (desc != nil)
        _codice = [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
    
    desc = [self traverseElement:tbxml.rootXMLElement nodename:@"Modello"];
    if (desc != nil)
        _modello = [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
   
    desc = [self traverseElement:tbxml.rootXMLElement nodename:@"AnnoRiferimento"];
    if (desc != nil)
       _annoriferimento = [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
    
    desc = [self traverseElement:tbxml.rootXMLElement nodename:@"NumeroMatricola"];
    if (desc != nil)
        _numeromatricola = [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
    
    desc = [self traverseElement:tbxml.rootXMLElement nodename:@"Finitura"];
    if (desc != nil)
        _finitura = [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];

    desc = [self traverseElement:tbxml.rootXMLElement nodename:@"Obiettivo"];
    if (desc != nil)
        _obiettivo = [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
    
    desc = [self traverseElement:tbxml.rootXMLElement nodename:@"Innesto"];
    if (desc != nil)
        _innesto = [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
    
    desc = [self traverseElement:tbxml.rootXMLElement nodename:@"Otturatore"];
    if (desc != nil)
        _otturatore = [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];

    desc = [self traverseElement:tbxml.rootXMLElement nodename:@"LevaCarica"];
    if (desc != nil)
        _levacarica = [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];

    desc = [self traverseElement:tbxml.rootXMLElement nodename:@"Mirino"];
    if (desc != nil)
        _mirino = [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
    
    desc = [self traverseElement:tbxml.rootXMLElement nodename:@"Tempi"];
    if (desc != nil)
        _tempi = [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
    
    desc = [self traverseElement:tbxml.rootXMLElement nodename:@"Autoscatto"];
    if (desc != nil)
        _autoscatto = [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
    
    desc = [self traverseElement:tbxml.rootXMLElement nodename:@"Occhielli"];
    if (desc != nil)
        _occhielli = [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];

    desc = [self traverseElement:tbxml.rootXMLElement nodename:@"LunghezzaFocale"];
    if (desc != nil)
        _lughezzafocale= [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];

    desc = [self traverseElement:tbxml.rootXMLElement nodename:@"AperturaDiaframma"];
    if (desc != nil)
        _aperturadiaframma= [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
    
    desc = [self traverseElement:tbxml.rootXMLElement nodename:@"NumeroLenti"];
    if (desc != nil)
        _numerolenti= [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
    
    desc = [self traverseElement:tbxml.rootXMLElement nodename:@"AngoloCampo"];
    if (desc != nil)
        _angolocampo= [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
    
    desc = [self traverseElement:tbxml.rootXMLElement nodename:@"DistanzaMinima"];
    if (desc != nil)
        _distanzaminima= [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
    
    desc = [self traverseElement:tbxml.rootXMLElement nodename:@"Montatura"];
    if (desc != nil)
        _montatura= [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
    
    desc = [self traverseElement:tbxml.rootXMLElement nodename:@"Filtri"];
    if (desc != nil)
        _filtri= [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];

    desc = [self traverseElement:tbxml.rootXMLElement nodename:@"Paraluce"];
    if (desc != nil)
        _paraluce= [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
    
    desc = [self traverseElement:tbxml.rootXMLElement nodename:@"Codice6bit"];
    if (desc != nil)
        _codice6bit= [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
    
    desc = [self traverseElement:tbxml.rootXMLElement nodename:@"NoteSito"];
    if (desc != nil)
        _notesito= [[NSString alloc] initWithFormat:@"%@", [TBXML textForElement:desc]];
    
    [self caricaImmagini];
    return YES;
}
@end

