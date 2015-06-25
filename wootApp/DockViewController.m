//
//  DockViewController.m
//  wootApp
//
//  Created by Cole Wilkes on 6/23/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "DockViewController.h"
#import "UserController.h"
#import "UIView+FLKAutoLayout.h"

@interface DockViewController ()

// Dock
@property (nonatomic, strong) UIButton *exitButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *showSignUp;
@property (nonatomic, strong) UIButton *showLogIn;

// Sign Up
@property (nonatomic, strong) UITextField *firstNameField;
@property (nonatomic, strong) UITextField *lastNameField;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UILabel *passwordInstructionsLabel;
@property (nonatomic, strong) UIButton *signUpButton;

// Log In
@property (nonatomic, strong) UITextField *emailLogIn;
@property (nonatomic, strong) UITextField *passwordLogIn;
@property (nonatomic, strong) UIButton *logInButton;

@end

@implementation DockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // back button
    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.backButton alignTop:@"30" leading:@"30" toView:self.view];
    [self.backButton constrainHeight:@"30"];
    [self.backButton constrainWidth:@"30"];
    self.backButton.backgroundColor = [UIColor redColor];
    self.backButton.hidden = YES;
    self.backButton.tag = -1;
    [self.backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    // exit button
    self.exitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.exitButton.frame = CGRectMake(self.view.frame.size.width - 60, 30, 30, 30);
    self.exitButton.backgroundColor = [UIColor redColor];
    [self.exitButton setTitle:@"X" forState:UIControlStateNormal];
    [self.exitButton addTarget:self action:@selector(exitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.exitButton];
    
    // background image
    UIImage *backgroundImage = [UIImage imageNamed:@"oregon"];
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:backgroundImage];
    backgroundImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
    
    // sign up button
    self.showSignUp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.showSignUp.frame = CGRectMake(20, 520, self.view.frame.size.width - 40, 50);
    [self.showSignUp setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.showSignUp addTarget:self action:@selector(showSignUp:) forControlEvents:UIControlEventTouchUpInside];
    self.showSignUp.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.showSignUp];
    
    // log in button
    self.showLogIn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.showLogIn.frame = CGRectMake(20, 590, self.view.frame.size.width - 40, 50);
    [self.showLogIn setTitle:@"Log In" forState:UIControlStateNormal];
    [self.showLogIn addTarget:self action:@selector(showLogIn:) forControlEvents:UIControlEventTouchUpInside];
    self.showLogIn.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.showLogIn];
    
    [self setupSignUp];
    [self setupLogIn];
}

- (void)setupSignUp {
    self.emailField = [[UITextField alloc]initWithFrame:CGRectMake(20, 180, self.view.frame.size.width - 40, 40)];
    self.emailField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailField.placeholder = @"Email";
    [self.view addSubview:self.emailField];
    self.emailField.hidden = YES;
    
    self.passwordField = [[UITextField alloc]initWithFrame:CGRectMake(20, 230, self.view.frame.size.width - 40, 40)];
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.placeholder = @"Password";
    self.passwordField.secureTextEntry = YES;
    [self.view addSubview:self.passwordField];
    self.passwordField.hidden = YES;
    
    self.passwordInstructionsLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 265, self.view.frame.size.width - 40, 30)];
    self.passwordInstructionsLabel.font = [UIFont systemFontOfSize:13];
    self.passwordInstructionsLabel.textColor = [UIColor grayColor];
    self.passwordInstructionsLabel.text = @"Your password must contain at least 5 characters";
    [self.view addSubview:self.passwordInstructionsLabel];
    self.passwordInstructionsLabel.hidden = YES;
    
    self.signUpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.signUpButton.frame = CGRectMake(20, 305, self.view.frame.size.width - 40, 40);
    [self.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.signUpButton addTarget:self action:@selector(signUpPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.signUpButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.signUpButton];
    self.signUpButton.hidden = YES;
}

- (void)setupLogIn {
    self.emailLogIn = [[UITextField alloc]initWithFrame:CGRectMake(20, 80, self.view.frame.size.width - 40, 40)];
    self.emailLogIn.borderStyle = UITextBorderStyleRoundedRect;
    self.emailLogIn.placeholder = @"Email";
    [self.view addSubview:self.emailLogIn];
    self.emailLogIn.hidden = YES;
    
    self.passwordLogIn = [[UITextField alloc]initWithFrame:CGRectMake(20, 130, self.view.frame.size.width - 40, 40)];
    self.passwordLogIn.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordLogIn.placeholder = @"Password";
    self.passwordLogIn.secureTextEntry = YES;
    [self.view addSubview:self.passwordLogIn];
    self.passwordLogIn.hidden = YES;
    
    self.logInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.logInButton.frame = CGRectMake(20, 180, self.view.frame.size.width - 40, 40);
    [self.logInButton setTitle:@"Log In" forState:UIControlStateNormal];
    [self.logInButton addTarget:self action:@selector(logInPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.logInButton.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.logInButton];
    self.logInButton.hidden = YES;
}

- (void)showSignUp:(UIButton *)button {
    self.showSignUp.hidden = YES;
    self.showLogIn.hidden = YES;
    
    self.backButton.hidden = NO;
    self.backButton.tag = 1;
    self.emailField.hidden = NO;
    self.passwordField.hidden = NO;
    self.signUpButton.hidden = NO;
}

- (void)showLogIn:(UIButton *)button {
    self.showSignUp.hidden = YES;
    self.showLogIn.hidden = YES;
    
    self.backButton.hidden = NO;
    self.backButton.tag = 2;
    self.emailLogIn.hidden = NO;
    self.passwordLogIn.hidden = NO;
    self.logInButton.hidden = NO;
}

- (void)signUpPressed:(UIButton *)signUpButton {
    User *newUser = [[User alloc] init];
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
    
    UserController *userController = [UserController sharedInstance];
    userController.currentUser = newUser;
    
    [userController registerInDBWithCompletion:^(BOOL success, NSString *error) {
        if (success) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)logInPressed:(UIButton *)logInButton {
    User *newUser = [[User alloc] init];
    newUser.email = self.emailLogIn.text;
    newUser.password = self.passwordLogIn.text;
    
    UserController *userController = [UserController sharedInstance];
    userController.currentUser = newUser;
    
    [userController logInUserWithCompletion:^(BOOL success, NSString *error) {
        if (success && !error) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)exitButtonPressed:(UIButton *)exitButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backButtonPressed:(UIButton *)backButton {
    if (backButton.tag == 1) {
        self.backButton.hidden = YES;
        self.backButton.tag = -1;
        self.emailField.hidden = YES;
        self.passwordField.hidden = YES;
        self.signUpButton.hidden = YES;
        
        self.showSignUp.hidden = NO;
        self.showLogIn.hidden = NO;
    } else {
        self.backButton.hidden = YES;
        self.backButton.tag = -1;
        self.emailLogIn.hidden = YES;
        self.passwordLogIn.hidden = YES;
        self.logInButton.hidden = YES;
        
        self.showSignUp.hidden = NO;
        self.showLogIn.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
