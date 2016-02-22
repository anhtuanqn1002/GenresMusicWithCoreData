//
//  GenresTableViewController.m
//  GenresMusic
//
//  Created by Nguyen Van Anh Tuan on 11/27/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import "GenresTableViewController.h"
#import "GenresAndSongTableViewCell.h"
//#import "TrackModel.h"
#import "Track.h"
#import "DatabaseManager.h"

@interface GenresTableViewController ()<GenresAndSongTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *genresListItems;

@property (nonatomic, strong) UIBarButtonItem *addButton;

@end

@implementation GenresTableViewController

#pragma mark - initWithNibName: declared database in here

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.genresListItems = [[NSMutableArray alloc] init];
//        self.genresListItems = [[DatabaseManager shareInstance] getListTrack:@"Track" forType:0];
        self.genresListItems = [[DatabaseManager shareInstance] getListTrack:@"Track" forType:0];
    }
    return self;
}

#pragma mark - viewDidLoad and didReceiveMemoryWarning

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"GenresAndSongTableViewCell" bundle:nil] forCellReuseIdentifier:@"GenresAndSongTableViewCell"];
    
    self.addButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addGenres@2x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(addButtonEvent:)];
    self.navigationItem.rightBarButtonItem = self.addButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Add button event

- (void)addButtonEvent:(id)sender {
    NSLog(@"Add event");
    [self createAlertViewControllerWithKey:1 indexPath:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.genresListItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GenresAndSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GenresAndSongTableViewCell" forIndexPath:indexPath];
    
    Track *temp = [self.genresListItems objectAtIndex:[indexPath row]];
    [cell changeTitle:[temp title]];
    
    cell.delegate = self;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

#pragma mark - custom height for row

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76;
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Track *item = [self.genresListItems objectAtIndex:indexPath.row];
        [self.genresListItems removeObject:item];
        //delete the row in the database
        if ([[DatabaseManager shareInstance] deleteRowOfTable:@"Track" withModel:item]) {
            NSLog(@"Delete the row is SUCCESSFUL!");
        } else {
            NSLog(@"Delete the row is FAILED!");
        }
//
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - Selected event
//Edit item
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self createAlertViewControllerWithKey:2 indexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Add and edit items

- (void)createAlertViewControllerWithKey:(NSInteger)key indexPath:(NSIndexPath *)indexPath {
    NSString *titleAlert = @"Add Track";
    NSString *titleTrack = @"";
    if (key == 2) {
        titleAlert = @"Edit Track";
        titleTrack = [[self.genresListItems objectAtIndex:indexPath.row] title];
    }
    //show alert
    UIAlertController *alertAddItem = [UIAlertController
                                       alertControllerWithTitle:titleAlert
                                       message:@"Enter Track Name"
                                       preferredStyle:UIAlertControllerStyleAlert];
    
    //add text field into alertView
    [alertAddItem addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeAlphabet;
        textField.text = titleTrack;
    }];
    
    //    __weak UITableViewController *weakSelf = self;
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action){
                                                   UITextField *textField = [alertAddItem.textFields firstObject];
                                                   [self addAndEditTrackItem:textField forKey:key indexPath:indexPath];
                                               }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertAddItem addAction:ok];
    [alertAddItem addAction:cancel];
    
    [self presentViewController:alertAddItem animated:YES completion:nil];
}

#pragma mark - Add/Edit item at track list method

- (void)addAndEditTrackItem:(UITextField *)textField forKey:(NSInteger)key indexPath:(NSIndexPath *)indexPath {
    //if key == 1 this case is add
    //else this case is edit
    if (key == 1) {
        //insert the item into the database
        if ([[DatabaseManager shareInstance] insertRowOfTable:@"Track" withTile:textField.text andType:0]) {
            NSLog(@"Insertion is SUCCESSFUL!");
        } else {
            NSLog(@"Insertion is FAILED!");
        }

#pragma mark - Importance: Need update list track again because we need update ID
//We have to reload data because we need update the ID's the new item (if it doesn't update, we will wrong when using updateRowOfTable method of DatabaseManager)
        self.genresListItems = [[DatabaseManager shareInstance] getListTrack:@"Track" forType:0];
        
        [self.tableView beginUpdates];
        NSIndexPath *indexPathNew = [NSIndexPath indexPathForRow:[self.genresListItems count]-1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPathNew] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    } else {
        Track *item = [self.genresListItems objectAtIndex:indexPath.row];
        item.title = textField.text;
        item.type = @(0);
        
        //update row into database
        if ([[DatabaseManager shareInstance] updateRowOfTable:@"Track" withModel:item]) {
            NSLog(@"Update is SUCCESSFUL!");
        } else {
            NSLog(@"Update is FAILED!");
        }
        
        [self.genresListItems replaceObjectAtIndex:indexPath.row withObject:item];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Moving cell to song list

- (void)moveTo:(GenresAndSongTableViewCell *)cell {
    //delete item from list genres and add item at list song
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    Track *item = [self.genresListItems objectAtIndex:index.row];
    [self.genresListItems removeObject:item];
    [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
    
    //move data to list song
    item.type = @(1);
    
    //update row into database
    if ([[DatabaseManager shareInstance] updateRowOfTable:@"Track" withModel:item]) {
        NSLog(@"Update is SUCCESSFUL!");
    } else {
        NSLog(@"Update is FAILED!");
    }
    
    [self.delegate insertItem:item];
}

- (void)insertItem:(Track *)item {
    NSLog(@"%ld - %@", item.type.integerValue, item.title);
    [self.genresListItems addObject:item];
    [self.tableView beginUpdates];
    NSIndexPath *indexPathNew = [NSIndexPath indexPathForRow:[self.genresListItems count]-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPathNew] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

@end
