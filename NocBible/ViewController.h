//
//  ViewController.h
//  NocBible
//
//  Created by Massimiliano Gorreri on 26/09/13.
//  Copyright (c) 2013 Massimiliano Gorreri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIWebViewDelegate,UIAlertViewDelegate> {
    UIWebView* mWebView;
}


@property (retain, nonatomic) IBOutlet UIWebView *webView;

@end
