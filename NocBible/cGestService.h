//
//  cGestService.h
//  TestWebService
//
//  Created by Max Max on 23/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString * const KSITE = @"test.newoldcamera.it";
static NSString * const KSERVICE = @"nocbible.asmx";

@interface cGestService : NSObject <NSXMLParserDelegate> {
  NSXMLParser     *parser;          // parser XML  
  NSData          *soapdata;        // data del soap
  NSMutableString *soapResults;     // risualto del webservice
  BOOL            elementfound;     // indica che l'elemento e' stato trovato
  NSString        *methodresult;    // indica il risultato del metodo
}
  - (NSString *)getElencoMarche;
  - (NSMutableString *)textToHtml:(NSMutableString *)htmlString;
  - (NSString *)callMethod:(NSString *)metodo;
  - (NSString *)callMethodParam:(NSString *)metodo parametro:(NSString *)parametro
                       valore:(NSString *)valore;
-   (NSString *)callMethodArray:(NSString *)metodo parametri:(NSMutableArray *)parametri
                         valori:(NSMutableArray *)valori;
@end

