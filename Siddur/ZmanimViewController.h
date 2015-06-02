//
//  ZmanimViewController.h
//  Siddur
//
//  Created by Ehud Adler on 2/24/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <CoreLocation/CoreLocation.h>

typedef enum
{
	CoordinateSelectorLastSelectedTypeSearch = 1,
	CoordinateSelectorLastSelectedTypeCurrent,
	CoordinateSelectorLastSelectedTypeUndefined,
} CoordinateSelectorLastSelectedType;

@interface ZmanimViewController: UIViewController <UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate, CLLocationManagerDelegate,MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UILabel *zip;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) IBOutlet MKMapView *mapview;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (copy, nonatomic) NSString *url;
@property (nonatomic,strong) NSString *strings;


@property (strong, nonatomic) IBOutlet UISwitch *switcher;
@property (strong, nonatomic) CLGeocoder *coder;

@property (strong, nonatomic) CLLocation *selectedLocation;
@property (strong, nonatomic) NSMutableDictionary *placeDictionary;
@property (readonly) NSString *selectedName;
@end