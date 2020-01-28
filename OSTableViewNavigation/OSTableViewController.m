//
//  OSTableViewController.m
//  OSTableViewNavigation
//
//  Created by Sergii Onopriienko on 19.01.2020.
//  Copyright © 2020 Onopriienko Sergii. All rights reserved.
//

#import "OSTableViewController.h"
#import "OSFileCell.h"
#import "UIView+UITableViewCell.h"

@interface OSTableViewController ()

@property (strong, nonatomic) NSArray *contents;
@property (strong, nonatomic) NSString *selectedPath;

@end

@implementation OSTableViewController

-(id) initWithFolderPath:(NSString *) path {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.path = path;
    }
    return self;
}

-(void) setPath:(NSString *)path {
    
    _path = path;
    
    NSError *error = nil;
    self.contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path
                                                                        error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    [self.tableView reloadData];
    
    self.navigationItem.title = [self.path lastPathComponent];
    
}

-(void) dealloc {
    NSLog(@"controller with path %@ has been daellocated", self.path);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.path) {
        self.path = @"/Users/sergii.onopriienko/Documents/ObjCodeExample";
    }
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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


- (IBAction)actionInfoCell:(UIButton *)sender {
    
    NSLog(@"actionInfoCell");
    
    UITableViewCell *cell = [sender superCell];
    
    if (cell) {
        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"NumberOfCell"
                                                                       message:[NSString stringWithFormat:@"section %ld row %ld", indexPath.section, indexPath.row]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"OK button is present");
        }];
        
        //NSLog(@"action %ld %ld", indexPath.section, indexPath.row);
        [alert addAction:actionOk];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

-(NSString *) fileSizeFromValue:(unsigned long long) size {
    
    static NSString *units[] = {@"B", @"KB", @"MB", @"GB", @"TB"};
    static int unitsCount = 5;
        
    double fileSize = (double)size;
    
    int index = 0;
    while (fileSize > 1024 && index < unitsCount) {
        fileSize /= 1024;
        index++;
    }
    
    return [NSString stringWithFormat:@"%.2f %@", fileSize, units[index]];
    
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *fileIdentifier = @"FileCell";
    static NSString *folderIdentifier = @"FolderCell";
    
    NSString *fileName = [self.contents objectAtIndex:indexPath.row];
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:folderIdentifier];
    
        cell.textLabel.text = fileName;
        
        return cell;
        
    } else {
        
        NSString *path = [self.path stringByAppendingPathComponent:fileName];
        
        NSDictionary *atributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        
        OSFileCell *cell = [tableView dequeueReusableCellWithIdentifier:fileIdentifier];
        
        
        cell.nameLabel.text = fileName;
        cell.sizeLabel.text = [self fileSizeFromValue:[atributes fileSize]];
        
        static NSDateFormatter *dateFormatter = nil;
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
        }
        cell.dateLabel.text = [dateFormatter stringFromDate:[atributes fileModificationDate]];
        
        return cell;
    }

    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        return 44.f;
    } else {
        return 80.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        NSString *fileName = [self.contents objectAtIndex:indexPath.row];
        NSString *path = [self.path stringByAppendingPathComponent:fileName];
//        OSTableViewController *vc = [[OSTableViewController alloc] initWithFolderPath:path];
//        [self.navigationController pushViewController:vc animated:YES] ;//в коде без storyboard
        
//        OSTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OSTableViewController"];
//        vc.path = path;
//        [self.navigationController pushViewController:vc animated:YES] ;//инициализация с storyboard
        
        self.selectedPath = path;
        
        [self performSegueWithIdentifier:@"navigateDeep" sender:nil];
    }
    
}

#pragma mark - Segue
    
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender {
    
    NSLog(@"shouldPerformSegueWithIdentifier: %@", identifier);
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
    NSLog(@"prepareForSegue: %@", segue.identifier);
    
    OSTableViewController *vc = segue.destinationViewController;
    vc.path = self.selectedPath;
}

@end
