#import "Task.h"

@protocol AddDelegate

-(void) addNewTodoTask : (Task*) task;
- (void)updateTask: (int) index : (Task *) newTask ;
@end
