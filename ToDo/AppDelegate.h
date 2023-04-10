//
//  AppDelegate.h
//  ToDo
//
//  Created by moamen ali gomaa on 08/04/2023.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

//interface
 @interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>



@end

