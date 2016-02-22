//
//  GenresAndSongTableViewCell.m
//  GenresMusic
//
//  Created by Nguyen Van Anh Tuan on 11/30/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import "GenresAndSongTableViewCell.h"
#import "GenresTableViewController.h"
#import "SongTableViewController.h"

@interface GenresAndSongTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation GenresAndSongTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changeTitle:(NSString *)title {
    self.name.text = title;
}

- (NSString *)getName {
    return self.name.text;
}

- (IBAction)moveTo:(id)sender {
    [self.delegate moveTo:self];
}
@end
