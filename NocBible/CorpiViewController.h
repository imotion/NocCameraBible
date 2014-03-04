//
//  CorpiViewController.h
//  Storyboard
//
//  Created by Daniela on 11/02/14.
//  Copyright (c) 2014 Daniela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "cElencoArticoli.h"
#import "Articolo.h"
#import "cGestService.h"
#import "DettagliCorpiViewController.h"
#import "SchedaCell.h"
@interface CorpiViewController : UIViewController <UITableViewDataSource,MBProgressHUDDelegate,UISearchDisplayDelegate, UISearchBarDelegate,UITableViewDelegate>
{
    MBProgressHUD *HUD;
    Articolo *articolo;
    NSArray *searchResults;
    BOOL isSearching;
    cElencoArticoli *filteredList;
    long ipos;
}

- (void)loadElenco;
- (void)RefreshView;

@property (weak, nonatomic) IBOutlet UITableView *tableTestDb;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellDbRow;
@property (weak, nonatomic) IBOutlet UILabel *lbProductName;
@property(weak,nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) cElencoArticoli *articoli;
@property (strong,nonatomic) NSString *tipo;

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@end
