//
//  DatabaseManager.h
//  GenresMusicWithCoreData
//
//  Created by Nguyen Van Anh Tuan on 12/3/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Track;

@interface DatabaseManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+ (instancetype)shareInstance;

- (NSMutableArray *)getListTrack:(NSString *)table forType:(NSInteger)type;

- (BOOL)insertRowOfTable:(NSString *)table withTile:(NSString *)title andType:(NSInteger)type;

- (BOOL)updateRowOfTable:(NSString *)table withModel:(Track *)model;

- (BOOL)deleteRowOfTable:(NSString *)table withModel:(Track *)model;

@end
