//
//  SSTableViewController.m
//  ExampleTable
//
//  Created by Jonathan Hersh on 6/8/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSTableViewController.h"
#import <SSDataSources.h>

@interface SSTableViewController ()
- (void) addRow;
- (void) toggleEditing;

- (void) updateBarButtonItems;
@end

@implementation SSTableViewController {
    SSArrayDataSource *dataSource;
}

- (instancetype)init {
    if( ( self = [self initWithStyle:UITableViewStylePlain] ) ) {
        self.title = @"Simple Table";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateBarButtonItems];
    
    NSMutableArray *items = [NSMutableArray array];
    
    for( NSUInteger i = 0; i < 5; i++ )
        [items addObject:@( arc4random_uniform( 10000 ) )];
    
    dataSource = [[SSArrayDataSource alloc] initWithItems:items];
    dataSource.rowAnimation = UITableViewRowAnimationRight;
    dataSource.tableActionBlock = ^BOOL(SSCellActionType action,
                                        UITableView *tableView,
                                        NSIndexPath *indexPath) {
        
        // we allow both moving and deleting.
        // You could instead do something like
        // return (action == SSCellActionTypeMove);
        // to only allow moving and disallow deleting.
        
        return YES;
    };
    dataSource.tableDeletionBlock = ^(SSArrayDataSource *aDataSource,
                                      UITableView *tableView,
                                      NSIndexPath *indexPath) {
        
        [aDataSource removeItemAtIndex:(NSUInteger)indexPath.row];
    };
    dataSource.cellConfigureBlock = ^(SSBaseTableCell *cell, 
                                      NSNumber *number, 
                                      UITableView *tableView,
                                      NSIndexPath *ip ) {
        cell.textLabel.text = [number stringValue];
    };
    dataSource.tableView = self.tableView;
}

#pragma mark - actions

- (void)addRow {
    [dataSource appendItem:@( arc4random_uniform( 10000 ) )];
}

- (void)toggleEditing {
    [self.tableView setEditing:![self.tableView isEditing]
                      animated:YES];
    
    [self updateBarButtonItems];
}

- (void)updateBarButtonItems {
    self.navigationItem.rightBarButtonItems = @[
        [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
         target:self
         action:@selector(addRow)],
        [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:( [self.tableView isEditing]
                                      ? UIBarButtonSystemItemDone
                                      : UIBarButtonSystemItemEdit )
         target:self
         action:@selector(toggleEditing)]
    ];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *item = [dataSource itemAtIndexPath:indexPath];
    
    NSLog(@"selected item %@", item);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
