//
//  ComposePostViewController.m
//  wootApp
//
//  Created by Cole Wilkes on 8/14/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "ComposePostViewController.h"
#import "UIView+FLKAutoLayout.h"
#import "PostController.h"
@import MobileCoreServices;
@import MediaPlayer;

@interface ComposePostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITextView *postText;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIButton *hideKeyboard;
@property (nonatomic, strong) NSLayoutConstraint *postTextHeight;
@property (nonatomic, strong) NSLayoutConstraint *imageViewHeight;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ComposePostViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.postText becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *exitImage = [UIImage imageNamed:@"button_x.png"];
    UIButton *exit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [exit setBackgroundImage:exitImage forState:UIControlStateNormal];
    exit.alpha = 0.5;
    [exit addTarget:self action:@selector(exitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *exitButton =[[UIBarButtonItem alloc] initWithCustomView:exit];
    self.navigationItem.rightBarButtonItem = exitButton;
    
//    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [self.view addSubview:self.scrollView];
//    [self.scrollView alignLeading:@"0" trailing:@"0" toView:self.view];
//    [self.scrollView alignTopEdgeWithView:self.view predicate:@"0"];
//    [self.scrollView constrainHeight:[NSString stringWithFormat:@"%f", self.view.frame.size.height]];
//    
//    // image view
//    self.imageView = [[UIImageView alloc] init];
//    [self.scrollView addSubview:self.imageView];
//    [self.imageView alignLeading:@"10" trailing:@"-10" toView:self.scrollView];
//    [self.imageView alignTopEdgeWithView:self.scrollView predicate:@"64"];
//    self.imageViewHeight = [[self.imageView constrainHeight:@"0"] objectAtIndex:0];
//    
//    // post text
//    self.postText = [[UITextView alloc] init];
//    [self.scrollView addSubview:self.postText];
//    [self.postText constrainTopSpaceToView:self.imageView predicate:@"0"];
//    [self.postText alignLeading:@"0" trailing:@"0" toView:self.scrollView];
//    self.postTextHeight = [[self.postText constrainHeight:@"35"] objectAtIndex:0];
//    self.postText.backgroundColor = [UIColor lightGrayColor];
//    self.postText.font = [UIFont systemFontOfSize:16.0];
//    self.postText.delegate = self;
//    self.postText.scrollEnabled = NO;
    
    // image view
    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
    [self.imageView alignLeading:@"10" trailing:@"-10" toView:self.view];
    [self.imageView alignTopEdgeWithView:self.view predicate:@"64"];
    self.imageViewHeight = [[self.imageView constrainHeight:@"0"] objectAtIndex:0];
    
    // post text
    self.postText = [[UITextView alloc] init];
    [self.view addSubview:self.postText];
    [self.postText constrainTopSpaceToView:self.imageView predicate:@"0"];
    //[self.postText alignTopEdgeWithView:self.view predicate:@"64"];
    [self.postText alignLeading:@"0" trailing:@"0" toView:self.view];
    self. postTextHeight = [[self.postText constrainHeight:@"35"] objectAtIndex:0];
    self.postText.backgroundColor = [UIColor lightGrayColor];
    self.postText.font = [UIFont systemFontOfSize:16.0];
    self.postText.delegate = self;
    self.postText.scrollEnabled = NO;
    
    // dismiss keyboard button
    self.hideKeyboard = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:self.hideKeyboard];
    [self.hideKeyboard constrainTopSpaceToView:self.postText predicate:@"0"];
    [self.hideKeyboard alignLeading:@"0" trailing:@"0" toView:self.view];
    [self.hideKeyboard alignBottomEdgeWithView:self.view predicate:@"0"];
    [self.hideKeyboard addTarget:self action:@selector(hideKeyboardPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardOn:) name:UIKeyboardWillShowNotification object:nil];
    
    // image picker
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    self.imagePicker.delegate = self;
    
    // for movies too
    //self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    
    // tool bar
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.barTintColor = [UIColor darkGrayColor];
    [self.view addSubview:toolbar];
    [toolbar alignLeading:@"0" trailing:@"0" toView:self.view];
    //[toolbar constrainTopSpaceToView:self.imageView predicate:@"0"];
    [toolbar removeFromSuperview];
    self.postText.inputAccessoryView = toolbar;
    
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraButtonPressed:)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"POST" style:UIBarButtonItemStylePlain target:self action:@selector(postButtonPressed:)];
    
    //[toolbar setItems:@[cameraButton, flexible, postButton] animated:NO];
    toolbar.items = @[cameraButton, flexible, postButton];
}

#pragma mark - Buttons

- (void)exitButtonPressed:(UIButton *)exit {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraButtonPressed:(UIButton *)camera {
    [self.postText resignFirstResponder];
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)postButtonPressed:(UIButton *)post {
    PostController *postController = [PostController sharedInstance];
    
    postController.currentPost = [[Post alloc] init];
    postController.currentPost.text = self.postText.text;
    postController.currentPost.photo = self.imageView.image;
    postController.currentPost.timestamp = [NSDate new];
    
    [postController uploadImage:UIImageJPEGRepresentation(self.imageView.image, 1.0) filename:@"image_post_success" withCompletion:^(BOOL success, NSString *error) {
        if (success) {
            NSLog(@"worked");
        } else {
            NSLog(@"no good");
        }
    }];

//    [postController addPostWithCompletion:^(BOOL success, NSString *error) {
//        if (success) {
//            // do blah
//        }
//    }];
}

- (void)hideKeyboardPressed:(UIButton *)button {
    NSLog(@"button");
}

#pragma mark - Image Picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
//    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
//        NSURL *videoUrl = (NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
//        NSString *moviePath = [videoUrl path];
//        
//        MPMoviePlayerController *movieplayer =[[MPMoviePlayerController alloc] initWithContentURL: videoUrl];
//        [[movieplayer view] setFrame: [self.view bounds]];
//        [self.view addSubview: [movieplayer view]];
//        [movieplayer play];
//        
//    } else {
//        UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
//        
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.postText.text];
//        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
//        textAttachment.image = chosenImage;
//        
//        CGFloat oldWidth = textAttachment.image.size.width;
//        
//        //I'm subtracting 10px to make the image display nicely, accounting
//        //for the padding inside the textView
//        CGFloat scaleFactor = oldWidth / (self.postText.frame.size.width - 10);
//        textAttachment.image = [UIImage imageWithCGImage:textAttachment.image.CGImage scale:scaleFactor orientation:UIImageOrientationUp];
//        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
//        [attributedString appendAttributedString:attrStringWithImage];
//        self.postText.attributedText = attributedString;
//    }
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    CGFloat oldWidth = chosenImage.size.width;
    CGFloat scaleFactor = oldWidth / (self.view.frame.size.width - 10);
    
    chosenImage = [UIImage imageWithCGImage:chosenImage.CGImage scale:scaleFactor orientation:UIImageOrientationUp];
    
    [self.imageView removeConstraint:self.imageViewHeight];
    self.imageViewHeight = [[self.imageView constrainHeight:[NSString stringWithFormat:@"%f", chosenImage.size.height]] objectAtIndex:0];
    self.imageView.image = chosenImage;
    
    [self.view updateConstraints];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - text view delegate

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
    
    [self.postText removeConstraint:self.postTextHeight];
    self.postTextHeight = [[self.postText constrainHeight:[NSString stringWithFormat:@"%f", newFrame.size.height]] objectAtIndex:0];
    
    [self.view updateConstraints];
}

#pragma mark - notifications

- (void)keyboardOn:(NSNotification *)notification {
    
}

- (void)keyboardOff:(NSNotification *)notification {
    
}

#pragma mark - extra

//- (void)viewDidLayoutSubviews {
//    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 2)];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
