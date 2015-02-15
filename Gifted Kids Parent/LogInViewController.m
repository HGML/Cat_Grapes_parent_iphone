//
//  LogInViewController.m
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/15.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import "LogInViewController.h"
#import "FormFieldCell.h"


@interface LogInViewController () <UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *logInTableView;

@end


@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up navigation bar
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithTitle:@"登录"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(logInPressed:)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    // Update log in table view
    [self updateLogInTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateLogInTable
{
    self.logInTableView.dataSource = self;
}


#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FormFieldCell *cell = (FormFieldCell*)[tableView dequeueReusableCellWithIdentifier:@"formFieldCell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            [cell.label setText:@"用户名"];
            [cell.textField setPlaceholder:@"或邮箱"];
            [cell.textField setTag:0];
            [cell.textField setDelegate:self];
            [cell.textField setKeyboardType:UIKeyboardTypeEmailAddress];
            [cell.textField setReturnKeyType:UIReturnKeyNext];
            break;
            
        case 1:
            [cell.label setText:@"密码"];
            [cell.textField setTag:1];
            [cell.textField setDelegate:self];
            [cell.textField setSecureTextEntry:YES];
            [cell.textField setReturnKeyType:UIReturnKeyGo];
            
        default:
            break;
    }
    
    return cell;
}


#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag != 1) {   // not last text field: jump to next text field
        FormFieldCell* nextCell = (FormFieldCell*)[self.logInTableView cellForRowAtIndexPath:
                                                   [NSIndexPath indexPathForRow:textField.tag + 1 inSection:0]];
        [nextCell.textField becomeFirstResponder];
    }
    else {   // last text field: resign first responder
        [textField resignFirstResponder];
        [self logInPressed:self.navigationItem.rightBarButtonItem];
    }
    
    return YES;
}


#pragma mark - Log In

- (void)logInPressed:(UIBarButtonItem*)sender
{
    FormFieldCell* usernameCell = (FormFieldCell*)[self.logInTableView cellForRowAtIndexPath:
                                                   [NSIndexPath indexPathForRow:0 inSection:0]];
    NSString* username = usernameCell.textField.text;
    FormFieldCell* passwordCell = (FormFieldCell*)[self.logInTableView cellForRowAtIndexPath:
                                                   [NSIndexPath indexPathForRow:1 inSection:0]];
    NSString* password = passwordCell.textField.text;
    
    NSLog(@"Username: %@ Password: %@", username, password);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
