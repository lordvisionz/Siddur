	//
	//  DaveningPage.m
	//  Siddur
	//
	//  Created by Ehud Adler on 2/17/15.
	//  Copyright (c) 2015 Ehud Adler. All rights reserved.
	//

#import "DaveningPage.h"

@interface DaveningPage () <UITextViewDelegate>
@property (strong,nonatomic) IBOutlet UITextView *daveningLabel;
@end

@implementation DaveningPage
long value;
NSAttributedString *string;
- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.daveningLabel.scrollEnabled = YES;
	self.daveningLabel.contentInset = UIEdgeInsetsZero;
	string = [[NSAttributedString alloc]init];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(navUnhide)
												 name:@"dismissedXib"
											   object:nil];
	NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
	BOOL gestureOn = [prefs boolForKey:@"gestComp"];
	if(gestureOn){
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange) name: UIDeviceOrientationDidChangeNotification object:nil];
	}
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	value = [defaults integerForKey:@"Daven"];
	self.navigationController.navigationBar.hidden = NO;
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
		// Dispose of any resources that can be recreated.
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)viewWillAppear:(BOOL)animated {
	NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
	NSInteger fontSize = [prefs integerForKey:@"fontSize"];
	NSLog(@"THE FONT SIZE HAS LOADED AS: %ld",(long)fontSize);
	[self.fontSlider setValue:(long)fontSize animated:YES];
	if((int)value == 0){
		string =
		[NSAttributedString.alloc
		 initWithFileURL:[ NSBundle.mainBundle URLForResource:@"Shacharit" withExtension:@"rtf"  ]
		 options:nil
		 documentAttributes:nil
		 error:NULL
		 ];
	}else if((int)value == 1){
		string =
		[NSAttributedString.alloc
		 initWithFileURL:[ NSBundle.mainBundle URLForResource:@"Mincha" withExtension:@"rtf"  ]
		 options:nil
		 documentAttributes:nil
		 error:NULL
		 ];
	}else if((int)value == 2){
		string =
		[NSAttributedString.alloc
		 initWithFileURL:[ NSBundle.mainBundle URLForResource:@"Maariv" withExtension:@"rtf"  ]
		 options:nil
		 documentAttributes:nil
		 error:NULL
		 ];
		
	}
	
	[self.daveningLabel setAttributedText:string];
//	self.daveningLabel .numberOfLines = 0;
	self.daveningLabel.font = [self.daveningLabel.font fontWithSize:(long)fontSize];
	NSLog(@"LENGTH = %ld",(long)self.daveningLabel.text.length);
	
	
}


-(BOOL)prefersStatusBarHidden{
	return YES;
	
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
- (IBAction)fontChange:(id)sender {
	
	NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
	[prefs setInteger:(long)self.fontSlider.value forKey:@"fontSize"];
	[prefs synchronize];
	
	self.daveningLabel.font = [self.daveningLabel.font fontWithSize:(long)self.fontSlider.value];
	
	
	
}

@end
