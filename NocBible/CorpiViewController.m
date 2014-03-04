//
//  CorpiViewController.m
//  Storyboard
//
//  Created by Daniela on 11/02/14.
//  Copyright (c) 2014 Daniela. All rights reserved.
//

#import "CorpiViewController.h"


@implementation CorpiViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    isSearching=NO;
    filteredList = [[cElencoArticoli alloc] init];
    if([_tipo isEqual:@"CO"])
       _navItem.title=@"Corpi";
    if([_tipo isEqual:@"OB"])
        _navItem.Title=@"Obiettivi";
    [self RefreshView];
}

- (void)filterListForSearchText:(NSString *)searchText
{
    [filteredList removeAllObjects];
    filteredList=[_articoli find:searchText];
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    //When the user taps the search bar, this means that the controller will begin searching.
    isSearching = YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    //When the user taps the Cancel Button, or anywhere aside from the view.
    isSearching = NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterListForSearchText:[self.searchDisplayController.searchBar text]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterListForSearchText:searchString]; // The method we made in step 7
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(void)RefreshView
{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
  
        HUD.labelText=@"Caricamento in corso....";
    
    [HUD showWhileExecuting:@selector(loadElenco) onTarget:self withObject:nil animated:YES];
}

-(void)loadElenco
{
    if(_articoli==nil) {
        _articoli=[[cElencoArticoli alloc]init];
        if([_tipo isEqual:@"CO"])
            [_articoli LeggeCorpi];
        if([_tipo isEqual:@"OB"])
            [_articoli LeggeObbiettivi];
    }
    [_tableTestDb reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isSearching)
        return [filteredList getCountArticoli];
    else
        return [_articoli getCountArticoli];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CorpiIdentifier = @"CorpiCell";
    
    SchedaCell *cell = [_table dequeueReusableCellWithIdentifier:CorpiIdentifier];
    
    if (cell == nil) {
        cell = [[SchedaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CorpiIdentifier];
    }
    articolo=nil;
    if(isSearching && [filteredList getCountArticoli]) {
         articolo = [filteredList getArticolo:indexPath.row];
    } else
        articolo=[_articoli getArticolo:indexPath.row];
    cell.modello.text = articolo.modello;
    cell.thumbnail.image = [UIImage imageWithData:articolo.image0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ipos=indexPath.row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIDevice *device=[UIDevice  currentDevice];
    NSRange nameRange = [device.model rangeOfString:@"iphone" options:NSCaseInsensitiveSearch];
    if (nameRange.location != NSNotFound)
        return 40;
    else
        return 88;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    NSIndexPath *path = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"segueSchedaCorpo"]) {
        DettagliCorpiViewController *pvc = [segue destinationViewController];
        if(self.searchDisplayController.active) {
            articolo=[filteredList getArticolo:path.row];
            pvc.articoli=filteredList;
        } else {
            path = [_table indexPathForSelectedRow];
            articolo=[_articoli getArticolo:path.row];
            pvc.articoli=_articoli;
        }
        [pvc setArticolo:articolo];
        pvc.tipo=_tipo;
        [pvc setPos:path.row];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
