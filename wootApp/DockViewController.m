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
#import "NSString+MoreMethods.h"
#import "AppDelegate.h"
#import "CustomTabBarVC.h"
#import "AthleteController.h"

@interface DockViewController () <UITextFieldDelegate>

// Dock
@property (nonatomic, strong) UIButton *exitButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *showSignUp;
@property (nonatomic, strong) UIButton *showLogIn;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) CustomTabBarVC *customTBVC;

// Sign Up
@property (nonatomic, strong) UITextField *firstNameField;
@property (nonatomic, strong) UITextField *lastNameField;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *passwordField;
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

    AppDelegate *appD = [[UIApplication sharedApplication] delegate];
    self.customTBVC = (CustomTabBarVC *)appD.window.rootViewController;
    
//    UIImage *backArrow = [UIImage imageNamed:@"back_arrow.png"];
//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
//    [backButton setBackgroundImage:backArrow forState:UIControlStateNormal];
//    backButton.alpha = 0.5;
//    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backArrowButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backArrowButton;
//    
    // back button
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.backButton];
    [self.backButton alignTop:@"30" leading:@"30" toView:self.view];
    [self.backButton constrainHeight:@"20"];
    [self.backButton constrainWidth:@"10"];
    [self.backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    self.backButton.hidden = YES;
    self.backButton.tag = -1;
    [self.backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // exit button
    self.exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.exitButton];
    [self.exitButton alignTopEdgeWithView:self.view predicate:@"30"];
    [self.exitButton alignTrailingEdgeWithView:self.view predicate:@"-30"];
    [self.exitButton constrainHeight:@"20"];
    [self.exitButton constrainWidth:@"20"];
    [self.exitButton setImage:[UIImage imageNamed:@"button_x.png"] forState:UIControlStateNormal];
    [self.exitButton addTarget:self action:@selector(exitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // background image
    UIImage *backgroundImage = [UIImage imageNamed:@"woot_dock"];
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
    
    // error label
    self.errorLabel = [[UILabel alloc]initWithFrame:CGRectMake(32, 265, self.view.frame.size.width - 40, 30)];
    self.errorLabel.font = [UIFont systemFontOfSize:11];
    self.errorLabel.textColor = [UIColor grayColor];
    [self.view addSubview:self.errorLabel];
    //self.errorLabel.hidden = YES;
    
    [self setupSignUp];
    [self setupLogIn];
}

- (void)setupSignUp {
    self.emailField = [[UITextField alloc]initWithFrame:CGRectMake(20, 180, self.view.frame.size.width - 40, 40)];
    self.emailField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailField.placeholder = @"Email";
    self.emailField.delegate = self;
    self.emailField.clearsOnInsertion = YES;
    [self.view addSubview:self.emailField];
    self.emailField.hidden = YES;
    
    self.passwordField = [[UITextField alloc]initWithFrame:CGRectMake(20, 230, self.view.frame.size.width - 40, 40)];
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.placeholder = @"Password";
    self.passwordField.secureTextEntry = YES;
    self.passwordField.delegate = self;
    [self.view addSubview:self.passwordField];
    self.passwordField.hidden = YES;
    
    self.signUpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.signUpButton.frame = CGRectMake(20, 305, self.view.frame.size.width - 40, 40);
    [self.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.signUpButton addTarget:self action:@selector(signUpPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.signUpButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.signUpButton];
    self.signUpButton.hidden = YES;
}

- (void)setupLogIn {
    self.emailLogIn = [[UITextField alloc]initWithFrame:CGRectMake(20, 180, self.view.frame.size.width - 40, 40)];
    self.emailLogIn.borderStyle = UITextBorderStyleRoundedRect;
    self.emailLogIn.placeholder = @"Email";
    self.emailLogIn.delegate = self;
    [self.view addSubview:self.emailLogIn];
    self.emailLogIn.hidden = YES;
    
    self.passwordLogIn = [[UITextField alloc]initWithFrame:CGRectMake(20, 230, self.view.frame.size.width - 40, 40)];
    self.passwordLogIn.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordLogIn.placeholder = @"Password";
    self.passwordLogIn.secureTextEntry = YES;
    self.passwordLogIn.delegate = self;
    [self.view addSubview:self.passwordLogIn];
    self.passwordLogIn.hidden = YES;
    
    self.logInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.logInButton.frame = CGRectMake(20, 305, self.view.frame.size.width - 40, 40);
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
            // land them wherever they were
            if (!self.followButtonType) {
                self.customTBVC.selectedViewController = self.customTBVC.childViewControllers[1];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else if ([self.followButtonType isEqualToString:@"T"]) {
                [[UserController sharedInstance] followAccount:[TeamController sharedInstance].currentTeam];
                [self dismissViewControllerAnimated:YES completion:^{
                    self.followButtonType = nil;
                }];
            } else {
                [[UserController sharedInstance] followAccount:[AthleteController sharedInstance].currentAthlete];
                [self dismissViewControllerAnimated:YES completion:^{
                    self.followButtonType = nil;
                }];
            }
        } else {
            [self.errorLabel setText:[NSString stringWithFormat:@"%@", error]];
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
        if (success) {
            // land them wherever they were
            if (!self.followButtonType) {
                self.customTBVC.selectedViewController = self.customTBVC.childViewControllers[1];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else if ([self.followButtonType isEqualToString:@"T"]) {
                if ([[UserController sharedInstance].currentUser isFollowing:[TeamController sharedInstance].currentTeam]) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [[UserController sharedInstance] followAccount:[TeamController sharedInstance].currentTeam];
                    [self dismissViewControllerAnimated:YES completion:^{
                        self.followButtonType = nil;
                    }];
                }
            } else {
                if ([[UserController sharedInstance].currentUser isFollowing:[AthleteController sharedInstance].currentAthlete]) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [[UserController sharedInstance] followAccount:[AthleteController sharedInstance].currentAthlete];
                    [self dismissViewControllerAnimated:YES completion:^{
                        self.followButtonType = nil;
                    }];
                }
            }
        } else {
            [self.errorLabel setText:[NSString stringWithFormat:@"%@", error]];
        }
    }];
}

- (void)exitButtonPressed:(UIButton *)exitButton {
    self.followButtonType = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backButtonPressed:(UIButton *)backButton {
    [self.errorLabel setText:@""];
    
    
    if (backButton.tag == 1) {
        self.backButton.hidden = YES;
        self.backButton.tag = -1;
//        self.navigationItem.leftBarButtonItem = nil;
        
        self.emailField.hidden = YES;
        self.passwordField.hidden = YES;
        self.signUpButton.hidden = YES;
        
        self.emailField.text = @"";
        self.passwordField.text = @"";
        
        self.showSignUp.hidden = NO;
        self.showLogIn.hidden = NO;
    } else {
//        self.navigationItem.leftBarButtonItem
//        self.backButton.hidden = YES;
//        self.backButton.tag = -1;
        self.emailLogIn.hidden = YES;
        self.passwordLogIn.hidden = YES;
        self.logInButton.hidden = YES;
        
        self.emailLogIn.text = @"";
        self.passwordLogIn.text = @"";
        
        self.showSignUp.hidden = NO;
        self.showLogIn.hidden = NO;
    }
}

#pragma mark - TextFieldDelegates

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.emailField]) {
        if (![textField.text isValidEmail]) {
            [self.errorLabel setText:@"Invalid email address."];
        } else {
            [self.errorLabel setText:@""];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
