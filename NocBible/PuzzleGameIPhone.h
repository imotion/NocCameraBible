//
//  PuzzleGameIPhone.h
//  NocBible
//
//  Created by Daniela on 05/03/14.
//  Copyright (c) 2014 Massimiliano Gorreri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PuzzleGameIPhone :UIViewController<UIWebViewDelegate,UIAlertViewDelegate> {
    UIWebView* mWebView;
}


@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end
