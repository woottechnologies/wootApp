//
//  UsernameEditVC.m
//  wootApp
//
//  Created by Cole Wilkes on 8/11/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "UsernameEditVC.h"
#import "UIView+FLKAutoLayout.h"
#import "UserController.h"
#import "UIColor+CreateMethods.h"

@interface UsernameEditVC ()

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation UsernameEditVC

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"Username";
    self.usernameField.text = [UserController sharedInstance].currentUser.username;
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
    
    self.usernameField = [[UITextField alloc] init];
    [self.usernameField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.usernameField];
    [self.usernameField constrainHeight:@"40"];
    self.usernameField.borderStyle = UITextBorderStyleRoundedRect;
    [self.usernameField alignTop:[NSString stringWithFormat:@"%f", self.view.frame.size.height / 5] leading:@"20" toView:self.view];
    [self.usernameField alignTrailingEdgeWithView:self.view predicate:@"-20"];
    
    self.errorLabel = [[UILabel alloc] init];
    [self.view addSubview:self.errorLabel];
    [self.errorLabel constrainHeight:@"25"];
    [self.errorLabel constrainTopSpaceToView:self.usernameField predicate:@"10"];
    [self.errorLabel alignLeading:@"20" trailing:@"-20" toView:self.view];
    self.errorLabel.font = [UIFont systemFontOfSize:11];
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.saveButton.hidden = YES;
    self.usernameField.inputAccessoryView = self.saveButton;
    [self.saveButton constrainHeight:@"50"];
    [self.saveButton alignLeading:@"0" trailing:@"0" toView:self.view];
    [self.saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(savePressed) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton.backgroundColor = [UIColor colorWithHex:@"#2b58ff" alpha:1.0];
}

#pragma mark - Buttons

- (void)savePressed {
    if (self.usernameField.text.length < 4) {
        self.errorLabel.text = @"Username must be at least 4 characters.";
    } else {
        NSString *newUsername = self.usernameField.text;
        [[UserController sharedInstance] changeUsernameUsingString:newUsername andCompletion:^(BOOL success, NSString *error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.errorLabel setText:[NSString stringWithFormat:@"%@", error]];
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
    if ([textField.text isEqual:[UserController sharedInstance].currentUser.username]) {
        self.saveButton.hidden = YES;
        self.errorLabel.text = @"";
    } else {
        self.saveButton.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
