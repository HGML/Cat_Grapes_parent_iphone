//
//  LogInViewController.m
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/15.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import "LogInViewController.h"
#import "FormFieldCell.h"


typedef enum{logIn = 0, signUp} State;

@interface LogInViewController () <UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *logInSignUpToggleButton;

@property (nonatomic) State state;


@property (weak, nonatomic) IBOutlet UITableView *userInfoTableView;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic) BOOL hasUsername;

@property (nonatomic) BOOL hasPassword;

@end


@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up navigation bar
    [self.navigationController setNavigationBarHidden:YES];
    
    // Set up user info table view
    self.userInfoTableView.dataSource = self;
    
    // Set up submit (log in or sign up) button
    [self.submitButton setEnabled:NO];
    self.state = logIn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Toggle Log in/Sign up

- (IBAction)logInSignUpTogglePressed:(id)sender
{
    switch (self.state) {
        case logIn:
            self.state = signUp;
            [self.submitButton setTitle:@"注册" forState:UIControlStateNormal];
            [self.logInSignUpToggleButton setTitle:@"登录" forState:UIControlStateNormal];
            break;
            
        case signUp:
            self.state = logIn;
            [self.submitButton setTitle:@"登录" forState:UIControlStateNormal];
            [self.logInSignUpToggleButton setTitle:@"注册" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
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
    
    [self.submitButton setEnabled:(self.hasUsername && self.hasPassword)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag != 1) {   // not last text field: jump to next text field
        FormFieldCell* nextCell = (FormFieldCell*)[self.userInfoTableView cellForRowAtIndexPath:
                                                   [NSIndexPath indexPathForRow:textField.tag + 1 inSection:0]];
        [nextCell.textField becomeFirstResponder];
    }
    else {   // last text field: resign first responder
        if (textField.text.length != 0) {
            [textField resignFirstResponder];
            [self submitPressed:self.submitButton];
        }
    }
    
    return YES;
}


#pragma mark - Submit

- (IBAction)submitPressed:(id)sender
{
    FormFieldCell* usernameCell = (FormFieldCell*)[self.userInfoTableView cellForRowAtIndexPath:
                                                   [NSIndexPath indexPathForRow:0 inSection:0]];
    NSString* username = usernameCell.textField.text;
    FormFieldCell* passwordCell = (FormFieldCell*)[self.userInfoTableView cellForRowAtIndexPath:
                                                   [NSIndexPath indexPathForRow:1 inSection:0]];
    NSString* password = passwordCell.textField.text;
    
    NSLog(@"%@: Username: %@ Password: %@", self.state == logIn ? @"Log in" : @"Sign up", username, password);
}


#pragma mark - Forgot Password

- (IBAction)forgotPasswordPressed:(id)sender
{
    NSLog(@"Forgot Password");
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
