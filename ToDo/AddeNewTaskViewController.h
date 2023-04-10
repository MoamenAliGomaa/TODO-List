//
//  AddeNewTaskViewController.h
//  ToDo
//
//  Created by moamen ali gomaa on 08/04/2023.
//

#import <UIKit/UIKit.h>
#import "addDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddeNewTaskViewController : UIViewController
    @property id<AddDelegate> delegateObj;
@property bool isEdit;
@property bool isDetailed;
@property bool index;
@property  Task *task;

@end

NS_ASSUME_NONNULL_END
