//
//  SecondViewController.m
//  GenresMusic
//
//  Created by Nguyen Van Anh Tuan on 11/27/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import "SongTableViewController.h"
#import "GenresAndSongTableViewCell.h"
#import "GenresTableViewController.h"
#import "Track.h"
#import "DatabaseManager.h"

@interface SongTableViewController ()<GenresAndSongTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *songListItems;
@property (nonatomic, strong) UIBarButtonItem *addButton;

@end

@implementation SongTableViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.songListItems = [[NSMutableArray alloc] init];
        self.songListItems = [[DatabaseManager shareInstance] getListTrack:@"Track" forType:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"GenresAndSongTableViewCell" bundle:nil] forCellReuseIdentifier:@"GenresAndSongTableViewCell"];
    
    //add button
    self.addButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addToSong@2x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(addButtonEvent:)];
    self.navigationItem.rightBarButtonItem = self.addButton;
}

- (void)addButtonEvent:(id)sender {
    [self createAlertViewControllerWithKey:1 indexPath:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.songListItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GenresAndSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GenresAndSongTableViewCell" forIndexPath:indexPath];
    Track *item = [self.songListItems objectAtIndex:[indexPath row]];
    [cell changeTitle:item.title];
    
    cell.delegate = self;
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Track *item = [self.songListItems objectAtIndex:indexPath.row];
        [self.songListItems removeObject:item];
        //delete the row in the database
        if ([[DatabaseManager shareInstance] deleteRowOfTable:@"Track" withModel:item]) {
            NSLog(@"Delete the row is SUCCESSFUL!");
        } else {
            NSLog(@"Delete the row is FAILED!");
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 76;
}

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
        titleTrack = [[self.songListItems objectAtIndex:indexPath.row] title];
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
        if ([[DatabaseManager shareInstance] insertRowOfTable:@"Track" withTile:textField.text andType:1]) {
            NSLog(@"Insert the item SUCCESS!");
        } else {
            NSLog(@"FAILED! Please checking insert process!");
        }
        
#pragma mark - Importance: Need update list track again because we need update ID
//We have to reload data because we need update the ID's the new item (if it doesn't update, we will wrong when using updateRowOfTable method of DatabaseManager)
        self.songListItems = [[DatabaseManager shareInstance] getListTrack:@"Track" forType:1];
        
        [self.tableView beginUpdates];
        NSIndexPath *indexPathNew = [NSIndexPath indexPathForRow:[self.songListItems count]-1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPathNew] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    } else {
        Track *item = [self.songListItems objectAtIndex:indexPath.row];
        item.title = textField.text;
        item.type = @(1);
        
        //update the row into database
        if ([[DatabaseManager shareInstance] updateRowOfTable:@"Track" withModel:item]) {
            NSLog(@"Update is SUCCESSFUL!");
        } else {
            NSLog(@"Update is FAILED!");
        }
        
        [self.songListItems replaceObjectAtIndex:indexPath.row withObject:item];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Move item to Genres list

- (void)moveTo:(GenresAndSongTableViewCell *)cell {
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    Track *item = [self.songListItems objectAtIndex:index.row];
    [self.songListItems removeObject:item];
    [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
    
    item.type = @(0);
    
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
    [self.songListItems addObject:item];
    [self.tableView beginUpdates];
    NSIndexPath *indexPathNew = [NSIndexPath indexPathForRow:[self.songListItems count]-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPathNew] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

@end
