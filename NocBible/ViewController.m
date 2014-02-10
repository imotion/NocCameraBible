//
//  ViewController.m
//  NocPuzzle
//
//  Created by Massimiliano Gorreri on 04/10/13.
//  Copyright (c) 2013 I.Motion s.r.l. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"
#import "AVFoundation/AVAudioPlayer.h"
#import <UIKit/UIKit.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize webView = mWebView;
BOOL isload;
UIAlertView *messageload;


- (void)viewDidLoad
{
    [super viewDidLoad];

    isload=TRUE;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.view sizeToFit];
    Reachability *reachability = [Reachability reachabilityWithHostName:@"test.newoldcamera.it"];
    
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"NocBible"
                                                          message:@"Nessuna connesione internet disponibile."
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message  show];
        
        isload=FALSE;
    }
    else if (remoteHostStatus == ReachableViaWiFi) {
        //wifi connection found
    }
    else if (remoteHostStatus == ReachableViaWWAN) {
        //EDGE or 3G connection found
    }
    if(isload) {
        self.webView.delegate = self;
        self.webView.scalesPageToFit = YES;
        self.webView.autoresizesSubviews = YES;
        self.webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        NSBundle *bundle=[NSBundle mainBundle];
        NSString *filePath = [bundle pathForResource:@"NocBible" ofType: @"html"];
        
        NSURL *fileUrl = [NSURL URLWithString: [filePath lastPathComponent]
                           relativeToURL: [NSURL fileURLWithPath: [filePath stringByDeletingLastPathComponent]
                                                     isDirectory: YES]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:fileUrl];
     //   [self.webView loadHTMLString: @"NocBible"HTMLString
     //                        baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath] isDirectory:YES]];
        [self.webView loadRequest:request];
    }
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
}
- (void)webViewDidStartLoad:(UIWebView *)thisWebView
{
    messageload = [[UIAlertView alloc] initWithTitle:@"NocBible"
                                             message:@"Pagina in caricamento..."
                                            delegate:nil
                                   cancelButtonTitle:nil
                                   otherButtonTitles:nil];
    NSString *fileaudio=[[NSBundle mainBundle] pathForResource:@"M8CLICK" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:fileaudio];
    _audioPlayer = [[AVAudioPlayer alloc]
                                  initWithContentsOfURL:url
                                  error:nil];
    NSURLRequest *pagina=[thisWebView request];
    NSURL *urlpagina=[pagina URL];
    NSString *nomepagina=[urlpagina absoluteString];
    if([nomepagina rangeOfString:@"corpo"].location!=NSNotFound)
        [_audioPlayer play];
    else
        if([nomepagina rangeOfString:@"obiettivo"].location!=NSNotFound)
            [_audioPlayer play];
    [messageload show];
}

- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    exit(0);
}

-(void)webViewDidFinishLoad:(UIWebView *)thisWebView
{
    [messageload dismissWithClickedButtonIndex:0 animated:YES];
    
    NSString *jsFile = @"NocBible.js";
    NSString *jsFilePath = [[NSBundle mainBundle] pathForResource:[jsFile stringByDeletingPathExtension] ofType:[jsFile pathExtension]];
    NSURL *jsURL = [NSURL fileURLWithPath:jsFilePath];
    NSString *javascriptCode = [NSString stringWithContentsOfFile:jsURL.path encoding:NSUTF8StringEncoding error:nil];
    [mWebView stringByEvaluatingJavaScriptFromString:javascriptCode];
    
    jsFile = @"klass.min.js";
    jsFilePath = [[NSBundle mainBundle] pathForResource:[jsFile stringByDeletingPathExtension] ofType:[jsFile pathExtension]];
    jsURL = [NSURL fileURLWithPath:jsFilePath];
    javascriptCode = [NSString stringWithContentsOfFile:jsURL.path encoding:NSUTF8StringEncoding error:nil];
    [mWebView stringByEvaluatingJavaScriptFromString:javascriptCode];
    
    jsFile = @"code.photoswipe.jquery-3.0.5.min.js";
    jsFilePath = [[NSBundle mainBundle] pathForResource:[jsFile stringByDeletingPathExtension] ofType:[jsFile pathExtension]];
    jsURL = [NSURL fileURLWithPath:jsFilePath];
    javascriptCode = [NSString stringWithContentsOfFile:jsURL.path encoding:NSUTF8StringEncoding error:nil];
    [mWebView stringByEvaluatingJavaScriptFromString:javascriptCode];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
