//
//  Compass.h
//  Siddur
//
//  Created by Ehud Adler on 6/1/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <coreLocation/coreLocation.h>
@interface Compass : UIView <CLLocationManagerDelegate>
{
	CLLocationManager *locationManager;
	CGFloat currentAngle;
	UIView *compassContainer;
}
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UIView *compassContainer;
@property (strong, nonatomic) IBOutlet UILabel *eastLabel;
@property (strong, nonatomic) IBOutlet UIImageView *north;
@property (strong, nonatomic) IBOutlet UIImageView *south;
@property (strong, nonatomic) IBOutlet UIImageView *east;
@property (strong, nonatomic) IBOutlet UIImageView *west;
@property (strong, nonatomic) IBOutlet UISwitch *gestureActivation;
@property (strong, nonatomic) IBOutlet UILabel *gestureLabel;

@end