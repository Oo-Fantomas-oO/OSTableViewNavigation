//
//  OSViewControllerTableViewController.m
//  Test
//
//  Created by Sergii Onopriienko on 09.01.2020.
//  Copyright © 2020 Onopriienko Sergii. All rights reserved.
//

#import "OSViewControllerTableViewController.h"

@interface OSViewControllerTableViewController ()

@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSArray *contents;

@end

@implementation OSViewControllerTableViewController

-(id) initWithFolderPath:(NSString *) path {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.path = path;
        
        NSError *error = nil;
        self.contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path
                                                                            error:&error];
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    return self;
}

-(void) dealloc {
    NSLog(@"controller with path %@ has been daellocated", self.path);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [self.path lastPathComponent];
    
    if ([self.navigationController.viewControllers count] > 1) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Back to Root"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(actionBackToRoot:)];
        self.navigationItem.rightBarButtonItem = item;
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"path = %@", self.path);
    NSLog(@"view controllers on stack %lu", (unsigned long)[self.navigationController.viewControllers count]);
    NSLog(@"index on stack %lu", (unsigned long)[self.navigationController.viewControllers indexOfObject:self]);
}

-(BOOL) isDirectoryAtIndexPath: (NSIndexPath *) indexPath {
    
    NSString *fileName = [self.contents objectAtIndex:indexPath.row];
    
    NSString *filePath = [self.path stringByAppendingPathComponent:fileName];
    
    BOOL isDirectory = NO;
    
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
 
    return isDirectory;
}

#pragma mark - Action

-(void) actionBackToRoot:(UIBarButtonItem *) sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *fileName = [self.contents objectAtIndex:indexPath.row];
    
    cell.textLabel.text = fileName;
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        cell.imageView.image = [UIImage imageNamed:@"folder.png"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"file.png"];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        NSString *fileName = [self.contents objectAtIndex:indexPath.row];
        NSString *path = [self.path stringByAppendingPathComponent:fileName];
        OSViewControllerTableViewController *vc = [[OSViewControllerTableViewController alloc] initWithFolderPath:path];
        [self.navigationController pushViewController:vc animated:YES] ;
    }
    
}

@end
