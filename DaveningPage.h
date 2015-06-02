//
//  DaveningPage.h
//  Siddur
//
//  Created by Ehud Adler on 2/17/15.
//  Copyright (c) 2015 Ehud Adler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaveningPage : UIViewController <UITextViewDelegate>


@property (strong, nonatomic) IBOutlet UITextView *Shacharit;

@property (strong, nonatomic) IBOutlet UITextView *Mincha;
@property (strong, nonatomic) IBOutlet UITextView *Maariv;

@end
