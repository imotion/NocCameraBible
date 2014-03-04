//
//  PuzzleGame.h
//  Storyboard
//
//  Created by Massimiliano Gorreri on 25/02/14.
//  Copyright (c) 2014 Daniela. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PuzzleGame : UIViewController<UIWebViewDelegate,UIAlertViewDelegate> {
    UIWebView* mWebView;
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end
