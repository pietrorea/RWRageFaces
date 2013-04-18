//
//  RWDetailViewController.m
//  RWRageFaces
//
//  Created by Pietro Rea on 4/17/13.
//  Copyright (c) 2013 Pietro Rea. All rights reserved.
//

#import "RWDetailViewController.h"

@interface RWDetailViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *shareButton;

@property (strong, nonatomic) UIPopoverController* popOver;

@end

@implementation RWDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.imageView.image = [UIImage imageNamed:self.imageName];
    self.navigationBar.topItem.title = self.imageName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([self.popOver isPopoverVisible]) {
        [self.popOver dismissPopoverAnimated:YES];
    }
}

- (IBAction)shareButtonTapped:(id)sender {
    
    /* Set up UIActivityViewController */
    
    NSURL* url = [NSURL URLWithString:@"http://www.raywenderlich.com"];
    NSArray* activityItems = @[self.imageName, self.imageView.image, url];
    
    UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                         applicationActivities:nil];
    
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeMessage];
    
    [activityViewController setCompletionHandler:^(NSString* activityType, BOOL completed) {
        
    }];
    
    /* Present UIActivityViewController in popover */
    
    self.popOver = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
    
    [self.popOver presentPopoverFromBarButtonItem:self.shareButton
                         permittedArrowDirections:UIPopoverArrowDirectionAny
                                         animated:YES];
}

@end
