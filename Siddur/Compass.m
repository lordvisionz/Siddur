//
//  Compass.m
//  Siddur
//
//  Created by Ehud Adler on 6/1/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import "Compass.h"
#import <QuartzCore/QuartzCore.h>
#define degreesToRadians(x) (M_PI * x / 180.0)

@implementation Compass
@synthesize locationManager;
@synthesize compassContainer;
- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
			//[self startUp];
	
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
				[self startUp];

	}
	return self;
}

- (void)startUp
{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
		BOOL gestureOn = [prefs boolForKey:@"gestComp"];
		NSLog(@"OKOK");
		if(gestureOn){
			NSLog(@"ON");
			[self.gestureActivation setOn:YES animated:YES];
		}else{
			NSLog(@"OFF");
			[self.gestureActivation setOn:NO animated:YES];
			
		}
		
		BOOL first = [prefs boolForKey:@"first"];
		
		if(first){
			
		}else{
			
			if(self.gestureActivation.on){
				
				self.gestureLabel.text = @"Flip phone up to exit";
				
			}else{
				
				self.gestureLabel.text = @"Tap to exit";
			}
		}
	});
	self.eastLabel.alpha = .2;
	NSLog(@"HELLO");
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
			// Use one or the other, not both. Depending on what you put in info.plist
		
		[self.locationManager requestAlwaysAuthorization];
	}
	
	self.locationManager = [[CLLocationManager alloc]init];
	self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[self.locationManager startUpdatingHeading];
	
	[self startUpdating];
	
}
- (void)layoutSubviews {
	[super layoutSubviews];
	
	
	
	
}
- (void) startUpdating
{
	NSLog(@"starting");
	
	[self.locationManager startUpdatingHeading];
}


#pragma mark -
#pragma mark Geo Points methods

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
	
	NSInteger magneticAngle = newHeading.magneticHeading;
	NSInteger trueAngle = newHeading.trueHeading;
	
	
 
		//This is set by a switch in my apps settings //
 
	NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
	BOOL magneticNorth = [prefs boolForKey:@"UseMagneticNorth"];
 
	if (magneticNorth == YES) {
		NSLog(@"using magnetic north");
		
		CGAffineTransform rotate = CGAffineTransformMakeRotation(degreesToRadians(-magneticAngle));
		[compassContainer setTransform:rotate];
	}
	else {
		[UIView animateWithDuration:1.0f animations:^{
			CGAffineTransform rotate = CGAffineTransformMakeRotation(degreesToRadians(trueAngle));
			[self.north setTransform:rotate];
			[self.south setTransform:rotate];
			[self.east setTransform:rotate];
			[self.west setTransform:rotate];

			
		}];
		[UIView animateWithDuration:.7f animations:^{
		CGAffineTransform rotate = CGAffineTransformMakeRotation(degreesToRadians(-trueAngle));
		[compassContainer setTransform:rotate];
			if(trueAngle > 70 && trueAngle < 110){
				self.backgroundColor = [UIColor greenColor];
				self.eastLabel.alpha = 1;
				
			}else{
				self.backgroundColor = [UIColor blackColor];
				self.eastLabel.alpha = .2;
			}
		}];
	}
}
- (IBAction)onOffSwitch:(id)sender {
	NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
	BOOL first = [prefs boolForKey:@"first"];
	
	if(first){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Gesture Activation"
												 message:NSLocalizedString( @"Place the phone face up to activate the compass.", @"This can be done anywhere in the app")
							 delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		
		
		[alert show];

		[prefs setBool:NO forKey:@"first"];
		self.gestureLabel.text = @"Gesture Ready!";
	}else{
		
	if(self.gestureActivation.on){
		
		self.gestureLabel.text = @"Flip phone up to exit";

	}else{
		
		self.gestureLabel.text = @"Tap to exit";
	}
	}
	
	if(self.gestureActivation.on){

		[prefs setBool:YES forKey:@"gestComp"];
		
	}else{
		[prefs setBool:NO forKey:@"gestComp"];
	}
	[prefs synchronize];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
		[self removeFromSuperview];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"dismissedXib"
														object:nil
													  userInfo:nil];

}
@end