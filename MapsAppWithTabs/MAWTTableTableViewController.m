//
//  MAWTTableTableViewController.m
//  MapsAppWithTabs
//
//  Created by Марина Звягина on 11.05.17.
//  Copyright © 2017 Zvyagina Marina. All rights reserved.
//

#import "MAWTTableTableViewController.h"
#import "MAWViewManager.h"
#import "MAWATMList.h"
@import MapKit;

@interface MAWTTableTableViewController ()
@property (nonatomic, strong) MAWATMList * atms;
@property (nonatomic, strong) id<MAWViewManager> viewManager;
@end

@implementation MAWTTableTableViewController

-(instancetype)initWithMapViewManager:(id<MAWViewManager>) manager {
    self = [super init];
    if (self) {
        self.viewManager = manager;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.atms = [self.viewManager getCurrentAtms];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable)
                                                 name:@"locationChanged" object:nil];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)reloadTable {
    self.atms = [self.viewManager getCurrentAtms];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.atms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.textLabel.text = self.atms[indexPath.row].name;
    cell.detailTextLabel.text = self.atms[indexPath.row].address;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}
@end
