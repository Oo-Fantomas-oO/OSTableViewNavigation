//
//  OSDummyViewController.m
//  OSTableViewNavigation
//
//  Created by Sergii Onopriienko on 21.01.2020.
//  Copyright © 2020 Onopriienko Sergii. All rights reserved.
//

#import "OSDummyViewController.h"

@interface OSDummyViewController ()

@end

@implementation OSDummyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Segue
    
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender {
    
    NSLog(@"shouldPerformSegueWithIdentifier: %@", identifier);
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
    
    NSLog(@"prepareForSegue: %@", segue.identifier);
}

@end
