    //
//  CapturePreviewViewController.m
//  RealTimeFx
//
//  Created by Greg on 7/10/10.
//  Copyright 2010 Brown University. All rights reserved.
//

#import "CapturePreviewViewController.h"


@implementation CapturePreviewViewController

@synthesize image;
@synthesize imageView;
@synthesize actionMenuView;

- (UIImage*) image
{
    return image;
}

- (void) setImage: (UIImage*) newImage;
{
    if(image != newImage)
    {
        [image release];
        image = [newImage retain];
        imageView.image = newImage;
    }
}

- (void) viewDidLoad
{
    imageView.image = image;    
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    self.actionMenuView = nil;
    imageView = nil;
}

- (void) viewDidDisappear: (BOOL)animated
{
    // Make sure the action menu is hidden
    actionMenuView.frame = CGRectMake(0,
                                      self.view.frame.size.height,
                                      actionMenuView.frame.size.width,
                                      actionMenuView.frame.size.height);
}

- (void)dealloc
{
    self.actionMenuView = nil;
    imageView = nil;
    [super dealloc];
}

- (IBAction) didTapDoneButton
{
    [[NSNotificationCenter defaultCenter] postNotificationName: @"didTapDoneButton"
                                                        object: self];
}

- (IBAction) showActionMenu
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.35];
	[UIView setAnimationDelegate:self];
    actionMenuView.frame = CGRectMake(0,
                                      self.view.frame.size.height - actionMenuView.frame.size.height,
                                      actionMenuView.frame.size.width,
                                      actionMenuView.frame.size.height);
    [UIView commitAnimations];
}

- (IBAction) hideActionMenu
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.35];
	[UIView setAnimationDelegate:self];
    actionMenuView.frame = CGRectMake(0,
                                      self.view.frame.size.height,
                                      actionMenuView.frame.size.width,
                                      actionMenuView.frame.size.height);
    [UIView commitAnimations];
}

- (IBAction) didTapSaveToCameraRollButton
{
    UIImageWriteToSavedPhotosAlbum([image retain],
                                   self,
                                   @selector(image:didFinishSavingWithError:contextInfo:),
                                   NULL);
    [[NSNotificationCenter defaultCenter] postNotificationName: @"didTapDoneButton"
                                                        object: self];    
}

#pragma mark Camera roll save completion handler

- (void) image: (UIImage*) theImage didFinishSavingWithError: (NSError*) error 
   contextInfo: (void*) contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    else
    {
        NSLog(@"Saved image successfully!");
    }
    
    [theImage release];
}

@end