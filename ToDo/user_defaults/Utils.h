//
//  Utils.h
//  ToDo
//
//  Created by moamen ali gomaa on 08/04/2023.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject
-(void)writeArrayWithTaskObjToUserDefaults:(NSString *)keyName withArray:(NSMutableArray *)myArray;
-(NSMutableArray *)readArrayWithTaskObjFromUserDefaults:(NSString*)keyName;
+( NSString*)currentDate;
-(void)removeArrayFromUserDefaults:(NSString*)keyName;
+(Utils *)sharedMySingleton;
@end

NS_ASSUME_NONNULL_END
