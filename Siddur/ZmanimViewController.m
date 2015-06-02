	//
	//  ZmanimViewController.m
	//  Siddur
	//
	//  Created by Ehud Adler on 2/24/15.
	//  Copyright (c) 2015 Ehud Adler. All rights reserved.
	//


#import "ZmanimViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
@interface ZmanimViewController () {
	NSXMLParser *parser;
	NSMutableArray *feeds;
	NSMutableDictionary *item;
	NSMutableString *title;
	NSMutableString *link;
	NSString *element;
	NSString *zipCodeString;
	UITextField *myTextField;
	UIAlertView *myAlertView;
	
}

@end



@implementation ZmanimViewController

- (void)viewDidLoad
{
	
	[super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(navUnhide)
												 name:@"dismissedXib"
											   object:nil];
	NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
	BOOL gestureOn = [prefs boolForKey:@"gestComp"];
	if(gestureOn){
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange) name: UIDeviceOrientationDidChangeNotification object:nil];
	}
	self.navigationController.navigationBar.hidden = NO;

	self.navigationController.hidesBarsOnSwipe = NO;

	[self ZmanGet];
}

-(void)MinyanGet{
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
			// Use one or the other, not both. Depending on what you put in info.plist
		
		[self.locationManager requestAlwaysAuthorization];
	}
	
	_coder = [[CLGeocoder alloc] init];
	_locationManager = [[CLLocationManager alloc]init];
	_locationManager.delegate = self;
	[_locationManager startUpdatingLocation];
	
		//Block address
	[_coder reverseGeocodeLocation: _locationManager.location completionHandler:
	 ^(NSArray *placemarks, NSError *error) {
		 
			 //Get address
		 CLPlacemark *placemark = [placemarks objectAtIndex:0];
		 
		 NSLog(@"Placemark array: %@",placemark.addressDictionary );
		 
			 //String to address
		 NSString *locateaddress;
		 
		 if(self.switcher.on){
			 locateaddress = [placemark.addressDictionary valueForKey:@"ZIP"];
		 }else{
			 locateaddress = zipCodeString;

			 
		 }
		 
		 NSString *end = @"&limit=10&distance=2&image.x=6&image.y=4&image=Submit";
		 
		 NSString *stringw = [NSString stringWithFormat:@"http://www.minyanmaps.com/rss/minyanlocal.php?zip=%@%@",locateaddress,end];
		 
		 feeds = [[NSMutableArray alloc] init];
		 NSURL *url = [NSURL URLWithString:stringw];
		 parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
		 
		 [parser setDelegate:self];
		 [parser setShouldResolveExternalEntities:NO];
		 [parser parse];
		 
		 NSURL *myURL = [NSURL URLWithString: [self.url stringByAddingPercentEscapesUsingEncoding:
											   NSUTF8StringEncoding]];
		 NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
		 [self.webview loadRequest:request];
		 
		 NSLog(@"%@",_strings);
		 _zip.text = locateaddress;
		 
		 
		 
	 }];
	
}
-(void)ZmanGet{
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
			// Use one or the other, not both. Depending on what you put in info.plist
		
		[self.locationManager requestAlwaysAuthorization];
	}
	
	_coder = [[CLGeocoder alloc] init];
	_locationManager = [[CLLocationManager alloc]init];
	_locationManager.delegate = self;
	[_locationManager startUpdatingLocation];
	
		//Block address
	[_coder reverseGeocodeLocation: _locationManager.location completionHandler:
	 ^(NSArray *placemarks, NSError *error) {
		 
			 //Get address
		 CLPlacemark *placemark = [placemarks objectAtIndex:0];
		 
		 if(placemark.addressDictionary == NULL){
			 [self ZmanGet];
		 }else{
			 NSLog(@"Placemark array: %@",placemark.addressDictionary );
			 NSString *locateaddress;
				 //String to address
			 if(self.switcher.on){
			locateaddress = [placemark.addressDictionary valueForKey:@"ZIP"];
			 }else{
				 locateaddress = zipCodeString;
			 }
			 
			 NSString *stringw = [NSString stringWithFormat:@"http://www.chabad.org/tools/rss/zmanim.xml?c=%@",locateaddress];
			 
			 feeds = [[NSMutableArray alloc] init];
			 NSURL *url = [NSURL URLWithString:stringw];
			 parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
			 
			 [parser setDelegate:self];
			 [parser setShouldResolveExternalEntities:NO];
			 [parser parse];
			 NSURL *myURL = [NSURL URLWithString: [self.url stringByAddingPercentEscapesUsingEncoding:
												   NSUTF8StringEncoding]];
			 NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
			 [self.webview loadRequest:request];
			 
			 NSLog(@"%@",_strings);
			 _zip.text = locateaddress;
			 
		 }
		 
	 }];
	
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return feeds.count;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
		//		//1. Setup the CATransform3D structure
		//	CATransform3D rotation;
		//	rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
		//	rotation.m34 = 1.0/ -600;
		//
		//
		//		//2. Define the initial state (Before the animation)
		//	cell.layer.shadowColor = [[UIColor blackColor]CGColor];
		//	cell.layer.shadowOffset = CGSizeMake(10, 10);
		//	cell.alpha = 0;
		//
		//	cell.layer.transform = rotation;
		//	cell.layer.anchorPoint = CGPointMake(0, 0.5);
		//
		//
		//		//3. Define the final state (After the animation) and commit the animation
		//	[UIView beginAnimations:@"rotation" context:NULL];
		//	[UIView setAnimationDuration:0.8];
		//	cell.layer.transform = CATransform3DIdentity;
		//	cell.alpha = 1;
		//	cell.layer.shadowOffset = CGSizeMake(0, 0);
		//	[UIView commitAnimations];
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Working");
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	if(self.segControl.selectedSegmentIndex == 0){
		NSString *str1 = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
		if([str1 containsString:@"--"]){
		NSRange range = [str1 rangeOfString:@"--"];
		cell.textLabel.text = [str1 substringToIndex:range.location];
		}
	}else{
		cell.textLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
		
	}
	NSLog(@"indexpath= %li",(long)indexPath.row);
	
	if(indexPath.row == 0)
		NSLog(@"Index row= %@",cell.textLabel.text);
	return cell;
	
 
	
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	
	element = elementName;
	
	if ([element isEqualToString:@"item"]) {
		
		item    = [[NSMutableDictionary alloc] init];
		title   = [[NSMutableString alloc] init];
		link    = [[NSMutableString alloc] init];
		
	}
	
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	if ([element isEqualToString:@"title"]) {
		[title appendString:string];
	} else if ([element isEqualToString:@"link"]) {
		[link appendString:string];
	}
	
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	if ([elementName isEqualToString:@"item"]) {
		
		[item setObject:title forKey:@"title"];
		[item setObject:link forKey:@"link"];
		
		[feeds addObject:[item copy]];
		
	}
	
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
	[self.tableView reloadData];
	
	
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([[segue identifier] isEqualToString:@"showDetail"]) {
		
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		NSString *string = [feeds[indexPath.row] objectForKey: @"link"];
		[[segue destinationViewController] setUrl:string];
		
	}
}
/*- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
 {
	double delayInSeconds = 3.0;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
 [refreshControl endRefreshing];
	});
 }*/
- (BOOL)prefersStatusBarHidden {
	return NO;
}

- (IBAction)segmentSwitch:(id)sender {
	UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
	NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
	
	if (selectedSegment == 0){
		[self ZmanGet];
	}
	else{
		[self MinyanGet];
		
	}
}
-(IBAction) switchValueChanged:(UISwitch *) sender{
	NSLog(@"SWITCHED");
	if (self.switcher.on) {
		NSLog(@"ENABLED");
		if (self.segControl.selectedSegmentIndex == 0){
			[self ZmanGet];
		}
		else{
			[self MinyanGet];
			
		}

		
	}else{
		myAlertView = [[UIAlertView alloc] initWithTitle:@"Choose Location"
															  message:@"Please Enter Zip/Area Code" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Set", nil];

		myAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
UITextField * alertTextField = [myAlertView textFieldAtIndex:0];

		[alertTextField setKeyboardType:UIKeyboardTypeNumberPad];
		[myAlertView show];
	}

}
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == [myAlertView cancelButtonIndex]) {
		[self.switcher setOn:YES animated:YES];
		
	}else{
		UITextField * alertTextField = [myAlertView textFieldAtIndex:0];
	zipCodeString = alertTextField.text;
	if (self.segControl.selectedSegmentIndex == 0){
		[self ZmanGet];
	}
	else{
		[self MinyanGet];
		
	}
	}

	
}
- (void)orientationChange {
	NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
	BOOL gestureOn = [prefs boolForKey:@"gestComp"];
	UIView *compass;
	if(gestureOn){
		if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationFaceUp){
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
-(void)navUnhide{
	self.navigationController.navigationBar.hidden = NO;
	
}
-(void)viewWillAppear:(BOOL)animated{
	self.navigationController.navigationBar.hidden = NO;
	
	self.navigationController.hidesBarsOnSwipe = NO;
}
@end