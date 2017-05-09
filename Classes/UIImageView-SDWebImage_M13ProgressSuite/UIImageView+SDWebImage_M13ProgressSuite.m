//
//  UIImageView+SDWebImage_M13ProgressSuite.m
//  testSDWebImageWithProgress
//
//  Created by Jowyer on 14-6-3.
//  Copyright (c) 2014年 jo2studio. All rights reserved.
//

#import "UIImageView+SDWebImage_M13ProgressSuite.h"
#import <Masonry/Masonry.h>
#define TAG_PROGRESS_VIEW_RING 258369

@implementation UIImageView (SDWebImage_M13ProgressSuite)
#pragma mark- Private Methods
- (void)addProgressViewRingWithPrimaryColor:(UIColor *)pColor SecondaryColor:(UIColor *)sColor Diameter:(float)diameter
{
    M13ProgressViewRing *progressView = [[M13ProgressViewRing alloc] initWithFrame:CGRectMake((self.frame.size.width / 2.) - diameter / 2., (self.frame.size.height / 2.0) - diameter / 2., diameter, diameter)];
    progressView.primaryColor = pColor;
    progressView.secondaryColor = sColor;
    progressView.showPercentage = NO;
    progressView.tag = TAG_PROGRESS_VIEW_RING;
    
    [self addSubview:progressView];
    [progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(progressView.superview);
        make.width.equalTo(@(diameter));
        make.height.equalTo(@(diameter));
    }];
}

- (void)addProgressViewRingToSuperViewWithPrimaryColor:(UIColor *)pColor SecondaryColor:(UIColor *)sColor Diameter:(float)diameter
{
    M13ProgressViewRing *progressView = [[M13ProgressViewRing alloc] initWithFrame:CGRectMake((self.frame.size.width / 2.) - diameter / 2., (self.frame.size.height / 2.0) - diameter / 2., diameter, diameter)];
    progressView.primaryColor = pColor;
    progressView.secondaryColor = sColor;
    progressView.showPercentage = NO;
    progressView.tag = TAG_PROGRESS_VIEW_RING;
    
    [self.superview.superview addSubview:progressView];
    [progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(progressView.superview.superview);
        make.width.equalTo(@(diameter));
        make.height.equalTo(@(diameter));
    }];
}

- (void)updateProgressViewRing:(CGFloat)progress
{
    M13ProgressViewRing *progressView = (M13ProgressViewRing *)[self viewWithTag:TAG_PROGRESS_VIEW_RING];
    if (progressView)
    {
        [progressView setProgress:progress animated:YES];
    }
}

- (void)removeProgressViewRing
{
    M13ProgressViewRing *progressView = (M13ProgressViewRing *)[self viewWithTag:TAG_PROGRESS_VIEW_RING];
    if (progressView)
    {
        [progressView removeFromSuperview];
    }
}

- (void)updateProgressViewRingFromSuperview:(CGFloat)progress
{
    M13ProgressViewRing *progressView = (M13ProgressViewRing *)[self.superview.superview viewWithTag:TAG_PROGRESS_VIEW_RING];
    if (progressView)
    {
        [progressView setProgress:progress animated:YES];
    }
}

- (void)removeProgressViewRingFromSuperview
{
    M13ProgressViewRing *progressView = (M13ProgressViewRing *)[self.superview.superview viewWithTag:TAG_PROGRESS_VIEW_RING];
    if (progressView)
    {
        [progressView removeFromSuperview];
    }
}

#pragma mark- Public Methods
- (void)setImageUsingProgressViewRingWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageDownloaderCompletedBlock)completedBlock ProgressPrimaryColor:(UIColor *)pColor ProgressSecondaryColor:(UIColor *)sColor Diameter:(float)diameter
{
    [self addProgressViewRingWithPrimaryColor:pColor SecondaryColor:sColor Diameter:diameter];
    
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                     options:options
                    progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *url) {
        CGFloat progress = ((CGFloat)receivedSize / (CGFloat)expectedSize);
        [weakSelf updateProgressViewRing:progress];
        if (progressBlock) {
            progressBlock(receivedSize, expectedSize, nil);
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakSelf removeProgressViewRing];
        if (completedBlock) {
            completedBlock(image, nil, error, YES);
        }
    }];
}

- (void)setImageUsingProgressViewRingToSuperviewWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageDownloaderCompletedBlock)completedBlock ProgressPrimaryColor:(UIColor *)pColor ProgressSecondaryColor:(UIColor *)sColor Diameter:(float)diameter {
    [self addProgressViewRingToSuperViewWithPrimaryColor:pColor SecondaryColor:sColor Diameter:diameter];
    
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                     options:options
                    progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *url) {
                        CGFloat progress = ((CGFloat)receivedSize / (CGFloat)expectedSize);
                        [weakSelf updateProgressViewRingFromSuperview:progress];
                        if (progressBlock) {
                            progressBlock(receivedSize, expectedSize, nil);
                        }
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        [weakSelf removeProgressViewRingFromSuperview];
                        if (completedBlock) {
                            completedBlock(image, nil, error, YES);
                        }
                    }];
}

@end
