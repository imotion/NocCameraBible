//
//  PuzzleGameIPhone.m
//  NocBible
//
//  Created by Daniela on 05/03/14.
//  Copyright (c) 2014 Massimiliano Gorreri. All rights reserved.
//

#import "PuzzleGameIPhone.h"

@interface PuzzleGameIPhone ()

@end

@implementation PuzzleGameIPhone

@synthesize webView = mWebView;

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
	
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.autoresizesSubviews = YES;
    self.webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    NSBundle *bundle=[NSBundle mainBundle];
    NSString *filePath = [bundle pathForResource:@"NocGame2" ofType: @"html"];
    
    NSURL *fileUrl = [NSURL URLWithString: [filePath lastPathComponent]
                            relativeToURL: [NSURL fileURLWithPath: [filePath stringByDeletingLastPathComponent]
                                                      isDirectory: YES]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:fileUrl];
    [self.webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
    
}

-(void)webViewDidFinishLoad:(UIWebView *)thisWebView
{
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

@end
