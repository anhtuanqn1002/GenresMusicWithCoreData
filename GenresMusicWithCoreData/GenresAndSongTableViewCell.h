//
//  GenresAndSongTableViewCell.h
//  GenresMusic
//
//  Created by Nguyen Van Anh Tuan on 11/30/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GenresAndSongTableViewCell;

@protocol GenresAndSongTableViewCellDelegate <NSObject>

- (void)moveTo:(GenresAndSongTableViewCell *)cell;

@end

@interface GenresAndSongTableViewCell : UITableViewCell

- (void)changeTitle:(NSString *)title;
- (NSString *)getName;

@property (nonatomic, strong) id <GenresAndSongTableViewCellDelegate> delegate;


@end
