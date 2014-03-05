
//  Preferenze.m
//  NocBible
//
//  Created by Massimiliano Gorreri on 04/03/14.
//  Copyright (c) 2014 Massimiliano Gorreri. All rights reserved.
//

#import "Preferenze.h"
#import "cElencoArticoli.h"
#import "Reachability.h"
@interface Preferenze ()

@end

@implementation Preferenze

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)checkInternet
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"test.newoldcamera.it"];
    
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable)
        return NO;
        
    return YES;
}

-(BOOL)offLineMode
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Upload/Offile"]];
     if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath])
         return NO;
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([self offLineMode])
        [_warning setText:@"Modalità offline attiva"];
    else
        [_warning setText:@""];
    if(![self checkInternet]) {
        [_btnoffline setEnabled:NO];
        [_btnAggiona setEnabled:NO];
    } else {
        [_btnoffline setEnabled:YES];
        [_btnAggiona setEnabled:YES];
    }
	// Do any additional setup after loading the view.
}
- (IBAction)AggiornaDB:(id)sender {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText=@"Aggiornamento database in conso....";
    [HUD showWhileExecuting:@selector(AggiornaDb) onTarget:self withObject:nil animated:YES];
}

-(void)AggiornaDb
{
    cElencoArticoli *_articoli=[[cElencoArticoli alloc]init];
    [self SvuotaDB];
    [_articoli LeggeCorpi];
    [_articoli LeggeObbiettivi];
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"NocBible"];
    [alert setMessage:@"Il Database di NocBible è stato aggiornato !"];
    [alert setTag:1];
    [alert addButtonWithTitle:@"Ok"];
    [alert show];
}

- (IBAction)ScaricaDB:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"NocBible"];
    [alert setMessage:@"Vuoi scaricare i database di NocBible, potrai consulatare NocBible senza la connesione internet. Attenzione l'operazione richiede diverso tempo."];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"Si"];
    [alert addButtonWithTitle:@"No"];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    MBProgressHUD *HUD;
    if(buttonIndex==0) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText=@"Download del database in corso....";
        [HUD showWhileExecuting:@selector(ScaricaDB) onTarget:self withObject:nil animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Chiudi:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)SvuotaDB
{
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Upload"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
    
    NSArray *directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dataPath error:&error];
    if (error == nil) {
        for (NSString *path in directoryContents) {
            NSString *fullPath = [dataPath stringByAppendingPathComponent:path];
            BOOL removeSuccess = [[NSFileManager defaultManager] removeItemAtPath:fullPath error:&error];
            if (!removeSuccess) {
                NSString *frase=[NSString stringWithFormat:@"Impossibile eliminare %@",path];
                NSLog(@"%@",frase);
            }
        }
    } else {
        
    }
}

-(void)ScaricaDB
{
    cElencoArticoli *_articoli=[[cElencoArticoli alloc]init];
    NSString *offline=[NSString  stringWithFormat:@"Offline mode"];
    [_articoli LeggeCorpi:YES];
    [_articoli LeggeObbiettivi:YES];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Upload/Offile"]];
    [[offline dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fullPath atomically:NO];
}

@end
