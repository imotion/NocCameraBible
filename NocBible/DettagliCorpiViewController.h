//
//  DettagliCorpiViewController.h
//  Storyboard
//
//  Created by Massimiliano Gorreri on 17/02/14.
//  Copyright (c) 2014 Daniela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Articolo.h"
#import "iCarousel.h"
#import "cElencoArticoli.h"
#import "AVFoundation/AVAudioPlayer.h"
#import <MessageUI/MessageUI.h> 
#import "Social/Social.h"

@interface DettagliCorpiViewController : UIViewController<iCarouselDataSource,MFMailComposeViewControllerDelegate, iCarouselDelegate>
{
    Articolo *articolo;
    long pos;
    NSURL *url;
}

-(void) setArticolo:(Articolo *)art;
-(void) setPos:(long)pos;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnFacebook;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnTwitter;

@property (weak, nonatomic) IBOutlet UILabel *nomeProdotto;
@property (weak, nonatomic) IBOutlet UIImageView *Immagine;
@property (strong,nonatomic) NSString *tipo;

@property (weak, nonatomic) IBOutlet UILabel *anno;
@property (weak, nonatomic) IBOutlet UILabel *matricola;
@property (weak, nonatomic) IBOutlet UILabel *finitura;
@property (weak, nonatomic) IBOutlet UILabel *obiettivo;
@property (weak, nonatomic) IBOutlet UILabel *innesto;
@property (weak, nonatomic) IBOutlet UILabel *otturatore;
@property (weak, nonatomic) IBOutlet UILabel *levadicarica;
@property (weak, nonatomic) IBOutlet UILabel *mirino;
@property (weak, nonatomic) IBOutlet UILabel *tempi;
@property (weak, nonatomic) IBOutlet UILabel *autoscatto;
@property (weak, nonatomic) IBOutlet UILabel *occhielli;
@property (weak, nonatomic) IBOutlet UITextView *note;
@property (strong,nonatomic) cElencoArticoli *articoli;


@property (weak, nonatomic) IBOutlet UILabel *txAnno;
@property (weak, nonatomic) IBOutlet UILabel *txNumMatricola;
@property (weak, nonatomic) IBOutlet UILabel *txFinitura;
@property (weak, nonatomic) IBOutlet UILabel *txObiettivo;
@property (weak, nonatomic) IBOutlet UILabel *txInnestro;
@property (weak, nonatomic) IBOutlet UILabel *txOtturatore;
@property (weak, nonatomic) IBOutlet UILabel *txLevaCarica;
@property (weak, nonatomic) IBOutlet UILabel *txMirino;
@property (weak, nonatomic) IBOutlet UILabel *txTempi;
@property (weak, nonatomic) IBOutlet UILabel *txAutoscatto;
@property (weak, nonatomic) IBOutlet UILabel *txOcchielli;


@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UIButton *btnAvanti;
@property (weak, nonatomic) IBOutlet UIButton *btnIndietro;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@end
