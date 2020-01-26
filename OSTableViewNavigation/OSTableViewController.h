//
//  OSTableViewController.h
//  OSTableViewNavigation
//
//  Created by Sergii Onopriienko on 19.01.2020.
//  Copyright © 2020 Onopriienko Sergii. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OSTableViewController : UITableViewController

@property (strong, nonatomic) NSString *path;

-(id) initWithFolderPath:(NSString *) path;

- (IBAction)actionInfoCell:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
