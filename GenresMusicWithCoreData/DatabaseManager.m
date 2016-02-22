//
//  DatabaseManager.m
//  GenresMusicWithCoreData
//
//  Created by Nguyen Van Anh Tuan on 12/3/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import "DatabaseManager.h"
#import "Track.h"
@implementation DatabaseManager

+ (instancetype)shareInstance {
    static DatabaseManager *databaseManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        databaseManager = [[self alloc] init];
    });
    return databaseManager;

}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (NSMutableArray *)getListTrack:(NSString *)table forType:(NSInteger)type {
    //1
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //2
    NSEntityDescription *entity = [NSEntityDescription entityForName:table inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    //3
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %ld", type];
    [fetchRequest setPredicate:predicate];
    
    //4
    NSError *error;
    NSArray *foundObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (foundObjects == nil) {
        return nil;
    }
    return [NSMutableArray arrayWithArray:foundObjects];
}

- (BOOL)insertRowOfTable:(NSString *)table withTile:(NSString *)title andType:(NSInteger)type {
    Track *track = [NSEntityDescription insertNewObjectForEntityForName:@"Track" inManagedObjectContext:self.managedObjectContext];
    track.title = title;
    track.type = @(type);
    NSError *error = nil;
    if ([self.managedObjectContext save:&error]) {
        return YES;
    }
    return NO;
}

- (BOOL)updateRowOfTable:(NSString *)table withModel:(Track *)model {
    return [self.managedObjectContext save:nil];
}

- (BOOL)deleteRowOfTable:(NSString *)table withModel:(Track *)model {
    [self.managedObjectContext deleteObject:model];
    return [self.managedObjectContext save:nil];
}

@end
