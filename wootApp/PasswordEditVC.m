//
//  PasswordEditVC.m
//  wootApp
//
//  Created by Cole Wilkes on 8/11/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "PasswordEditVC.h"
#import "UserController.h"
#import "UIView+FLKAutoLayout.h"
#import "UIColor+CreateMethods.h"

@interface PasswordEditVC ()

@property (nonatomic, strong) UITextField *currentPasswordField;
@property (nonatomic, strong) UITextField *passwordChangeField;
@property (nonatomic, strong) UITextField *passwordConfirmField;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UILabel *errorLabel1;
@property (nonatomic, strong) UILabel *errorLabel2;

@end

@implementation PasswordEditVC

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"My Password";
    self.currentPasswordField.placeholder = @"Please enter your current password.";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *backArrow = [UIImage imageNamed:@"back_arrow.png"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    [backButton setBackgroundImage:backArrow forState:UIControlStateNormal];
    backButton.alpha = 0.5;
    [backButton addTarget:self action:@selector(backButtonPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backArrowButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backArrowButton;
    
    // current password
    self.currentPasswordField = [[UITextField alloc] init];
    [self.view addSubview:self.currentPasswordField];
    [self.currentPasswordField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.currentPasswordField constrainHeight:@"40"];
    self.currentPasswordField.borderStyle = UITextBorderStyleRoundedRect;
    [self.currentPasswordField alignTop:[NSString stringWithFormat:@"%f", self.view.frame.size.height / 5] leading:@"20" toView:self.view];
    [self.currentPasswordField alignTrailingEdgeWithView:self.view predicate:@"-20"];
    
    // new password
    self.passwordChangeField = [[UITextField alloc] init];
    self.passwordChangeField.hidden = YES;
    self.passwordChangeField.placeholder = @"New Password";
    [self.view addSubview:self.passwordChangeField];
    [self.passwordChangeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordChangeField constrainHeight:@"40"];
    self.passwordChangeField.borderStyle = UITextBorderStyleRoundedRect;
    [self.passwordChangeField alignTop:[NSString stringWithFormat:@"%f", self.view.frame.size.height / 5] leading:@"20" toView:self.view];
    [self.passwordChangeField alignTrailingEdgeWithView:self.view predicate:@"-20"];
    
    // new password confirmed
    self.passwordConfirmField = [[UITextField alloc] init];
    self.passwordConfirmField.hidden = YES;
    self.passwordConfirmField.placeholder = @"New Password Confirmed";
    [self.view addSubview:self.passwordConfirmField];
    [self.passwordConfirmField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordConfirmField constrainHeight:@"40"];
    self.passwordConfirmField.borderStyle = UITextBorderStyleRoundedRect;
    [self.passwordConfirmField constrainTopSpaceToView:self.passwordChangeField predicate:@"20"];
    [self.passwordConfirmField alignLeading:@"20" trailing:@"-20" toView:self.view];
    
    // error labels
    self.errorLabel1 = [[UILabel alloc] init];
    [self.view addSubview:self.errorLabel1];
    [self.errorLabel1 constrainHeight:@"25"];
    [self.errorLabel1 constrainTopSpaceToView:self.currentPasswordField predicate:@"10"];
    [self.errorLabel1 alignLeading:@"20" trailing:@"-20" toView:self.view];
    self.errorLabel1.font = [UIFont systemFontOfSize:11];
    
    self.errorLabel2 = [[UILabel alloc] init];
    self.errorLabel2.hidden = YES;
    [self.view addSubview:self.errorLabel2];
    [self.errorLabel2 constrainHeight:@"25"];
    [self.errorLabel2 constrainTopSpaceToView:self.passwordConfirmField predicate:@"10"];
    [self.errorLabel2 alignLeading:@"20" trailing:@"-20" toView:self.view];
    self.errorLabel2.font = [UIFont systemFontOfSize:11];
    
    // buttons
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.currentPasswordField.inputAccessoryView = self.confirmButton;
    self.confirmButton.hidden = YES;
    [self.confirmButton constrainHeight:@"50"];
    [self.confirmButton alignLeading:@"0" trailing:@"0" toView:self.view];
    [self.confirmButton setTitle:@"CONFIRM" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(confirmPressed) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.backgroundColor = [UIColor colorWithHex:@"#2bff80" alpha:1.0];
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.passwordChangeField.inputAccessoryView = self.saveButton;
    self.passwordConfirmField.inputAccessoryView = self.saveButton;
    [self.saveButton constrainHeight:@"50"];
    [self.saveButton alignLeading:@"0" trailing:@"0" toView:self.view];
    [self.saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(savePressed) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton.backgroundColor = [UIColor colorWithHex:@"#2b58ff" alpha:1.0];
}

#pragma mark - Buttons

- (void)confirmPressed {
    [[UserController sharedInstance] confirmPasswordUsingString:self.currentPasswordField.text andCompletion:^(BOOL success, NSString *error) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.currentPasswordField.hidden = YES;
                self.errorLabel1.hidden = YES;
                self.confirmButton.hidden = YES;
                
                self.passwordChangeField.hidden = NO;
                self.passwordConfirmField.hidden = NO;
                self.errorLabel2.hidden = NO;
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.errorLabel1.text = error;
            });
        }
    }];
}

- (void)savePressed {
    
    if (![self.passwordChangeField.text isEqual:self.passwordConfirmField.text]) {
        self.errorLabel2.text = @"Password do not match.";
    } else if (self.passwordConfirmField.text.length < 5){
        self.errorLabel2.text = @"Password must be at least 5 characters.";
    } else {
        // change password
        [[UserController sharedInstance] changePasswordUsingString:self.passwordConfirmField.text andCompletion:^(BOOL success, NSString *error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.errorLabel2.text = error;
                });
            }
        }];
    }
}

- (void)backButtonPressed:(UIButton *)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TextField

- (void)textFieldDidChange:(UITextField *)textField {
    if (self.currentPasswordField.text.length > 0) {
        self.confirmButton.hidden = NO;
    } else {
        self.confirmButton.hidden = YES;
    }
    
    if (self.passwordChangeField.text.length > 0 && self.passwordConfirmField.text.length > 0) {
        self.saveButton.hidden = NO;
    } else {
        self.saveButton.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
