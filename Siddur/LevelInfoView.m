//
//  LevelInfoView.m
//  Five
//
//  Created by Paul Wilkinson on 5/02/2015.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import "LevelInfoView.h"
#import "Level.h"

@interface LevelInfoView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *tapToPlay;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak,nonatomic) IBOutlet UILabel *levelNumber;

@end

@implementation LevelInfoView

@synthesize level=_level;
@synthesize levelLocked=_levelLocked;


+ (id)loadFromNib {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"LevelInfoView"
                                                         owner:nil
                                                       options:nil];
        for (id currentObject in objects ){
            if ([currentObject isKindOfClass:[LevelInfoView class]])
                [currentObject configure];
                return currentObject;
        }
    
    return nil;
}


-(void) configure {
    
        
    // border radius
    self.backgroundColor = [UIColor blackColor];
    [self.layer setCornerRadius:30.0f];
    [self.backgroundImageView.layer setCornerRadius:30.0f];
    [self.backgroundImageView.layer setMasksToBounds:YES];
    self.backgroundImageView.alpha=0.5;
    
    
    // drop shadow
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOpacity:0.8];
    [self.layer setShadowRadius:3.0];
    [self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    //    self.cardView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    
}

-(void)updateUI {
    
    
    
    self.titleLabel.text=self.level.name;
    
    self.targetScoreLabel.text=[NSString stringWithFormat:@"Target score  %ld",(long)self.level.targetScore];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *highScores=[defaults objectForKey:@"highScores"];
    NSNumber *highScore=highScores[self.level.name];
    
    self.highScoreLabel.text=[NSString stringWithFormat:@"High score  %ld",(long)[highScore integerValue]];
	self.backgroundColor = [UIColor colorWithRed:self.level.colorR/255.0f green:self.level.colorG/255.0f blue:self.level.colorB/255.0f alpha:1];
    self.levelNumber.text = [NSString stringWithFormat:@"%ld",(long)self.level.number];
    
    if (self.levelLocked) {
        self.levelNumber.text=@"Locked";
    }else{
        self.levelNumber.hidden=self.levelLocked;
    }
    self.backgroundImageView.hidden = self.levelLocked;
    self.tapToPlay.hidden = self.levelLocked;
    self.targetScoreLabel.hidden = self.levelLocked;
    self.targetScoreLabel.hidden = self.levelLocked;
    self.highScoreLabel.hidden=self.levelLocked;
    self.titleLabel.hidden=self.levelLocked;
}

-(Level *)level {
    return _level;
}

-(void) setLevel:(Level *)level {
    _level=level;
		// [self.level.backgroundImageName getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
		//  if (error == nil) {
		//    self.backgroundImageView.image = [UIImage imageWithData:data];
		// }
		//   }];
    [self updateUI];
}

-(BOOL) levelLocked {
    return _levelLocked;
}

-(void) setLevelLocked:(BOOL)levelLocked {
    _levelLocked=levelLocked;
    [self updateUI];
}
@end
