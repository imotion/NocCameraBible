//
//  cGestService.m
//  TestWebService
//
//  Created by Max Max on 23/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cGestService.h"

@implementation cGestService

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (NSString *)callMethodArray:(NSString *)metodo parametri:(NSMutableArray *)parametri
                        valori:(NSMutableArray *)valori
{
    NSString *urlmetodo=[NSString stringWithFormat:@"http://%@/%@",KSITE,metodo];
    methodresult=[NSString stringWithFormat:@"%@Result",metodo];
    NSMutableString *soapMsg = [NSMutableString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                         "<soap:Body>"
                         "<%@ xmlns=\"http://%@/\">",metodo,KSITE];
    
    for(int idx=0;idx<[parametri count];idx++)
        soapMsg=[NSMutableString stringWithFormat:@"%@<%@>%@</%@>",soapMsg,[parametri objectAtIndex:idx],[valori objectAtIndex:idx],[parametri objectAtIndex:idx]];
    [soapMsg appendFormat:@"</%@></soap:Body></soap:Envelope>",metodo];
    NSString *strurl=[NSString stringWithFormat:@"http://%@/%@",KSITE,KSERVICE];
    NSURL *url = [NSURL URLWithString:strurl];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength =[NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:urlmetodo forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];  
    
    NSURLResponse* response;
    NSError* error = nil;  
    
    @try {
        soapdata=[NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
    } @catch (NSException *ex) {
        return nil;
    }
    if(soapdata) {
        parser=[[NSXMLParser alloc] initWithData:soapdata];
        [parser setDelegate: self];
        [parser setShouldProcessNamespaces:YES];
        [parser parse];
    }
    soapResults=[self textToHtml:soapResults];
    return soapResults;
    
}
- (NSString *)callMethodParam:(NSString *)metodo parametro:(NSString *)parametro
                       valore:(NSString *)valore;
{
    NSString *urlmetodo=[NSString stringWithFormat:@"http://%@/%@",KSITE,metodo];
    methodresult=[NSString stringWithFormat:@"%@Result",metodo];
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                         "<soap:Body>"
                         "<%@ xmlns=\"http://%@/\">"
                         "<%@>%@</%@>"
                         "</%@>"
                         "</soap:Body>"
                         "</soap:Envelope>",metodo,KSITE,parametro,valore,parametro,metodo];
    NSString *strurl=[NSString stringWithFormat:@"http://%@/%@",KSITE,KSERVICE];
    NSURL *url = [NSURL URLWithString:strurl];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength =[NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:urlmetodo forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];  
    
    NSURLResponse* response;
    NSError* error = nil;  
    
    @try {
        soapdata=[NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
    } @catch (NSException *ex) {
        return nil;
    }
   soapResults = [[NSMutableString alloc] initWithData:soapdata encoding:NSUTF8StringEncoding];

    if(soapdata) {
        parser=[[NSXMLParser alloc] initWithData:soapdata];
        [parser setDelegate: self];
        [parser setShouldProcessNamespaces:YES];
        [parser parse];
    }
    soapResults=[self textToHtml:soapResults];
    return soapResults;
} //NSData

- (NSString *) callMethod:(NSString *)metodo
{
    NSString *urlmetodo=[NSString stringWithFormat:@"http://%@/%@",KSITE,metodo];
    methodresult=[NSString stringWithFormat:@"%@Result",metodo];
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                         "<soap:Body>"
                         "<%@ xmlns=\"http://%@/\">"
                         "</%@>"
                         "</soap:Body>"
                         "</soap:Envelope>",metodo,KSITE,metodo];
    NSString *strurl=[NSString stringWithFormat:@"http://%@/%@",KSITE,KSERVICE];
    NSURL *url = [NSURL URLWithString:strurl];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength =[NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:urlmetodo forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];  
    
    NSURLResponse* response;
    NSError* error = nil;  
    
    @try {
        soapdata=[NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
    } @catch (NSException *ex) {
        return nil;
    }
    soapResults = [[NSMutableString alloc] initWithData:soapdata encoding:NSUTF8StringEncoding];
   if(soapdata) {
      parser=[[NSXMLParser alloc] initWithData:soapdata];
      [parser setDelegate: self];
      [parser setShouldProcessNamespaces:YES];
      [parser parse];
    }
    
    soapResults=[self textToHtml:soapResults];
    return soapResults;
} //NSData

- (NSString *) getElencoMarche
{
    NSString *result;
    result=[self callMethod:@"ElencoMarche"];
    return result;
} //getElencoMarche

- (NSMutableString*)textToHtml:(NSMutableString*)htmlString {
    NSString *stringa;
    
    stringa = [htmlString stringByReplacingOccurrencesOfString:@"&amp;"  withString:@"&"];
    stringa = [stringa stringByReplacingOccurrencesOfString:@"&lt;"  withString:@"<"];
    stringa = [stringa stringByReplacingOccurrencesOfString:@"&gt;"  withString:@">"];
    stringa = [stringa stringByReplacingOccurrencesOfString:@"""" withString:@"&quot;"];    
    stringa = [stringa stringByReplacingOccurrencesOfString:@"'"  withString:@"&#039;"];
    stringa = [stringa stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    stringa = [stringa stringByReplacingOccurrencesOfString:@"&nbsp" withString:@"\t"];
  	
    return (NSMutableString *)stringa;
} //textToHtml

-(void) parser:(NSXMLParser *) parser 
didStartElement:(NSString *) elementName 
  namespaceURI:(NSString *) namespaceURI 
 qualifiedName:(NSString *) qName
    attributes:(NSDictionary *) attributeDict {
  
  if([elementName rangeOfString:methodresult].location != NSNotFound)
  {
    if (!soapResults)
    {
      soapResults = [[NSMutableString alloc] init];
    }
    elementfound = YES;
  }
} //soapResults

-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
  if (elementfound)
  {
    [soapResults appendString: string];
  }
} //foundCharactes

-(void)parser:(NSXMLParser *)parser 
didEndElement:(NSString *)elementName 
 namespaceURI:(NSString *)namespaceURI 
qualifiedName:(NSString *)qName
{
   if([elementName rangeOfString:methodresult].location != NSNotFound) {   
    elementfound = FALSE;

  }
} //didEndElement

- (void)dealloc {
    
} //dealloc

@end
