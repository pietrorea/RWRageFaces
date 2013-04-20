//
//  RWDetailViewController.m
//  RWRageFaces
//
//  Created by Pietro Rea on 4/17/13.
//  Copyright (c) 2013 Pietro Rea. All rights reserved.
//

#import "RWDetailViewController.h"
#import "RWRageFaceViewController.h"

@interface RWDetailViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *shareButton;

@property (strong, nonatomic) UIPopoverController* popOver;
@property (strong, nonatomic) UIActivityViewController* activityViewController;
@property (strong, nonatomic) UIPageViewController* pageViewController;

@end

@implementation RWDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSString* imageName = self.imageNames[self.index];
    self.navigationBar.topItem.title = imageName;
    
    RWRageFaceViewController* rageFaceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RWRageFaceViewController"];
    
    rageFaceViewController.index = self.index;
    rageFaceViewController.imageName = imageName;
    
    [self.pageViewController setViewControllers:@[rageFaceViewController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"embedPageViewController"]) {
        self.pageViewController = segue.destinationViewController;
        self.pageViewController.dataSource = self;
        self.pageViewController.delegate = self;
    }
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
    
//    NSURL* url = [NSURL URLWithString:@"http://www.raywenderlich.com"];
//    NSArray* activityItems = @[self.imageName, self.imageView.image, url];
//    
//    self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
//                                                                    applicationActivities:nil];
//    
//    self.activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeMessage];
//    
//    /* Present UIActivityViewController in popover */
//    
//    self.popOver = [[UIPopoverController alloc] initWithContentViewController:self.activityViewController];
//    
//    [self.popOver presentPopoverFromBarButtonItem:self.shareButton
//                         permittedArrowDirections:UIPopoverArrowDirectionAny
//                                         animated:YES];
}

#pragma mark - UIPageviewControllerDataSource / Delegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    RWRageFaceViewController* previousViewControlelr = (RWRageFaceViewController *)viewController;
    if (previousViewControlelr.index >= self.imageNames.count - 1) return nil;
    
    RWRageFaceViewController* rageFaceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RWRageFaceViewController"];
    
    rageFaceViewController.index = previousViewControlelr.index + 1;
    rageFaceViewController.imageName = self.imageNames[previousViewControlelr.index + 1];

    return rageFaceViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    RWRageFaceViewController* nextViewController = (RWRageFaceViewController *)viewController;
    if (nextViewController.index == 0) return nil;

    RWRageFaceViewController* rageFaceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RWRageFaceViewController"];
    
    rageFaceViewController.index = nextViewController.index - 1;
    rageFaceViewController.imageName = self.imageNames[nextViewController.index - 1];
    
    return rageFaceViewController;
}

@end
