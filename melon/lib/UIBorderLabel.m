//
//  UIBorderLabel.m
//  langitmusik
//
//  Created by MelOn Indonesia, PT on 12/3/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

#import "UIBorderLabel.h"
@implementation UIBorderLabel

@synthesize topInset, leftInset, bottomInset, rightInset;

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {self.topInset, self.leftInset,
        self.bottomInset, self.rightInset};
    
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
