//
//  RWDetailViewController.m
//  RWRageFaces
//
//  Created by Pietro Rea on 4/17/13.
//  Copyright (c) 2013 Pietro Rea. All rights reserved.
//

#import "RWDetailViewController.h"
#import "RWRageFaceViewController.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>

@interface RWDetailViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *shareButton;

@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UIActionSheet* actionSheet;
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
    
    /* Set the initial title */
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = [NSString stringWithFormat:@"%@: %@", self.categoryName, imageName];
    [self.titleLabel sizeToFit];
    
    self.navigationBar.topItem.titleView = self.titleLabel;
    
    /* Set initial view controller in the UIPageViewController */
    
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
    
    if ([self.actionSheet isVisible]) {
        [self.actionSheet dismissWithClickedButtonIndex:self.actionSheet.cancelButtonIndex animated:YES];
    }
}

- (IBAction)shareButtonTapped:(id)sender {
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:@"E-mail", @"Facebook", @"Twitter", @"Copy to Clipboard", nil];
    
    [self.actionSheet showFromBarButtonItem:self.shareButton animated:YES];
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

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    /* Update the nav bar's title */
    RWRageFaceViewController* currentViewController = self.pageViewController.viewControllers[0];
    self.titleLabel.text = [NSString stringWithFormat:@"%@: %@", self.categoryName, currentViewController.imageName];
    [self.titleLabel sizeToFit];
}

#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    RWRageFaceViewController* rageFaceViewController = self.pageViewController.viewControllers[0];
    NSString* imageName = rageFaceViewController.imageName;
    UIImage* image = [UIImage imageNamed:imageName];
    
    if (buttonIndex == 0) { /* E-mail*/
        
        if ([MFMailComposeViewController canSendMail]) {
            
            MFMailComposeViewController* viewController = [[MFMailComposeViewController alloc] init];
            viewController.mailComposeDelegate = self;
            
            [viewController setSubject:@"RWRageFaces"];
            [viewController setMessageBody:imageName isHTML:NO];
            
            NSData *imageData = UIImagePNGRepresentation(image);
            [viewController addAttachmentData:imageData mimeType:@"image/png" fileName:@"rage-face"];
            
            [self presentViewController:viewController animated:YES completion:nil];
        }
    }
    
    else if (buttonIndex == 1) { /* Facebook */
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            SLComposeViewController* facebookVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [facebookVC setInitialText:@"Check out this Rage Face at raywenderlich.com"];
            [facebookVC addURL:[NSURL URLWithString:@"http://www.raywenderlich.com"]];
            [facebookVC addImage:image];
            
            [self presentViewController:facebookVC animated:YES completion:nil];
        }
        
    }
    
    else if (buttonIndex == 2) { /* Twitter */
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            
            SLComposeViewController* twitterVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [twitterVC setInitialText:@"Check out this Rage Face at raywenderlich.com via @RWRageFaces"];
            [twitterVC addURL:[NSURL URLWithString:@"http://www.raywenderlich.com"]];
            [twitterVC addImage:image];
            
            [self presentViewController:twitterVC animated:YES completion:nil];
        }
        
    }
    
    else if (buttonIndex == 3) { /* Copy to Clipboard */
        [[UIPasteboard generalPasteboard] setImage:image];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
