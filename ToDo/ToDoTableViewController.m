//
//  ToDoTableViewController.m
//  ToDo
//
//  Created by moamen ali gomaa on 08/04/2023.
//

#import "ToDoTableViewController.h"
#import "Task.h"
#import "AddeNewTaskViewController.h"
#import "Utils.h"
#import "ProgressTableViewController.h"
#import "MyCustomCellTableViewCell.h"
#import "CompletedTableViewController.h"

@interface ToDoTableViewController ()<UISearchBarDelegate,AddDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation ToDoTableViewController
{
    NSMutableArray* todoTasks;
    NSMutableArray* progTasks;
    NSMutableArray* compTasks;
    NSArray *filteredArray;
    Utils *_utils;
    Task* current;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _utils=[Utils sharedMySingleton];
    UIImage *image = [UIImage addImage];
    UIBarButtonItem *Rightbutton = [[UIBarButtonItem alloc]
                                  initWithImage:image
                                  style:UIBarButtonItemStylePlain
                                  target:self
                                    action:@selector(goToAddNewTask:)];
    self.navigationItem.rightBarButtonItem = Rightbutton;
    UINib *nib = [UINib nibWithNibName:@"MyCustomCellTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];

    todoTasks = [ _utils readArrayWithTaskObjFromUserDefaults:@"todList"];
    filteredArray = todoTasks;
    _searchBar.delegate = self;
   
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return filteredArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCustomCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    current = [todoTasks objectAtIndex:indexPath.row];
    cell.nameLable.text = [current name];
    cell.dateLable.text=[current dateOfCreation];
    if([current.priority isEqualToString:@"HIGH"])
    {
      
        [cell.imgView setBackgroundColor:UIColor.greenColor];    }
    if([current.priority isEqualToString:@"MED"]){
        [cell.imgView setBackgroundColor:UIColor.orangeColor];
    }
    if([current.priority isEqualToString:@"LOW"])
    {
        [cell.imgView setBackgroundColor:UIColor.yellowColor];
    }
    
    return cell;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction *editAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Edit" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
      
        UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"alert" message:@"Want to update?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* actionAlert=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            AddeNewTaskViewController *addView=[self.storyboard instantiateViewControllerWithIdentifier:@"newTask"];
            addView.isEdit=true;
            addView.task=[self->todoTasks objectAtIndex:indexPath.row];
            addView.index=indexPath.row;
            addView.delegateObj=self;
            [self.navigationController pushViewController:addView animated:YES];
        }];
        UIAlertAction* cancelAction=[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
            
        }];
        
        [alert addAction:actionAlert];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
      
    
    }];
    editAction.backgroundColor = [UIColor orangeColor];
    
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Delete"  handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"alert" message:@"Want to delete?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* actionAlert=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->todoTasks removeObject:[self->todoTasks objectAtIndex:indexPath.row]];
            [self->_utils writeArrayWithTaskObjToUserDefaults:@"todList" withArray:self->todoTasks];
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

    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction,editAction]];
          return config;
}
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    UIContextualAction *addProgress = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Progress" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
      
        self->progTasks = [ _utils readArrayWithTaskObjFromUserDefaults:@"prog"];
  
        [self->progTasks addObject:self->todoTasks[indexPath.row]];
        
        [self->_utils writeArrayWithTaskObjToUserDefaults:@"prog" withArray:self->progTasks];
        
        [self->todoTasks removeObject:[self->todoTasks objectAtIndex:indexPath.row]];
     
        [self->_utils writeArrayWithTaskObjToUserDefaults:@"todList" withArray:self->todoTasks];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }];
    addProgress.backgroundColor = [UIColor orangeColor];
    
    UIContextualAction *addCompleted = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Completed"  handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        self->compTasks = [ _utils readArrayWithTaskObjFromUserDefaults:@"comp"];
        [self->compTasks addObject:self->todoTasks[indexPath.row]];
        [self->_utils writeArrayWithTaskObjToUserDefaults:@"comp" withArray:self->compTasks];
      
        [self->todoTasks removeObject:[self->todoTasks objectAtIndex:indexPath.row]];
        [self->_utils writeArrayWithTaskObjToUserDefaults:@"todList" withArray:self->todoTasks];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        self->_delegateObj=[self.storyboard instantiateViewControllerWithIdentifier:@"comp"];
        [   self->_delegateObj refresh];
        
        [self.tableView reloadData];
        
    }];
    addCompleted.backgroundColor = [UIColor greenColor];

    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[addCompleted,addProgress]];
          return config;
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        
        filteredArray = todoTasks;
    }else {
        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF.name contains[cd]%@",searchText];
        filteredArray = [todoTasks filteredArrayUsingPredicate:bPredicate];
    }
    [self.tableView reloadData];
}


-(void)goToAddNewTask:(id)sender
{
    AddeNewTaskViewController* addView=[self.storyboard instantiateViewControllerWithIdentifier:@"newTask"];
    addView.delegateObj=self;
    addView.isEdit=false;
    
    [self.navigationController pushViewController:addView animated:true ];
}
- (void)addNewTodoTask:(Task *)task{
    
    [todoTasks addObject:task];
    [self->_utils writeArrayWithTaskObjToUserDefaults:@"todList" withArray:todoTasks];
    [self.tableView reloadData];
}
- (void)updateTask:(int)index :(Task *)newTask
{

    [todoTasks removeObjectAtIndex:index];
    [todoTasks addObject:newTask];
    [self->_utils writeArrayWithTaskObjToUserDefaults:@"todList" withArray:todoTasks];
    [self.tableView reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AddeNewTaskViewController *addView=[self.storyboard instantiateViewControllerWithIdentifier:@"newTask"];
    addView.task=[todoTasks objectAtIndex:indexPath.row];
    addView.isDetailed=true;
    [self presentViewController:addView animated:true completion:nil];
}
- (IBAction)progBtn:(id)sender {
    ProgressTableViewController *progView=[self.storyboard instantiateViewControllerWithIdentifier:@"prog"];
    [self.navigationController pushViewController:progView animated:YES];
    
}
- (IBAction)compBtn:(id)sender {
    CompletedTableViewController *compView=[self.storyboard instantiateViewControllerWithIdentifier:@"comp"];
    [self.navigationController pushViewController:compView animated:YES];
    
}

@end
