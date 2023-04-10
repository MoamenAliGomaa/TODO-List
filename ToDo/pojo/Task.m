//
//  Task.m
//  ToDoTasksTest
//
//  Created by moamen ali gomaa on 04/04/2023.
//

#import "Task.h"

@implementation Task


- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_desc forKey:@"desc"];
    [coder encodeObject:_dateOfCreation forKey:@"dateOfCreation"];
    [coder encodeObject:_priority forKey:@"priority"];
    [coder encodeObject:_imgName forKey:@"img"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self != nil)
    {
        _name  = [coder decodeObjectForKey:@"name"];
        _desc = [coder decodeObjectForKey:@"desc"];
        _dateOfCreation = [coder decodeObjectForKey:@"dateOfCreation"];
        _priority = [coder decodeObjectForKey:@"priority"];
        _imgName = [coder decodeObjectForKey:@"img"];
    
    }
    return self;
}

@end
