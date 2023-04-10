//
//  Utils.m
//  ToDo
//
//  Created by moamen ali gomaa on 08/04/2023.
//

#import "Utils.h"

@implementation Utils


static Utils *_sharedMySingleton = nil;
static NSUserDefaults * userDefaults =nil;

+(Utils *)sharedMySingleton {
    @synchronized([Utils class]) {
        if (!_sharedMySingleton)
        {
            _sharedMySingleton = [[self alloc] init];
            userDefaults = [NSUserDefaults standardUserDefaults];
        }
        return _sharedMySingleton;
    }
    return nil;
}

-(void)writeArrayWithTaskObjToUserDefaults:(NSString *)keyName withArray:(NSMutableArray *)myArray
{

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:myArray];
    [userDefaults setObject:data forKey:keyName];
}


-(NSMutableArray *)readArrayWithTaskObjFromUserDefaults:(NSString*)keyName
{

    NSMutableArray *myArray;
    NSData *data = [userDefaults objectForKey:keyName];
    myArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (myArray == nil) {
        myArray = [NSMutableArray new];
    }
    return myArray;
}
+( NSString*)currentDate{
    NSDate* currentDate = [NSDate date];
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [dateformater stringFromDate: currentDate];
    NSDateFormatter *timeformater = [[NSDateFormatter alloc] init];
    [timeformater setDateFormat:@"HH:MM"];
    NSString *str1 = [timeformater stringFromDate: currentDate];
    NSString *dateNTime = [NSString stringWithFormat:@"%@ at %@", str, str1];
    return dateNTime;
}
- (void)removeArrayFromUserDefaults:(NSString *)keyName{
    [userDefaults removeObjectForKey:keyName];
}

@end
