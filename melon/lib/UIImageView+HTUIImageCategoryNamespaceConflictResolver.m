//
//  UIImageView+HTUIImageCategoryNamespaceConflictResolver.m
//  HotelTonight
//
//  Created by Jonathan Sibley on 7/9/13.
//  Copyright (c) 2013 Hotel Tonight. All rights reserved.
//

#import "UIImageView+HTUIImageCategoryNamespaceConflictResolver.h"
#import "UIImageView+AFNetworking.h"
//#import "SDWebImage/UIImageView+WebCache.h"

@implementation UIImageView (HTUIImageCategoryNamespaceConflictResolver)
//
//#pragma mark - AFNetworking UIImageView category
//
//- (void)AF_setImageWithURL:(NSURL *)url {
//    [self AF_setImageWithURL:url placeholderImage:nil];
//}
//
//- (void)AF_setImageWithURL:(NSURL *)url
//          placeholderImage:(UIImage *)placeholderImage
//{
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPShouldHandleCookies:NO];
//    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
//    
//    [self setImageWithURLRequest:request placeholderImage:placeholderImage success:nil failure:nil];
//}
//
//#pragma mark - SDWebImage UIImageView category
//
//- (void)SD_setImageWithURL:(NSURL *)url
//{
//   // [self setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
//}
//
//- (void)SD_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
//{
//    [self setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
//}

@end