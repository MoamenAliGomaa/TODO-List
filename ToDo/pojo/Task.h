//
//  Task.h
//  ToDoTasksTest
//
//  Created by moamen ali gomaa on 04/04/2023.
//

#import <Foundation/Foundation.h>



@interface Task : NSObject<NSCoding>
@property NSString *name;
@property NSURL *attachPath;
@property NSString *desc;
@property NSString *dateOfCreation;
@property NSString *imgName;
@property NSString *priority;
@end


