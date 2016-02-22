//
//  AppDelegate.m
//  GenresMusicWithCoreData
//
//  Created by Nguyen Van Anh Tuan on 12/3/15.
//  Copyright © 2015 Nguyen Van Anh Tuan. All rights reserved.
//

#import "AppDelegate.h"
#import "GenresTableViewController.h"
#import "SongTableViewController.h"
#import "DatabaseManager.h"
#import <CoreData/CoreData.h>

@interface AppDelegate ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) UINavigationController *genresNavigationController;
@property (nonatomic, strong) UINavigationController *songNavigationController;
@property (nonatomic, strong) GenresTableViewController *genresTableViewController;
@property (nonatomic, strong) SongTableViewController *songTableViewController;
@property (nonatomic, strong) UITabBarController *tabbarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //CoreData in here
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    //create instance of databasemanager
    [DatabaseManager shareInstance];
    [DatabaseManager shareInstance].managedObjectContext = self.managedObjectContext;
    
    self.genresTableViewController = [[GenresTableViewController alloc] initWithNibName:@"GenresTableViewController" bundle:nil];
    self.genresNavigationController = [[UINavigationController alloc] initWithRootViewController:self.genresTableViewController];
    self.genresTableViewController.title = @"Navigation Genres";
    self.genresTableViewController.tabBarItem.title = @"Genres";
    self.genresTableViewController.tabBarItem.image = [UIImage imageNamed:@"icon_tab_genres.png"];
    
    //coredata
//    self.genresTableViewController.managedObjectContext = self.managedObjectContext;
    
    self.songTableViewController = [[SongTableViewController alloc] initWithNibName:@"SongTableViewController" bundle:nil];
    self.songNavigationController = [[UINavigationController alloc] initWithRootViewController:self.songTableViewController];
    self.songTableViewController.title = @"Navigation Song";
    self.songTableViewController.tabBarItem.title = @"Song";
    self.songTableViewController.tabBarItem.image = [UIImage imageNamed:@"icon_tab_download.png"];
    
    //coredata
//    self.songTableViewController.managedObjectContext = self.managedObjectContext;
    
    /*
     lấy tabbar từ storyboard thông qua UIStoryboard và identifier của tabbarController(identifier từ Main.storyboard)
     tên của storyboard trùng với tên file storyboard (việc này chính xác là tạo ra tabbar mới dựa theo tabbar ở storyboard chứ hoàn toàn không phải là sử dụng lại, vì vậy ta phải setRootView cho window
     UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     self.tabbarController = [sb instantiateViewControllerWithIdentifier:@"tabbarController"];
     
     có thể dùng method instantiateInitiaViewController để lấy ra tabbar từ story (chỉ khi nào tabbar này là thằng chính sẽ chạy
     đầu tiên trong storyboard
     self.tabbarController = [sb instantiateInitialViewController];
     self.tabbarController.viewControllers = [NSArray arrayWithObjects:self.genresTableViewController, self.songTableViewController, nil];
     */
    
    self.tabbarController = [[UITabBarController alloc] init];
    
    [self.tabbarController setViewControllers:@[self.genresNavigationController, self.songNavigationController]];
    
    self.genresTableViewController.delegate = self.songTableViewController;
    self.songTableViewController.delegate = self.genresTableViewController;
    
    [self.window setRootViewController:self.tabbarController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - CoreData

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel == nil) {
        NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"DataModel" ofType:@"momd"];
        NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}

- (NSString *)dataStorePath {
    return [[self documentsDirectory] stringByAppendingPathComponent:@"DataStore.sqlite"];
}

- (NSManagedObjectContext * )managedObjectContext {
    if (_managedObjectContext == nil) {
        NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
        if (coordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
    }
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator == nil) {
        NSURL *storeURL = [NSURL fileURLWithPath:[self dataStorePath]];
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        NSError *error;
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                        configuration:nil
                                        URL:storeURL
                                        options:nil
                                        error:&error]) {
            NSLog(@"Error adding persistent store %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return _persistentStoreCoordinator;
}






@end
