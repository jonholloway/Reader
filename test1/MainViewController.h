//
//  MainViewController.h
//  test1
//
//  Created by Jon Holloway on 8/01/13.
//  Copyright (c) 2013 Jon Holloway. All rights reserved.
//

#import "MultiplePDFViewController.h"

#import <CoreData/CoreData.h>

#import "Store.h"
#import "PDFObject.h"

@interface MainViewController : UIViewController <UITextFieldDelegate, MultiplePDFViewControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITextField *keywordTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *Note;
@property (weak, nonatomic) IBOutlet UILabel *disclaimer;
@property (strong, nonatomic) NSArray *matchingnameData;
@property (weak, nonatomic) IBOutlet UIButton *acknowledgebutton;
@property (strong, nonatomic) NSString * fullname;
@property (strong, nonatomic) NSString * sshortname;
@property (strong, nonatomic) IBOutlet UISwitch *pSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *nSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *paSwitch;


- (IBAction)searchButton:(id)sender;
- (IBAction)acknowledge:(id)sender;

- (IBAction)perinatalChanged:(id)sender;
- (IBAction)neonatalChanged:(id)sender;
- (IBAction)paediatricChanged:(id)sender;



@end
