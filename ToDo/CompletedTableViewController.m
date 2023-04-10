//
//  CompletedTableViewController.m
//  ToDo
//
//  Created by moamen ali gomaa on 08/04/2023.
//

#import "CompletedTableViewController.h"
#import "MyCustomCellTableViewCell.h"
#import "Task.h"
#import "Utils.h"
#import "AddeNewTaskViewController.h"
#import "RefreshDelegate.h"

@interface CompletedTableViewController ()<RefreshDelegate>
{
    bool isSorted;
    NSMutableArray *high;
    NSMutableArray *low;
    NSMutableArray *med;
    Utils *utils;
}
@property (weak, nonatomic) IBOutlet UIButton *unSortBtn;
@property (weak, nonatomic) IBOutlet UIButton *sortBtn;
@end

@implementation CompletedTableViewController
- (void)refresh{
    [self.tableView reloadData];
}
- (IBAction)soting:(id)sender {
    isSorted=true;
    [_sortBtn setHidden:true];
    [_unSortBtn setHidden:false];
    for(int i=0;i<_completeArray.count;i++)
    {
        Task *task=[Task new];
        task=[_completeArray objectAtIndex:i];
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
- (IBAction)unSorting:(id)sender {
    isSorted=false;
    high=[NSMutableArray new];
    med=[NSMutableArray new];
    low=[NSMutableArray new];
    [_sortBtn setHidden:false];
    [_unSortBtn setHidden:true];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    utils=[Utils sharedMySingleton];
    high=[NSMutableArray new];
    med=[NSMutableArray new];
    low=[NSMutableArray new];
    isSorted=false;
    
    [_unSortBtn setHidden:true];
    _completeArray= [utils readArrayWithTaskObjFromUserDefaults:@"comp"];
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
        return _completeArray.count;
        
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
        task=[_completeArray objectAtIndex:indexPath.row];
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
                [self->_completeArray removeObject:[self->_completeArray objectAtIndex:indexPath.row]];
                [self->utils writeArrayWithTaskObjToUserDefaults:@"comp" withArray:self->_completeArray];
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
        addView.task=[_completeArray objectAtIndex:indexPath.row];
    }
    addView.isDetailed=true;
    [self presentViewController:addView animated:true completion:nil];
}@end
