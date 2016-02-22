//
//  SecondViewController.h
//  GenresMusic
//
//  Created by Nguyen Van Anh Tuan on 11/27/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Track;
@protocol SongTableViewControllerDelegate <NSObject>

- (void)insertItem:(Track *)item;

@end

#import "GenresTableViewController.h"

@interface SongTableViewController : UITableViewController<GenresTableViewControllerDelegate>

@property (nonatomic, strong) id <SongTableViewControllerDelegate> delegate;

//coredata property
//@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

