//
//  HomeViewController.m
//  Storyboard
//
//  Created by Daniela on 10/02/14.
//  Copyright (c) 2014 Daniela. All rights reserved.
//

#import "HomeViewController.h"
#import "Reachability.h"

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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Upload/Offile"]];
   if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
       Reachability *reachability = [Reachability reachabilityWithHostName:@"test.newoldcamera.it"];
       
       NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
       
       if(remoteHostStatus == NotReachable) {
           UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"NocBible"
                                                             message:@"Nessuna connesione internet disponibile.La connessione internet è necessario per consulare Noc Camera Bible."
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
           [message  show];
          
       }

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
