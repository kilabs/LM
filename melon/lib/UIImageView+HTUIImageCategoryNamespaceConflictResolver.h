//
//  UIImageView+HTUIImageCategoryNamespaceConflictResolver.h
//  HotelTonight
//
//  Created by Jonathan Sibley on 7/9/13.
//  Copyright (c) 2013 Hotel Tonight. All rights reserved.
//

@interface UIImageView (HTUIImageCategoryNamespaceConflictResolver)

- (void)AF_setImageWithURL:(NSURL *)url;
- (void)AF_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;

- (void)SD_setImageWithURL:(NSURL *)url;
- (void)SD_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

@end

@interface UIImageView (HTUIImageCategoryNamespaceConflictDiscourager)

- (void)setImageWithURL:(NSURL *)url __attribute__ ((deprecated));
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage __attribute__ ((deprecated));

@end