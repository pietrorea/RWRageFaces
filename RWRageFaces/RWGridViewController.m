//
//  RWRageFaceViewController.m
//  RWRageFaces
//
//  Created by Pietro Rea on 4/16/13.
//  Copyright (c) 2013 Pietro Rea. All rights reserved.
//

#import "RWGridViewController.h"
#import "RWDetailViewController.h"
#import "PSTCollectionView.h"

@interface RWGridViewController () <PSUICollectionViewDataSource, PSUICollectionViewDelegateFlowLayout, NSXMLParserDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray* dictionaryKeys;
@property (strong, nonatomic) NSMutableDictionary* mutableDictionary;

//XML parser helper properties
@property (strong, nonatomic) NSString* currentCategory; 

@end

@implementation RWGridViewController

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
    
    self.mutableDictionary = [[NSMutableDictionary alloc] init];
    
    /* Construct data structure from "images.xml" */
    NSURL* xmlURL = [[NSBundle mainBundle] URLForResource:@"images" withExtension:@"xml"];
    NSXMLParser* parser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    parser.shouldProcessNamespaces = YES;
    parser.delegate = self;
    
    [parser parse];
    
    self.dictionaryKeys = [self.mutableDictionary allKeys];
    
    [self.collectionView registerClass:[PSUICollectionViewCell class] forCellWithReuseIdentifier:@"RWRageFaceCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath* indexPath = (NSIndexPath *)sender;
    NSString* categoryName = self.dictionaryKeys[indexPath.section];
    NSArray* imageNames = self.mutableDictionary[categoryName];
    
    RWDetailViewController* detailViewController = (RWDetailViewController*)segue.destinationViewController;
    detailViewController.categoryName = categoryName;
    detailViewController.imageNames = imageNames;
    detailViewController.index = indexPath.row;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


#pragma mark - UICollectionView Datasource

- (NSInteger)numberOfSectionsInCollectionView:(PSUICollectionView *)collectionView {
    return self.dictionaryKeys.count;
}

- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSString* key = self.dictionaryKeys[section];
    return [self.mutableDictionary[key] count];
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PSUICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"RWRageFaceCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.clipsToBounds = YES;
    
    NSString* key = self.dictionaryKeys[indexPath.section];
    NSString* imageName = [self.mutableDictionary[key] objectAtIndex:indexPath.row];
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    cell.backgroundView = imageView;

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(PSUICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"toDetailViewController" sender:indexPath];
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(150, 150);
}

- (UIEdgeInsets)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(50, 20, 50, 20);
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:@"category"]) {
        NSString* categoryName = attributeDict[@"name"];
        self.currentCategory = categoryName;
        self.mutableDictionary[categoryName] = [[NSMutableArray alloc] init];
    }
    
    if ([elementName isEqualToString:@"image"]) {
        NSMutableArray* array = self.mutableDictionary[self.currentCategory];
        [array addObject:attributeDict[@"name"]];
    }
    
}

@end
