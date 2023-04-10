//
//  ProgressTableViewController.m
//  ToDo
//
//  Created by moamen ali gomaa on 08/04/2023.
//

#import "ProgressTableViewController.h"
#import "MyCustomCellTableViewCell.h"
#import "Task.h"
#import "Utils.h"
#import "AddeNewTaskViewController.h"
#import "CompletedTableViewController.h"
#import "RefreshDelegate.h"

@interface ProgressTableViewController ()<RefreshDelegate>
@property (weak, nonatomic) IBOutlet UIButton *unSort;

@property (weak, nonatomic) IBOutlet UIButton *sort;


@end

@implementation ProgressTableViewController
{
    bool isSorted;
    NSMutableArray *high;
    NSMutableArray *low;
    NSMutableArray *med;
    NSMutableArray *compTasks;
    Utils *utils;
}
- (void)refresh{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
  

}

- (IBAction)unSortBtn:(id)sender {
    isSorted=false;
    high=[NSMutableArray new];
    med=[NSMutableArray new];
    low=[NSMutableArray new];
   
    [_sort setHidden:false];
    [_unSort setHidden:true];
    [self.tableView reloadData];
}
- (IBAction)sortBtn:(id)sender {
    isSorted=true;
    [_sort setHidden:true];
    [_unSort setHidden:false];
    for(int i=0;i<_progressArray.count;i++)
    {
        Task *task=[Task new];
        task=[_progressArray objectAtIndex:i];
        if([task.priority isEqualToString:@"HIGH"])
        {
            [high addObject:task];
        }
        if([task.priority isEqualToString:@"MED"])
        {
            [med addObject:task];
        }
        if([task.priority isEqualToString:@"LOW"])
        {
            [low addObject:task];
        }
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    high=[NSMutableArray new];
    med=[NSMutableArray new];
    low=[NSMutableArray new];
    utils=[Utils sharedMySingleton];
   
    _progressArray= [utils readArrayWithTaskObjFromUserDefaults:@"prog"];
    isSorted=false;
    
    [_unSort setHidden:true];
 
    UINib *nib = [UINib nibWithNibName:@"MyCustomCellTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(isSorted)
        return 3;
    else
       return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
 
        if(isSorted)
        {
            switch (section) {
                case 0:
                    return high.count;
                    break;
                case 1:
                    return med.count;
                    break;
                default:
                    return low.count;
                    break;
            }
        }
    else
        return _progressArray.count;
        
    }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Task *task;
    if(isSorted){
        printf("is sorted \n");
        switch (indexPath.section) {
            case 0:
                task=[high objectAtIndex:indexPath.row];
              
                break;
            case 1:
                task=[med objectAtIndex:indexPath.row];
            
                break;
            default:
                task=[low objectAtIndex:indexPath.row];
           
                break;
        }
        
        
    }
    else{
        task=[_progressArray objectAtIndex:indexPath.row];
    }
    MyCustomCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.nameLable.text = [task name];
    cell.dateLable.text=[task dateOfCreation];
    if([task.priority isEqualToString:@"HIGH"])
    {
        [cell.imgView setBackgroundColor:UIColor.greenColor];    }
    if([task.priority isEqualToString:@"MED"]){
        [cell.imgView setBackgroundColor:UIColor.orangeColor];
    }
    if([task.priority isEqualToString:@"LOW"])
    {
        [cell.imgView setBackgroundColor:UIColor.yellowColor];
    }
    return cell;
}
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{

        UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Delete"  handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"alert" message:@"Want to delete?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* actionAlert=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self->_progressArray removeObjectAtIndex:indexPath.row];
                [self->utils writeArrayWithTaskObjToUserDefaults:@"prog" withArray:self->_progressArray];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView reloadData];
            }];
            UIAlertAction* cancelAction=[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            
            [alert addAction:actionAlert];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }];
        deleteAction.backgroundColor = [UIColor redColor];
        
        
        UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
        return config;
    }
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section{
    if(isSorted){
        switch (section) {
            case 0:
                return @"HIGH";
                break;
            case 1:
                return @"MED";
                break;
            default:
                return @"LOW";
                break;
        }
      
    }
    return @" ";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddeNewTaskViewController *addView=[self.storyboard instantiateViewControllerWithIdentifier:@"newTask"];
    if(isSorted)
    {
     
        switch (indexPath.section) {
            case 0:
                addView.task=[high objectAtIndex:indexPath.row];
                break;
            case 1:
                addView.task=[med objectAtIndex:indexPath.row];
                break;
            default:
                addView.task=[low objectAtIndex:indexPath.row];
                break;
        }
    }
    else{
        addView.task=[_progressArray objectAtIndex:indexPath.row];
    }
   
    addView.isDetailed=true;
    [self presentViewController:addView animated:true completion:nil];
}
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction *addCompleted = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Completed"  handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        compTasks=[utils readArrayWithTaskObjFromUserDefaults:@"comp"];
        [self->compTasks addObject:self->_progressArray[indexPath.row]];
        [self->utils writeArrayWithTaskObjToUserDefaults:@"comp" withArray:self->compTasks];
        
        [self->_progressArray removeObjectAtIndex:indexPath.row];
        [self->utils writeArrayWithTaskObjToUserDefaults:@"prog" withArray:self->_progressArray];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }];
    addCompleted.backgroundColor = [UIColor redColor];

    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[addCompleted]];
          return config;

}

@end
