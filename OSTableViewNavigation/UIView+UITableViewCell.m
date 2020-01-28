//
//  UIView+UITableViewCell.m
//  OSTableViewNavigation
//
//  Created by Sergii Onopriienko on 28.01.2020.
//  Copyright © 2020 Onopriienko Sergii. All rights reserved.
//

#import "UIView+UITableViewCell.h"

//#import <AppKit/AppKit.h>


@implementation UIView (UITableViewCell)

-(UITableViewCell *) superCell {
    
    if (!self.superview) {
        return  nil;
    }
    
    if ([self.superview isKindOfClass:[UITableViewCell class]]) {
        return (UITableViewCell *)self.superview;
    }
    
    return [self.superview superCell];
}

@end
