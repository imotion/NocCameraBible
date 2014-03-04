
//  Preferenze.m
//  NocBible
//
//  Created by Massimiliano Gorreri on 04/03/14.
//  Copyright (c) 2014 Massimiliano Gorreri. All rights reserved.
//

#import "Preferenze.h"
#import "cElencoArticoli.h"
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (IBAction)AggiornaDB:(id)sender {
    [self SvuotaDB];
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
        [HUD showWhileExecuting:@selector(AggiornaDB) onTarget:self withObject:nil animated:YES];
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

-(void)AggiornaDB
{
    cElencoArticoli *_articoli=[[cElencoArticoli alloc]init];
    [_articoli LeggeCorpi:YES];
    [_articoli LeggeObbiettivi:YES];
}

@end
