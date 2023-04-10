//
//  AddeNewTaskViewController.m
//  ToDo
//
//  Created by moamen ali gomaa on 08/04/2023.
//

#import "AddeNewTaskViewController.h"
#import "Task.h"
#import "Utils.h"
#import <UserNotifications/UserNotifications.h>

@interface AddeNewTaskViewController ()<UIDocumentPickerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *set;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *descTF;
@property (weak, nonatomic) IBOutlet UIButton *fileURL;

@property (weak, nonatomic) IBOutlet UIButton *saveFileL;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priority;



@end

@implementation AddeNewTaskViewController
{
    UIDocumentPickerViewController *documentPicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];

   if(_isDetailed==true)
   {
       _nameTF.text=_task.name;
       _descTF.text=_task.desc;
       [_priority setEnabled:false];
       if([_task.priority isEqualToString:@"HIGH"])
       {
           _priority.selectedSegmentIndex=0;
       }
       if([_task.priority isEqualToString:@"MED"])
       {
           _priority.selectedSegmentIndex=1;
       }
       if([_task.priority isEqualToString:@"LOW"])
       {
           _priority.selectedSegmentIndex=2;
       }
      
       [_saveFileL setHidden:true];
       [_datePicker setHidden:true];
       [_set setHidden:true];
       [_descTF setEnabled:false];
       [_nameTF setEnabled:false];
       [_saveBtn setHidden:true];
       [_fileURL setHidden:false];
   }
    else if(_isEdit==true){
        [_set setHidden:true];
        _nameTF.text=_task.name;
        _descTF.text=_task.desc;
        [_datePicker setEnabled:false];
        [_saveFileL setHidden:true];
        [_fileURL setHidden:true];
        _saveBtn.titleLabel.text=@"edit";
    }
    else{
        _task=[Task new];
        self.navigationItem.title=@"Add new task";
        _task.priority=@"HIGH";
        [_fileURL setHidden:true];
    }
    
 
   
   
}

- (IBAction)addFile:(id)sender {
    documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.content"] inMode: UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    [self presentViewController:documentPicker animated:true completion:nil];
}
- (IBAction)priority:(UISegmentedControl*)sender {
    if(sender.selectedSegmentIndex==0){
        _task.priority=@"HIGH";
        
    }
    if(sender.selectedSegmentIndex==1){
        _task.priority=@"MED";
    }
    if(sender.selectedSegmentIndex==2){
        _task.priority=@"LOW";
    }
    
}

- (IBAction)fileUrl:(id)sender {
    NSURL *documentsUrl = _task.attachPath;
  NSString *sharedurl = [documentsUrl.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@"shareddocuments://"];
  NSURL *furl = [NSURL URLWithString:sharedurl];
  [[UIApplication sharedApplication] openURL:furl options:@{} completionHandler:nil];
    
}
- (IBAction)save:(UIButton*)sender {
    if([_nameTF.text isEqual:@""]||[_descTF.text isEqual:@""]){
        UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"alert" message:@"Please enter all fields" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* actionAlert=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         
        }];
        [alert addAction:actionAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        if(_isEdit==true)
            
        {Task *_newTask=[Task new];
            _newTask.name=_nameTF.text;
            _newTask.desc=_descTF.text;
            _newTask.dateOfCreation=[Utils currentDate];
            _newTask.priority=_task.priority;
            _newTask.attachPath=_task.attachPath;
            [_delegateObj updateTask:_index :_newTask];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            _task.name=_nameTF.text;
            _task.desc=_descTF.text;
            _task.dateOfCreation=[Utils currentDate];
            [_delegateObj addNewTodoTask:_task];
            [self.navigationController popViewControllerAnimated:YES];
        }

    }
  
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    [_fileURL setHidden:false];
    _task.attachPath= [urls firstObject];

}
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    printf("cancelled");
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)setReminder:(id)sender {
    printf("pressed \n");
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:@"Reminder" arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:_task.name
                arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
     
  
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                triggerWithTimeInterval:_datePicker.date.timeIntervalSinceNow repeats:NO];
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"REMINDER"
                content:content trigger:trigger];
     

    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:nil];

}


@end
