//
//  TrackModel.h
//  GenresMusicWithCoreData
//
//  Created by Nguyen Van Anh Tuan on 12/3/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackModel : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString *trackname;
@property (nonatomic, assign) NSInteger tracktype;

@end
