//
//  RWRageFaceViewController.m
//  RWRageFaces
//
//  Created by Pietro Rea on 4/20/13.
//  Copyright (c) 2013 Pietro Rea. All rights reserved.
//

#import "RWRageFaceViewController.h"

@interface RWRageFaceViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *imageLabel;

@end

@implementation RWRageFaceViewController

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
    
//    NSString* titleString = [NSString stringWithFormat:@"%@: %@", self.categoryName, self.imageName];
//    NSMutableAttributedString* attributedTitle = [[NSMutableAttributedString alloc] initWithString:titleString];
//    
//    NSRange categoryRange = [titleString rangeOfString:[NSString stringWithFormat:@"%@: ", self.categoryName]];
//    NSRange titleRange = [titleString rangeOfString:[NSString stringWithFormat:@"%@", self.imageName]];
//    
//    [attributedTitle addAttribute:NSForegroundColorAttributeName
//                            value:[UIColor redColor]
//                            range:categoryRange];
//    
//    [attributedTitle addAttribute:NSForegroundColorAttributeName
//                            value:[UIColor whiteColor]
//                            range:titleRange];
//    
//    self.imageLabel.attributedText = attributedTitle;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
