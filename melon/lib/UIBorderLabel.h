//
//  UIBorderLabel.h
//  langitmusik
//
//  Created by MelOn Indonesia, PT on 12/3/13.
//  Copyright (c) 2013 mokletdev. All rights reserved.
//

@interface UIBorderLabel : UILabel
{
    CGFloat topInset;
    CGFloat leftInset;
    CGFloat bottomInset;
    CGFloat rightInset;
}

@property (nonatomic) CGFloat topInset;
@property (nonatomic) CGFloat leftInset;
@property (nonatomic) CGFloat bottomInset;
@property (nonatomic) CGFloat rightInset;

@end
