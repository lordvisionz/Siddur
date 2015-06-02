//
//  LevelInfoView.h
//  Five
//
//  Created by Paul Wilkinson on 5/02/2015.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Level;

@interface LevelInfoView : UIView

@property (strong,nonatomic) Level *level;
@property BOOL levelLocked;

+ (id)loadFromNib;

@end
