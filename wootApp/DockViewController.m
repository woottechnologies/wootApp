//
//  DockViewController.m
//  wootApp
//
//  Created by Cole Wilkes on 6/23/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "DockViewController.h"
#import "UserController.h"

@interface DockViewController ()

// Dock
@property (nonatomic, strong) UIButton *exitButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *signUpButton;
@property (nonatomic, strong) UIButton *logInButton;

// Sign Up
@property (nonatomic, strong) UITextField *firstNameField;
@property (nonatomic, strong) UITextField *lastNameField;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UILabel *passwordInstructionsLabel;
@property (nonatomic, strong) UIButton *createUserButton;

// Log In

@end

@implementation DockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.exitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.exitButton.frame = CGRectMake(self.view.frame.size.width - 60, 30, 30, 30);
    self.exitButton.backgroundColor = [UIColor redColor];
    [self.exitButton setTitle:@"X" forState:UIControlStateNormal];
    [self.exitButton addTarget:self action:@selector(exitTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.exitButton];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"oregon"];
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:backgroundImage];
    backgroundImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
    
    self.signUpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.signUpButton.frame = CGRectMake(20, 520, self.view.frame.size.width - 40, 50);
    [self.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.signUpButton addTarget:self action:@selector(signUpPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.signUpButton.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.signUpButton];
    
    self.logInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.logInButton.frame = CGRectMake(20, 590, self.view.frame.size.width - 40, 50);
    [self.logInButton setTitle:@"Log In" forState:UIControlStateNormal];
    [self.logInButton addTarget:self action:@selector(logInPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.logInButton.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.logInButton];
    
    [self setupSignUp];
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
    
    self.createUserButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.createUserButton.frame = CGRectMake(20, 305, self.view.frame.size.width - 40, 40);
    [self.createUserButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.createUserButton addTarget:self action:@selector(createButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.createUserButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.createUserButton];
    self.createUserButton.hidden = YES;
}

- (void)signUpPressed:(UIButton *)button {
    self.signUpButton.hidden = YES;
    self.logInButton.hidden = YES;
    
    self.emailField.hidden = NO;
    self.passwordField.hidden = NO;
    self.createUserButton.hidden = NO;
}

- (void)logInPressed:(UIButton *)button {
    
}

- (void)createButtonPressed {
    User *newUser = [[User alloc] init];
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
    
    UserController *userController = [UserController sharedInstance];
    userController.currentUser = newUser;
    
    [userController registerInDBWithCompletion:^(BOOL success) {
        if (success) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)exitTapped:(UIBarButtonItem *)exit{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
