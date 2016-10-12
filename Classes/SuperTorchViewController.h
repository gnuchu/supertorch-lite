//
//  SuperTorchViewController.h
//  SuperTorch
//
//  Created by John on 10/07/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	<AVFoundation/AVCaptureSession.h>
#import	<iAd/iAd.h>

#import	"CaptureManager.h"


@interface SuperTorchViewController : UIViewController	{
	
	UIButton	*onOff;
	BOOL		torchIsOn;
	
	BOOL		bannerIsVisible;
	
	CaptureManager	*captureManager;
	AVCaptureDevice	*deviceWithTorch;
	
	ADBannerView *adView;
}

@property	(nonatomic, retain)	IBOutlet	UIButton	*onOff;
@property	(nonatomic,retain)	CaptureManager	*captureManager;
@property	(nonatomic, retain)	AVCaptureDevice	*deviceWithTorch;

@property	(nonatomic)	BOOL	torchIsOn, bannerIsVisible;

@property	(nonatomic, retain)	IBOutlet ADBannerView	*adView;


- (IBAction)switchFlash;
- (void)resetLabels;
- (BOOL)isTorchOn;
- (void)toggleTorch:(AVCaptureTorchMode)torchMode;
- (void)moveBannerOffScreen;
- (void)moveBannerOntoScreen;


@end

