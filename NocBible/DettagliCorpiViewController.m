//
//  DettagliCorpiViewController.m
//  Storyboard
//
//  Created by Massimiliano Gorreri on 17/02/14.
//  Copyright (c) 2014 Daniela. All rights reserved.
//

#import "DettagliCorpiViewController.h"

@interface DettagliCorpiViewController ()

@end

@implementation DettagliCorpiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _carousel.type=iCarouselTypeCoverFlow2;
    _carousel.pagingEnabled = YES;
    NSString *fileaudio=[[NSBundle mainBundle] pathForResource:@"M8CLICK" ofType:@"mp3"];
    url = [NSURL fileURLWithPath:fileaudio];
    _audioPlayer = [[AVAudioPlayer alloc]
                    initWithContentsOfURL:url
                    error:nil];
    [self setPage];
    [_audioPlayer play];
	
}

-(void) setPage;
{
    if([_tipo isEqual:@"CO"]) {
        _navItem.title=articolo.modello;
        [_nomeProdotto setText:articolo.modello];
        [_anno setText:articolo.annoriferimento];
        [_matricola setText:articolo.numeromatricola];
        [_finitura setText:articolo.finitura];
        [_obiettivo setText:articolo.obiettivo];
        [_innesto setText:articolo.innesto];
        [_otturatore setText:articolo.otturatore];
        [_levadicarica setText:articolo.levacarica];
        [_mirino setText:articolo.mirino];
        [_tempi setText:articolo.tempi];
        [_autoscatto setText:articolo.autoscatto];
        [_occhielli setText:articolo.occhielli] ;
        [_note setText:articolo.notesito];
    }
    if([_tipo isEqual:@"OB"]) {
        _navItem.title=articolo.modello;
        [_nomeProdotto setText:articolo.modello];
        [_anno setText:articolo.annoriferimento];
        [_matricola setText:articolo.numeromatricola];
        [_finitura setText:articolo.lughezzafocale];
        [_txFinitura setText:@"Lunghezza Focale"];
        [_obiettivo setText:articolo.aperturadiaframma];
        [_txObiettivo setText:@"Apertura Diaframma"];
        [_innesto setText:articolo.numerolenti];
        [_txInnestro setText:@"Numero Lenti"];
        [_otturatore setText:articolo.angolocampo];
        [_txOtturatore setText:@"Angolo di Campo"];
        [_levadicarica setText:articolo.distanzaminima];
        [_txLevaCarica setText:@"Distanza Minima"];
        [_mirino setText:articolo.montatura];
        [_txMirino setText:@"Montatura"];
        [_tempi setText:articolo.filtri];
        [_txTempi setText:@"Filtri"];
        [_autoscatto setText:articolo.paraluce];
        [_txAutoscatto setText:@"Paraluce"];
        [_occhielli setText:articolo.codice6bit];
        [_txOcchielli setText:@"Codice 6bit"];
        [_note setText:articolo.notesito];
    }

    long page=[articolo.immagini count];
    [self.pageControl setNumberOfPages:page];
    [_btnIndietro setEnabled:true];
     [_btnAvanti setEnabled:true];
    if(pos==0)
        [_btnIndietro setEnabled:false];
    if(pos==[_articoli getCountArticoli]-1)
        [_btnAvanti setEnabled:false];
    [self.view setNeedsDisplay];
    [self.carousel reloadData];
    [_carousel setCurrentItemIndex:0];
    
    if(![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        [_btnFacebook setEnabled:NO];
    if(![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        [_btnTwitter setEnabled:NO];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   
}
- (IBAction)Indietro:(id)sender {
    pos=pos-1;
    if(pos<0)
        pos=[_articoli getCountArticoli]-1;
    articolo=[_articoli getArticolo:pos];
    [articolo callArticolo:articolo.codice];
    [UIView transitionWithView: self.view
                      duration: 0.35f
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^(void)
     {
         
     }
                    completion: ^(BOOL isFinished)
     {
         
     }];
    _audioPlayer = [[AVAudioPlayer alloc]
                    initWithContentsOfURL:url
                    error:nil];
    [self setPage];
    [_audioPlayer play];
}

- (IBAction)faceBook:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
       
        
        [controller setInitialText:[self composeBodyTxt]];
        
        
        NSData *imageData;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        for(NSString *immagine in articolo.immagini)
        {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",immagine]];
            imageData=[NSData dataWithContentsOfFile:fullPath];
            [controller addImage:[UIImage imageWithData:imageData]];
        }
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
}

- (IBAction)google:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheetOBJ = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString *twittertxt=[NSString stringWithFormat:@"Noc Bible consiglia %@",articolo.modello];
        [tweetSheetOBJ setInitialText:twittertxt];
        
        NSData *imageData;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        for(NSString *immagine in articolo.immagini)
        {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",immagine]];
            imageData=[NSData dataWithContentsOfFile:fullPath];
            [tweetSheetOBJ addImage:[UIImage imageWithData:imageData]];
        }

        [self presentViewController:tweetSheetOBJ animated:YES completion:nil];
    }
}

- (NSString *)composeBodyTxt
{
    NSString *messageBody=@"";
    if([_tipo isEqual:@"CO"]) {
        NSString *messageBody1 = [NSString stringWithFormat:@"%@ \nAnno : %@\nMatricola : %@\nFinitura :%@",articolo.modello,articolo.annoriferimento,articolo.numeromatricola,articolo.finitura]; //
        NSString *messageBody2 = [NSString stringWithFormat:@"\nObiettivo : %@\nInnesto : %@\nOtturatore : %@\nLeva di carica : %@",articolo.obiettivo,articolo.innesto,articolo.otturatore,articolo.levacarica]; //
        NSString *messageBody3 = [NSString stringWithFormat:@"\nMirino : %@\nTempi : %@\nAutoscatto : %@\nOcchielli : %@",articolo.mirino,articolo.tempi,articolo.autoscatto,articolo.occhielli]; //
        NSString *notesito = [NSString stringWithFormat:@"\nNote :\n%@",articolo.notesito];
        messageBody=[NSString stringWithFormat:@"%@ %@ %@ %@",messageBody1,messageBody2,messageBody3,notesito];
    } else {
        NSString *messageBody1 = [NSString stringWithFormat:@"%@ \nAnno : %@\nMatricola : %@\nLunghezza Focale :%@",articolo.modello,articolo.annoriferimento,articolo.numeromatricola,articolo.lughezzafocale]; //
        NSString *messageBody2 = [NSString stringWithFormat:@"\nDiaframma : %@\nNumero Lenti : %@\nAngolo Campo : %@\nDistanza Minima : %@",articolo.aperturadiaframma,articolo.numerolenti,articolo.angolocampo,articolo.distanzaminima]; //
        NSString *messageBody3 = [NSString stringWithFormat:@"\nMontatura : %@\nFiltri : %@\nParaluce : %@\nCodice 6bit : %@",articolo.montatura,articolo.filtri
                                  ,articolo.paraluce,articolo.codice6bit]; //
        NSString *notesito = [NSString stringWithFormat:@"\nNote :\n%@",articolo.notesito];
        messageBody=[NSString stringWithFormat:@"%@ %@ %@ %@",messageBody1,messageBody2,messageBody3,notesito];

    }
   
    return messageBody;
}

- (NSString *)composeBody
{
    NSString *messageBody=@"";
    if([_tipo isEqual:@"CO"]) {
        NSString *messageBody1 = [NSString stringWithFormat:@"<h1>%@</h1>Anno : %@<br>Matricola : %@<br>Finitura :%@",articolo.modello,articolo.annoriferimento,articolo.numeromatricola,articolo.finitura]; //
        NSString *messageBody2 = [NSString stringWithFormat:@"Obiettivo : %@<br>Innesto : %@<br>Otturatore : %@<br>Leva di carica : %@",articolo.obiettivo,articolo.innesto,articolo.otturatore,articolo.levacarica]; //
        NSString *messageBody3 = [NSString stringWithFormat:@"Mirino : %@<br>Tempi : %@<br>Autoscatto : %@<br>Occhielli : %@",articolo.mirino,articolo.tempi,articolo.autoscatto,articolo.occhielli]; //
        NSString *notesito = [NSString stringWithFormat:@"Note :<br>%@",articolo.notesito];
        messageBody=[NSString stringWithFormat:@"%@ %@ %@ %@",messageBody1,messageBody2,messageBody3,notesito];
    } else {
        NSString *messageBody1 = [NSString stringWithFormat:@"<h1>%@</h1> <br>Anno : %@<br>Matricola : %@<br>Lunghezza Focale :%@",articolo.modello,articolo.annoriferimento,articolo.numeromatricola,articolo.lughezzafocale]; //
        NSString *messageBody2 = [NSString stringWithFormat:@"<br>Diaframma : %@<br>Numero Lenti : %@<br>Angolo Campo : %@<br>Distanza Minima : %@",articolo.aperturadiaframma,articolo.numerolenti,articolo.angolocampo,articolo.distanzaminima]; //
        NSString *messageBody3 = [NSString stringWithFormat:@"<br>Montatura : %@<br>Filtri : %@<br>Paraluce : %@<br>Codice 6bit : %@",articolo.montatura,articolo.filtri
                                  ,articolo.paraluce,articolo.codice6bit]; //
        NSString *notesito = [NSString stringWithFormat:@"<br>Note :<br>%@",articolo.notesito];
        messageBody=[NSString stringWithFormat:@"%@ %@ %@ %@",messageBody1,messageBody2,messageBody3,notesito];
        
    }
    return messageBody;
}

- (IBAction)share:(id)sender {
    // Email Subject
    NSString *emailTitle = [NSString stringWithFormat:@"NocBible Consiglia %@",articolo.modello];
    // Email Content

    NSString *messageBody=[self composeBody];
    // To address
   NSArray *toRecipents = [NSArray arrayWithObject:@""];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    
   
    NSData *imageData;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    for(NSString *immagine in articolo.immagini)
    {
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",immagine]];
        imageData=[NSData dataWithContentsOfFile:fullPath];
        [mc addAttachmentData:imageData mimeType:@"image/jpeg" fileName:fullPath];
    }
    
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:YES];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)SavePhoto:(id)sender {
    
   
   
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"NocBible"];
    [alert setMessage:@"Vuoi salvare le immagini nel tuo foto album ?"];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"Si"];
    [alert addButtonWithTitle:@"No"];
    [alert show];
}

-(void)SaveinPhotoAlbum
{
    NSData *imageData;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    for(NSString *immagine in articolo.immagini)
    {
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",immagine]];
        imageData=[NSData dataWithContentsOfFile:fullPath];
        UIImage *newImage=[[UIImage alloc] initWithData:imageData];
        UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
    }
    [[[UIAlertView alloc] initWithTitle:@"NocBible"
                                message:[NSString stringWithFormat:@"Sono state salvate le foto nel tuo album"]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex==0)
        [self SaveinPhotoAlbum];
}
- (IBAction)Avanti:(id)sender {
    pos=pos+1;
    if(pos==[_articoli getCountArticoli])
        pos=0;
    articolo=[_articoli getArticolo:pos];
    [articolo callArticolo:articolo.codice];
    [UIView transitionWithView: self.view
                      duration: 0.35f
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^(void)
     {
        
     }
                    completion: ^(BOOL isFinished)
     {
         
     }];
    _audioPlayer = [[AVAudioPlayer alloc]
                    initWithContentsOfURL:url
                    error:nil];
    [self setPage];
    [_audioPlayer play];

}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setArticolo:(Articolo *)art
{
    articolo=art;
    [articolo callArticolo:articolo.codice];
}

-(void)setPos:(long)ipos
{
    pos=ipos;
}
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    long page=[articolo.immagini count];
    [self.pageControl setNumberOfPages:page];
    return page;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    return nil;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    [self.pageControl setCurrentPage:carousel.currentItemIndex];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2.0) {
            UIGraphicsBeginImageContextWithOptions(newSize, YES, 2.0);
        } else {
            UIGraphicsBeginImageContext(newSize);
        }
    } else {
        UIGraphicsBeginImageContext(newSize);
    }
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UIImageView *vista;
    NSData *dataimage;
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:self.carousel.bounds];
        dataimage=[articolo loadImage:articolo.immagini[index] imageData:dataimage];
        vista=((UIImageView *)view);
        [vista setImage:[UIImage imageWithData:dataimage] ];
        vista.image =[self imageWithImage:vista.image scaledToSize:self.carousel.bounds.size];
        view.contentMode = UIViewContentModeScaleAspectFit;
    }
    return view;
}

@end
