//
//  SuperTorchViewController.m
//  SuperTorch
//
//  Created by John on 10/07/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "SuperTorchViewController.h"
#import	<Foundation/Foundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import	<AVFoundation/AVFoundation.h>



@implementation SuperTorchViewController

@synthesize	onOff;
@synthesize	captureManager;
@synthesize	deviceWithTorch;
@synthesize	torchIsOn;
@synthesize	bannerIsVisible;
@synthesize	adView;

- (void)viewDidLoad {
	
	[captureManager	release];
	captureManager	=	nil;
	
	captureManager	=	[[CaptureManager	alloc]	init];
	[captureManager	addVideoInput];
	[captureManager	addVideoOutput];
	[captureManager.session	startRunning];
	
	NSArray	*devices	=	[captureManager.session	inputs];
	for(AVCaptureDeviceInput *inputDevice	in	devices)	{
		if ([[inputDevice	device]	hasTorch]) {
			self.deviceWithTorch = [inputDevice	device];
		}		
	}
	
	[self	resetLabels];
	[self	moveBannerOffScreen];
	
	
    [super viewDidLoad];
}


- (void)toggleTorch:(AVCaptureTorchMode)torchMode	{
	
	if([deviceWithTorch	lockForConfiguration:nil])	{
		[deviceWithTorch	setTorchMode:torchMode];
		[deviceWithTorch	unlockForConfiguration];
	}
	
}

- (void)resetLabels	{
	
	if ([self.deviceWithTorch	torchMode]	==	AVCaptureTorchModeOn)	{
		[onOff	setTitle:@"Switch Off" forState:UIControlStateNormal];
	}
	else {
		[onOff	setTitle:@"Switch On" forState:UIControlStateNormal];
	}
}
					 					 

- (IBAction)switchFlash	{

	if ([self.deviceWithTorch	torchMode]	==	AVCaptureTorchModeOn)	{
		[self	toggleTorch:AVCaptureTorchModeOff];
		self.torchIsOn	=	NO;
		[self	resetLabels];
	}
	else {
		self.torchIsOn	=	YES;
		[self	toggleTorch:AVCaptureTorchModeOn];
		[self	resetLabels];
	}

}

- (BOOL)isTorchOn	{
	return	self.torchIsOn;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Delegate Methods for the Ad banner.

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error		{
	NSLog(@"did Fail to recieve Ad with error");
	[self	moveBannerOffScreen];
	self.bannerIsVisible	=	NO;

}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave	{
	//Can stop the Ad from being shown here but we have no reason to stop it. 
	return	YES;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner	{
	
	if(!bannerIsVisible)	{
		[self	moveBannerOntoScreen];
		self.bannerIsVisible	=	YES;
	}
}

- (void)moveBannerOffScreen	{
	adView.frame = CGRectOffset(adView.frame, 0, 50);
}

- (void)moveBannerOntoScreen	{
	[UIView beginAnimations:@"animateAdBannerOff" context:NULL];
	adView.frame = CGRectOffset(adView.frame, 0, -50);
	[UIView commitAnimations];
}


#pragma mark -


- (void)dealloc {
	[captureManager.session	stopRunning];
	[captureManager	release];
	[deviceWithTorch	release];
	[onOff	release];
	adView.delegate = nil;
	[adView	release];
    [super dealloc];
}

@end
