//
//  MainViewController.m
//  test1
//
//  Created by Jon Holloway on 8/01/13.
//  Copyright (c) 2013 Jon Holloway. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "ReaderViewController.h"
#import "MultiplePDFViewController.h"

NSString *tester ;

@interface MainViewController ()
{
    NSManagedObjectContext *context;
}

@end

@implementation MainViewController
NSString *categorySearch = @"peri";
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [[self keywordTextField]setDelegate:self];
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
    }



- (void)viewDidAppear:(BOOL)animated    {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDate *getDate = [prefs objectForKey:@"disclaimerdate"];
    NSDate *todaysDate = [NSDate date];
    NSTimeInterval  elapsedTime = [todaysDate timeIntervalSinceDate:getDate];
    NSInteger etime = elapsedTime;
   
    if (![prefs objectForKey:@"disclaimerdate"]) {
        [self performSegueWithIdentifier:@"showDisclaimer" sender:self];
    }
    
    else if ((etime/(3600*24) >= 60 )) {  //number of days
        [self performSegueWithIdentifier:@"showDisclaimer" sender:self];
    }
    
    
        
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)MultiplePDFViewControllerDidFinish:(MultiplePDFViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPDFList"]) {
        [[segue destinationViewController] setDelegate:self];
        }
    
}

-(void)showPDF: (NSString *)pdfFileName  {
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
	NSString *filePath = pdfFileName;
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
	{
		ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
		readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
        
		[self.navigationController pushViewController:readerViewController animated:YES];
        
#else // present in a modal view controller
        
		readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
		[self presentModalViewController:readerViewController animated:YES];
        
#endif // DEMO_VIEW_CONTROLLER_PUSH
    }
    
}



- (IBAction)searchButton:(id)sender {
    
    NSString *keywordSearch = self.keywordTextField.text;
    
    
    
    //this gets the keyword from the keywords table
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"PPGKeywords" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entitydesc];
    
    //check position of filter switches on main screen
    //perinatal is on by default
    
    
    
    
    
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"keyword contains[cd] %@ AND category contains %@",keywordSearch, categorySearch];

    
    [request setPredicate:predicate];
    request.returnsDistinctResults = YES;
    request.resultType = NSDictionaryResultType;
    
    NSError *error;
    NSArray *matchingData = [context executeFetchRequest:request error:&error];
    //set up the stored data class
    Store *  myStore = [Store sharedStore];
    
    if (matchingData.count <= 0) {
        //Error handling here for "not Found"
    }
    //set up to get the filename from the name table
    NSEntityDescription *entityname = [NSEntityDescription entityForName:@"PPGName" inManagedObjectContext:context];
    NSFetchRequest *requestname = [[NSFetchRequest alloc]init];
    [requestname setEntity:entityname];
    NSString *idfromkeyword;
    NSString *fullname;
    NSString *shortname;
    NSInteger *arrayIndex;
    arrayIndex = 1;
    
    
    if (matchingData.count <1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Found" message:@"Keyword does not match any Guidelines" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.show;
    }
    else {    //loop though the array of keyword matches and ids
        for (NSManagedObject *obj in matchingData) {
            
            idfromkeyword = [NSString stringWithFormat:@"%@",[obj valueForKey:@"id"]];
            //now we take the id from the keyword record and look up the pdf name from the other table
            //this will always return a single object
            
            NSPredicate *predicatename = [NSPredicate predicateWithFormat:@"id = %@",idfromkeyword];
            [requestname setPredicate:predicatename];
            
            NSError *errorname;
            NSArray *matchingnameData = [context executeFetchRequest:requestname error:&errorname];
            // add this item to the sharedStore holding array
            //refresh store array
            
            if (arrayIndex == 1){
                [myStore.passedData removeAllObjects];
                
            }
            PDFObject * myFirstObject = [[PDFObject alloc]init];
            myFirstObject.fullname = @" ";
            myFirstObject.password = @"blank";
            [myStore.passedData addObject:myFirstObject];
            arrayIndex++;
            
            for (NSManagedObject *objn in matchingnameData) {
                fullname = [objn valueForKey:@"fullname"];
                shortname = [objn valueForKey:@"shortname"];
                if (shortname == nil) {
                    shortname = @"blank";
                }
            
                
            }
            PDFObject * myObject = [[PDFObject alloc]init];
            myObject.fullname = fullname;
            myObject.password = shortname;
            // add initial blank object for scrolling 
            
            
            [myStore.passedData addObject:myObject];
            
            
            arrayIndex++;
        }
        
        
        if (matchingData.count > 1)
        {
            [self performSegueWithIdentifier:@"showPDFList" sender:self];
        }
        
        else
        {
            tester = fullname;
            [Store moveFiles:fullname];
            [self showPDF:fullname];
        }
    }
    
}

- (IBAction)acknowledge:(id)sender {
    //add todays date to the user defaults and hide the
    //disclaimer labels and buttons
    NSDate *storeDate = [NSDate date];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:storeDate forKey:@"disclaimerdate"];
    [prefs synchronize];
    _disclaimer.hidden = TRUE;
    _acknowledgebutton.hidden=TRUE;
    _Note.hidden = TRUE;
    
        
}

- (IBAction)perinatalChanged:(id)sender {
    //perinatal switch has changed
    //set up category search word to use
    //paediatric switch has changed
    //set up category search word to use
    if(_pSwitch.on)
    {
        if (_paSwitch.on)
        {
            if (_nSwitch.on)
            {
                //all 3 on
                categorySearch =@"e";
            }
            else
            {
                //pa + p
                categorySearch =@"r";
            }
        }
        else
        {
            if (_nSwitch.on)
            {
                // p + n
                categorySearch =@"natal";
            }
            else
            {
                //p only
                categorySearch =@"peri";
            }
        }
    }
    else
    {
        if (_paSwitch.on)
        {
            if (_nSwitch.on)
            {
                //  pa + n
                categorySearch =@"o";
            }
            else
            {
                // pa only
                categorySearch =@"paed";
            }
        }
        else
        {
            if (_nSwitch.on)
            {
                // n only
                categorySearch =@"neo";
            }
            else
            {
                // all 3 off - must not happen
                _nSwitch.on = YES;
                _paSwitch.on = YES;
                categorySearch =@"o";
                
            }
        }
    }
}

- (IBAction)neonatalChanged:(id)sender {
    //neonatal switch has changed
    //set up category search word to use
    if(_nSwitch.on)
    {
        if (_pSwitch.on)
        {
            if (_paSwitch.on)
            {
                //all 3 on
                categorySearch =@"e";
            }
            else
            {
                //n + p
                categorySearch =@"natal";
            }
        }
        else
        {
            if (_paSwitch.on)
            {
                // pa + n
                categorySearch =@"o";
            }
            else
            {
                //n only
                categorySearch =@"neo";
            }
        }
    }
    else
    {
        if (_pSwitch.on)
        {
            if (_paSwitch.on)
            {
                //  p + pa
                categorySearch =@"r";
            }
            else
            {
                // p only
                categorySearch =@"peri";
            }
        }
        else
        {
            if (_paSwitch.on)
            {
                // pa only
                categorySearch =@"paed";
            }
            else
            {
                // all 3 off - must not happen
                _paSwitch.on = YES;
                _pSwitch.on = YES;
                categorySearch =@"r";
                
            }
        }
    }


}

- (IBAction)paediatricChanged:(id)sender
{
    //paediatric switch has changed
    //set up category search word to use
    if(_paSwitch.on)
    {
            if (_pSwitch.on)
            {
                if (_nSwitch.on)
                {
                        //all 3 on
                    categorySearch =@"e";
                }
                else
                {
                        //pa + p
                    categorySearch =@"r";
                }
            }
            else
            {
                if (_nSwitch.on)
                {
                    // pa + n
                    categorySearch =@"o";
                }
                else
                {
                    //pa only
                    categorySearch =@"paed";
                }
            }
    }
    else
    {
        if (_pSwitch.on)
        {
            if (_nSwitch.on)
            {
                //  p + n
                categorySearch =@"natal";
            }
            else
            {
                // p only
                categorySearch =@"peri";
            }
        }
        else
        {
            if (_nSwitch.on)
            {
                // n only
                categorySearch =@"neo";
            }
            else
            {
                // all 3 off - must not happen
                _nSwitch.on = YES;
                _pSwitch.on = YES;
                categorySearch =@"natal";
                
            }
        }
    }
}


- (BOOL) shouldAutorotate {
    return NO;
}


- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
	[self.navigationController popViewControllerAnimated:YES];
    
#else // dismiss the modal view controller
    
	[self dismissModalViewControllerAnimated:YES];
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
    [Store removeFiles:tester];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

@end
