//
//  DisclaimerViewController.m
//  test1
//
//  Created by Jon Holloway on 24/01/13.
//  Copyright (c) 2013 Jon Holloway. All rights reserved.
//

#import "DisclaimerViewController.h"

@interface DisclaimerViewController ()

@end

@implementation DisclaimerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)acknowledge:(id)sender {
    //add todays date to the user defaults and hide the
    //disclaimer labels and buttons
    NSDate *storeDate = [NSDate date];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:storeDate forKey:@"disclaimerdate"];
    [prefs synchronize];
        
    
}



@end
