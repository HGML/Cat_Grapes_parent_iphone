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

@property (weak, nonatomic) IBOutlet UIButton *logInButton;

@property (nonatomic) BOOL hasUsername;

@property (nonatomic) BOOL hasPassword;

@end


@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up navigation bar
    [self.navigationController setNavigationBarHidden:YES];
    
    // Update log in table view
    [self updateLogInTable];
    
    // Set up log in button
    [self.logInButton setEnabled:NO];
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
    
    [cell.textField setDelegate:self];
    [cell.textField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    
    switch (indexPath.row) {
        case 0:
            [cell.textField setPlaceholder:@"用户名"];
            [cell.textField setTag:0];
            [cell.textField setKeyboardType:UIKeyboardTypeEmailAddress];
            [cell.textField setReturnKeyType:UIReturnKeyNext];
            break;
            
        case 1:
            [cell.textField setPlaceholder:@"密码"];
            [cell.textField setTag:1];
            [cell.textField setSecureTextEntry:YES];
            [cell.textField setReturnKeyType:UIReturnKeyGo];
            
        default:
            break;
    }
    
    return cell;
}


#pragma mark - Text Field Delegate

- (IBAction)textFieldDidChange:(UITextField*)textField
{
    switch (textField.tag) {
        case 0:
            self.hasUsername = textField.text.length;
            break;
            
        case 1:
            self.hasPassword = textField.text.length;
            break;
            
        default:
            break;
    }
    
    [self.logInButton setEnabled:(self.hasUsername && self.hasPassword)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag != 1) {   // not last text field: jump to next text field
        FormFieldCell* nextCell = (FormFieldCell*)[self.logInTableView cellForRowAtIndexPath:
                                                   [NSIndexPath indexPathForRow:textField.tag + 1 inSection:0]];
        [nextCell.textField becomeFirstResponder];
    }
    else {   // last text field: resign first responder
        if (textField.text.length != 0) {
            [textField resignFirstResponder];
            [self logInPressed:self.logInButton];
        }
    }
    
    return YES;
}


#pragma mark - Log In

- (IBAction)logInPressed:(id)sender
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
