	//
	//  ViewController.m
	//  Siddur
	//
	//  Created by Ehud Adler on 2/12/15.
	//  Copyright (c) 2015 Ehud Adler. All rights reserved.
	//

#import "ViewController.h"
#import <EDSunriseSet.h>
#import "DaveningPage.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "KCParashatHashavuaCalculator.h"
#import "KCParasha.h"
#import "KCJewishCalendar.h"
#import "KCJewishHoliday.h"
#import "KCJewishHolidays.h"

@interface ViewController ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet iCarousel *carouselView;
@property (weak, nonatomic) IBOutlet UIView *Selectview;

@end


@implementation ViewController{
	NSArray *array;
	NSString *sunRise;
	NSString *sunSet;
	NSString *timeNow;
	int toIndex;
	long *toDaven;
	
}
-(void)viewWillAppear:(BOOL)animated{
	self.navigationController.hidesBarsOnSwipe = YES;
	self.navigationController.navigationBar.hidden = YES;
	
}

- (void)viewDidLoad
{
	
	[super viewDidLoad];
	
	KCParashatHashavuaCalculator *parashaCalculator = [[KCParashatHashavuaCalculator alloc] init];
	KCParasha *parasha = [parashaCalculator parashaInDiasporaForDate:[NSDate date]];
	
	KCJewishCalendar *calendar = [[KCJewishCalendar alloc] init];
	
	BOOL isPesach = [calendar isPesach];
	BOOL isHoliday = [calendar isYomTov];
	
	if (isHoliday) {
		self.holiday.text = @"Today is a holiday";
	}else if(isPesach){
		self.holiday.text = @"Today Pesach";
	}else{
		self.holiday.text = @"";

	}
	NSLog(@"PARSHA: %@",parasha.name);
	self.parshaToday.text = parasha.name;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange) name: UIDeviceOrientationDidChangeNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(navUnhide)
												 name:@"dismissedXib"
											   object:nil];
	
	array = @[@"Shacharit",@"Mincha",@"Maariv",@"Zmanim",@"Compass"];
	self.carouselView.dataSource=self;
	self.carouselView.delegate=self;
	self.carouselView.type=iCarouselTypeCoverFlow;
	[self.carouselView scrollToItemAtIndex:1 animated:NO];
	[self.carouselView scrollToItemAtIndex:0 animated:NO];
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
		// Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
	if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
		[self.locationManager requestAlwaysAuthorization];
	}
	[self.locationManager startUpdatingLocation];
}

	// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	
	CLLocation *location = [locations lastObject];
	
	float latitude = location.coordinate.latitude;
	float longitude = location.coordinate.longitude;
	
	NSTimeZone *timeZone = [NSTimeZone localTimeZone];
	
	
	EDSunriseSet *edSunriseSet = [EDSunriseSet sunrisesetWithTimezone:timeZone latitude:latitude longitude:longitude];
	
	
	[edSunriseSet calculateSunriseSunset:[NSDate date]];
	
	
	
	sunRise = [NSString stringWithFormat:@"%ld%ld",(long)edSunriseSet.localSunrise.hour,(long)edSunriseSet.localSunrise.minute];
	
	sunSet = [NSString stringWithFormat:@"%ld%ld",(long)edSunriseSet.localSunset.hour,(long)edSunriseSet.localSunset.minute];
	
	NSDate *currentTime = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"HH-mm"];
	
	NSString *resultString = [dateFormatter stringFromDate: currentTime];
	NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"-"];
	timeNow = [[resultString componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
	
	
	NSLog(@"Today's Sunrise:  %@, Sunset:  %@, CurrentTime:  %@",sunRise,sunSet,timeNow);
	
	
	
	if([timeNow integerValue] < [sunRise integerValue]+600 && [timeNow integerValue] > [sunRise integerValue]){
		NSLog(@"Shacharit");
		[self.carouselView scrollToItemAtIndex:0 animated:YES];
	}else if ([timeNow integerValue] > [sunRise integerValue]+600 && [timeNow integerValue] < [sunSet integerValue]){
		NSLog(@"Mincha");
		[self.carouselView scrollToItemAtIndex:1 animated:YES];
	}else{
		NSLog(@"Maariv");
		[self.carouselView scrollToItemAtIndex:2 animated:YES];
	}
	[self.locationManager stopUpdatingLocation];
	
	
}

- (IBAction)checkNow:(id)sender {
	
	if([timeNow integerValue] < [sunRise integerValue]+600 && [timeNow integerValue] > [sunRise integerValue]){
		NSLog(@"Shacharit");
		[self.carouselView scrollToItemAtIndex:0 animated:YES];
	}else if ([timeNow integerValue] > [sunRise integerValue]+600 && [timeNow integerValue] < [sunSet integerValue]){
		NSLog(@"Mincha");
		[self.carouselView scrollToItemAtIndex:1 animated:YES];
	}else{
		NSLog(@"Maariv");
		[self.carouselView scrollToItemAtIndex:2 animated:YES];
	}
	
}


-(void)viewDidAppear:(BOOL)animated{
	self.locationManager.distanceFilter = kCLDistanceFilterNone;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[self.locationManager startUpdatingLocation];
	[self.carouselView reloadData];
	
	
	
}


-(void) carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
	
	NSLog(@"index = %ld",(long)index);
	toDaven = &index;
	
	if((long)index == 3){
		[self performSegueWithIdentifier:@"toZmanim" sender:self];
	}else if ((long)index == 4){
		NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
		[prefs setBool:NO forKey:@"throughGest"];
		[prefs synchronize];
		UIView *compass = [[[NSBundle mainBundle] loadNibNamed:@"Compass" owner:self options:nil] objectAtIndex:0];
		
		NSLog(@"Compass activated");
		[self.view addSubview:compass];
		self.navigationController.navigationBar.hidden = YES;
		
		compass.tag = 143;
		
	}else{
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setInteger:index forKey:@"Daven"];
		[defaults synchronize];
		[self performSegueWithIdentifier:@"toDaven" sender:self];
	}
	
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
	switch (option)
	{
		case iCarouselOptionWrap:
		return NO;
		break;
		
		case iCarouselOptionSpacing:
		value = .4;
		return value;
		break;
		
		default:
		return value;
		break;
	}
}


#pragma mark - iCarouselViewDatasource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
	
	return [array count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
	
	view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 300)];
	view.layer.cornerRadius = 30;
	view.backgroundColor = [UIColor colorWithRed:44/255.0 green:54.0/255.0 blue:163.0/255.0 alpha:1];
	UILabel *label = nil;
	UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,250/2,250/2)];
	[imageview setImage:[UIImage imageNamed:@"CompassIcons.png"]];
	imageview.center = view.center;
	label = [[UILabel alloc] initWithFrame:view.bounds];
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = NSTextAlignmentCenter;
	label.font = [label.font fontWithSize:30];
	label.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:240/255.0 alpha:.9];
	
	
	if(index == 0){
		[view addSubview:label];
		
		label.text = @"שחרית";
	}else if(index == 1){
		[view addSubview:label];
		
		label.text = @"מנחה";
		
	}else if (index == 2){
		[view addSubview:label];
		
		label.text = @"מעריב";
		
	}else if (index == 3){
		[view addSubview:label];
		
		label.text = @"זמנים/מנינים";
		
	}else if (index == 4){
		label.text = @"Compass";
		[view addSubview:imageview];
	}
	
	
	return view;
	
	
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"toDaven"]) {
		DaveningPage *controller = (DaveningPage *)segue.destinationViewController;
		
	}
}

-(BOOL)prefersStatusBarHidden{
	return YES;
	
}
- (void)orientationChange {
	NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
	BOOL gestureOn = [prefs boolForKey:@"gestComp"];
	BOOL throughGest = [prefs boolForKey:@"throughGest"];
	
	UIView *compass;
	if(gestureOn){
		if(throughGest){
			if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationFaceUp){
				[prefs setBool:YES forKey:@"throughGest"];
				[prefs synchronize];
				compass = [[[NSBundle mainBundle] loadNibNamed:@"Compass" owner:self options:nil] objectAtIndex:0];
				
				NSLog(@"Compass activated");
				[self.view addSubview:compass];
				self.navigationController.navigationBar.hidden = YES;
				
				compass.tag = 143;
			}else{
				NSLog(@"No Compass");
				self.navigationController.navigationBar.hidden = NO;
				[[[self view] viewWithTag:143] removeFromSuperview];
				
			}
		}
	}
}
-(void)navUnhide{
	self.navigationController.navigationBar.hidden = YES;
	NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
	[prefs setBool:YES forKey:@"throughGest"];
	[prefs synchronize];
}

@end
