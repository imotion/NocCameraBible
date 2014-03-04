//
//  HomeViewController.m
//  Storyboard
//
//  Created by Daniela on 10/02/14.
//  Copyright (c) 2014 Daniela. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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

- (IBAction)AggiornaDatabase:(id)sender {
    [self SvuotaDB];
    
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"NocBible"];
    [alert setMessage:@"Vuoi scaricare i database di NocBible, potrai navigare senza la connesione internet ?"];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"Si"];
    [alert addButtonWithTitle:@"No"];
    [alert show];
}
- (IBAction)Aggiorna:(id)sender {
    [self SvuotaDB];

    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"NocBible"];
    [alert setMessage:@"Vuoi scaricare i database di NocBible, potrai navigare senza la connesione internet ?"];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CorpiViewController *pvc = [segue destinationViewController];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    if ([segue.identifier isEqualToString:@"segueCorpi"]) {
        if(pvc.articoli==nil)
            pvc.articoli=[[cElencoArticoli alloc]init];
        pvc.tipo=@"CO";
        pvc.articoli=nil;
    }
    if ([segue.identifier isEqualToString:@"segueObiettivi"]) {
        if(pvc.articoli==nil)
            pvc.articoli=[[cElencoArticoli alloc]init];
        pvc.tipo=@"OB";
        pvc.articoli=nil;
    }
}

@end
