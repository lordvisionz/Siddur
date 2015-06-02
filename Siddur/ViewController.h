//
//  ViewController.h
//  Siddur
//
//  Created by Ehud Adler on 2/12/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iCarousel/iCarousel.h>

@interface ViewController : UIViewController <iCarouselDataSource,iCarouselDelegate,UIAccelerometerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UILabel *parshaToday;
@property (strong, nonatomic) IBOutlet UILabel *holiday;

@end

