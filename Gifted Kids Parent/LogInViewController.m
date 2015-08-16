//
//  LogInViewController.m
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/15.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import "LogInViewController.h"
#import "FormFieldCell.h"
#import <QuartzCore/QuartzCore.h>

#import "AFNetworkManager.h"


#define TABLEVIEW_HEIGHT_SMALL 88

#define TABLEVIEW_HEIGHT_LARGE 132

typedef enum{logIn = 0, signUp} State;

@interface LogInViewController () <UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *logInSignUpToggleButton;

@property (nonatomic) State state;

@property (weak, nonatomic) IBOutlet UITableView *userInfoTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userInfoTableViewHeightConstraint;


@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic) BOOL hasUsername;

@property (nonatomic) BOOL hasPassword;

@property (nonatomic, strong) NSString* username;

@end


@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up navigation bar
    [self.navigationController setNavigationBarHidden:YES];
    
    // Set up user info table view
    self.userInfoTableViewHeightConstraint.constant = TABLEVIEW_HEIGHT_SMALL;
    self.userInfoTableView.dataSource = self;
    
    // Set up submit (log in or sign up) button
    self.state = logIn;
    [self.submitButton setEnabled:NO];
    [self.submitButton setEnabled:YES];   // TEST PURPOSE
    
    // Set up Log in/Sign up toggle button
    self.logInSignUpToggleButton.layer.borderWidth = 0.8f;
    self.logInSignUpToggleButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.logInSignUpToggleButton.layer.cornerRadius = 8.0f;
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
            
            self.userInfoTableViewHeightConstraint.constant = TABLEVIEW_HEIGHT_LARGE;
            [self.userInfoTableView reloadData];
            
            break;
            
        case signUp:
            self.state = logIn;
            [self.submitButton setTitle:@"登录" forState:UIControlStateNormal];
            [self.logInSignUpToggleButton setTitle:@"注册" forState:UIControlStateNormal];
            
            self.userInfoTableViewHeightConstraint.constant = TABLEVIEW_HEIGHT_SMALL;
            [self.userInfoTableView reloadData];
            
            break;
            
        default:
            break;
    }
}


#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.state) {
        case logIn:
            return 2;
            break;
            
        case signUp:
            return 3;
            break;
            
        default:   // log in
            return 2;
            break;
    }}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FormFieldCell *cell = (FormFieldCell*)[tableView dequeueReusableCellWithIdentifier:@"formFieldCell" forIndexPath:indexPath];
    
    [cell.textField setKeyboardAppearance:UIKeyboardAppearanceDark];
    [cell.textField setDelegate:self];
    [cell.textField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    
    switch (indexPath.row) {
        case 0:   // username
            [cell.textField setPlaceholder:@"用户名"];
            [cell.textField setTag:0];
            [cell.textField setKeyboardType:UIKeyboardTypeEmailAddress];
            [cell.textField setReturnKeyType:UIReturnKeyNext];
            [cell.textField setText:self.username];
            if (! cell.textField.text.length) {
                [cell.textField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
            }
            if (! cell.textField.text.length) {
                [cell.textField setText:@"sysamli"];   // TEST PURPOSE
            }
            break;
            
        case 1:   // password
            [cell.textField setPlaceholder:@"密码"];
            [cell.textField setTag:1];
            [cell.textField setSecureTextEntry:YES];
            switch (self.state) {
                case logIn:
                    [cell.textField setReturnKeyType:UIReturnKeyGo];
                    break;
                    
                case signUp:
                    [cell.textField setReturnKeyType:UIReturnKeyNext];
                    
                default:
                    break;
            }
            [cell.textField setText:@"951117"];   // TEST PURPOSE
            break;
            
        case 2:   // student username
            [cell.textField setPlaceholder:@"学生用户名"];
            [cell.textField setTag:2];
            [cell.textField setReturnKeyType:UIReturnKeyGo];
            [cell.textField setText:@"HGMLee"];   // TEST PURPOSE
            break;
            
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
    // Get username and password
    FormFieldCell* usernameCell = (FormFieldCell*)[self.userInfoTableView cellForRowAtIndexPath:
                                                   [NSIndexPath indexPathForRow:0 inSection:0]];
    NSString* username = usernameCell.textField.text;
    
    FormFieldCell* passwordCell = (FormFieldCell*)[self.userInfoTableView cellForRowAtIndexPath:
                                                   [NSIndexPath indexPathForRow:1 inSection:0]];
    NSString* password = passwordCell.textField.text;
    
    NSString* studentUsername = nil;
    if (self.state == signUp) {
        FormFieldCell* studentUsernameCell = (FormFieldCell*)[self.userInfoTableView cellForRowAtIndexPath:
                                                              [NSIndexPath indexPathForRow:2 inSection:0]];
        studentUsername = studentUsernameCell.textField.text;
    }
    
    // Perform log in or sign up
    switch (self.state) {
        case logIn:
            [self logInWithUsername:username andPassword:password];
            break;
            
        case signUp:
            [self signUpWithUsername:username password:password andStudentUsername:studentUsername];
            break;
            
        default:
            break;
    }
}

- (void)logInWithUsername:(NSString*)username andPassword:(NSString*)password
{
    NSLog(@"Logging in...");
    
    NSMutableArray* parentInfo = [NSMutableArray arrayWithObjects:username, password, nil];
    
    // Package all the paras in a student field
    NSDictionary *parameters = @{@"parent":@{@"name":parentInfo[0],
                                             @"password":parentInfo[1]}
                                 };
    
    // Send a GET request to back-end server to log in student user
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@LOGIN_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Server response object: %@", responseObject);
        
        if([responseObject[@"status"]  isEqual: (@"Login Failure")])
        {
            NSLog(@"Server: No parent account exists with username %@ and password %@.", parentInfo[0], parentInfo[1]);
            UIAlertView* noAccountAlert = [[UIAlertView alloc] initWithTitle:@"无法登陆"
                                                                     message:@"邮箱或密码错误"
                                                                    delegate:self
                                                           cancelButtonTitle:@"好"
                                                           otherButtonTitles:nil];
            [noAccountAlert show];
            return;
        }
        else if([responseObject[@"status"]  isEqual: (@"Login Success")])
        {
            NSLog(@"Server: Logged in successfully!");
            
            // Save parent username to UserDefaults
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:username forKey:@"ParentUsername"];
            [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:@"ServerLoggedIn"];
            [[NSUserDefaults standardUserDefaults] setObject:@"HGMLee" forKey:@"studentUsername"];   // TEST
            [userDefaults synchronize];
            
            // Post User Logged In notification
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoggedIn" object:self];
            
            // Return to Home
            [self showHome];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)signUpWithUsername:(NSString*)username password:(NSString*)password andStudentUsername:(NSString*)studentUsername
{
    NSLog(@"Creating new student account...");
    
    /*
     * Username
     * Mobile phone
     * Password
     */
    NSMutableArray* parentInfo = [NSMutableArray arrayWithObjects:username, @"01234567890", password, nil];
    
    // Package all the paras in a student field
    NSDictionary *parameters = @{@"parent":@{@"name":parentInfo[0],
                                             @"mobile_phone":parentInfo[1],
                                             @"password":parentInfo[2]}
                                 };
    
    // Send a POST request to back-end server to create the student user.
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@CREATE_PARENT_URL
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"Server response object: %@", responseObject);
              
              if([responseObject[@"status"]  isEqual: (@"Existed")]) {
                  NSLog(@"Server: An account already exists under the email address %@. Please log in instead.", parentInfo[0]);
                  NSLog(@"Parent not created");
                  self.username = parentInfo[0];
                  UIAlertView* usernameExistsAlert = [[UIAlertView alloc] initWithTitle:@"用户名已被使用"
                                                                                message:@"是否要登陆？"
                                                                               delegate:self
                                                                      cancelButtonTitle:@"取消"
                                                                      otherButtonTitles:@"登陆", nil];
                  [usernameExistsAlert show];
                  return;
              }
              else if([responseObject[@"status"]  isEqual: (@"Failure")]) {
                  NSLog(@"Server: Unknown Failure of signing up!");
                  // !!! Add future re_direction to the user page here.
              }
              else if([responseObject[@"status"]  isEqual: (@"Created")]) {
                  NSLog(@"Server: Created successfully!");
                  
                  id parentObject = responseObject[@"parent"];
                  NSLog(@"Signed up for parent user %@ and password %@: id %@", username, password, parentObject[@"id"]);
                  
                  // Save parent username to UserDefaults
                  NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                  [userDefaults setObject:username forKey:@"ParentUsername"];
                  [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:@"ServerLoggedIn"];
                  [userDefaults synchronize];
                  
                  // Post User Logged In notification
                  NSLog(@"Local: Logged In");
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoggedIn" object:self];
                  
                  // Create Parent locally
                  
                  // Ask parent to add student
                  
                  // Return to Home
                  [self showHome];
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Server: ERROR when performing POST operation: %@", error);
          }];
}


#pragma mark - Get Student IDs for parent

- (void)getStudentIDsForParentID:(NSNumber*)parentID
{
    // Package all the paras in a student field
    NSDictionary *parameters = @{@"parent":@{@"id":parentID}};
    
    // Send a GET request to back-end server to log in student user
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@GET_STUDENT_IDS_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Server response object: %@", responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


#pragma mark - Return to Home Screen

- (void)showHome
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark - Forgot Password

- (IBAction)forgotPasswordPressed:(id)sender
{
    NSLog(@"Forgot Password");
}


#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"登陆"]) {
        self.state = logIn;
        [self.submitButton setTitle:@"登录" forState:UIControlStateNormal];
        [self.logInSignUpToggleButton setTitle:@"注册" forState:UIControlStateNormal];
        
        self.userInfoTableViewHeightConstraint.constant = TABLEVIEW_HEIGHT_SMALL;
        [self.userInfoTableView reloadData];
    }
}

@end
