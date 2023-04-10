//
//  MyCustomCellTableViewCell.h
//  ToDo
//
//  Created by moamen ali gomaa on 08/04/2023.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCustomCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;

@end

NS_ASSUME_NONNULL_END
