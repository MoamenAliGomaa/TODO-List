//
//  ProgressTableViewController.h
//  ToDo
//
//  Created by moamen ali gomaa on 08/04/2023.
//

#import <UIKit/UIKit.h>
#import "RefreshDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProgressTableViewController : UITableViewController
@property NSMutableArray *progressArray;
@property id<RefreshDelegate> delegateObj;
@end

NS_ASSUME_NONNULL_END
