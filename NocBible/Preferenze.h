//
//  Preferenze.h
//  NocBible
//
//  Created by Massimiliano Gorreri on 04/03/14.
//  Copyright (c) 2014 Massimiliano Gorreri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface Preferenze : UIViewController <MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnoffline;
@property (weak, nonatomic) IBOutlet UIButton *btnAggiona;
@property (weak, nonatomic) IBOutlet UILabel *warning;

@end
