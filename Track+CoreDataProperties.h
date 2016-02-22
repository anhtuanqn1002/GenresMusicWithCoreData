//
//  Track+CoreDataProperties.h
//  GenresMusicWithCoreData
//
//  Created by Nguyen Van Anh Tuan on 12/3/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Track.h"

NS_ASSUME_NONNULL_BEGIN

@interface Track (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *type;

@end

NS_ASSUME_NONNULL_END
