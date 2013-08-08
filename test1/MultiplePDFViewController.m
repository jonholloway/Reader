//
//  MultiplePDFViewController.m
//  Reader
//
//  Created by Jon Holloway on 27/02/13.
//  Copyright (c) 2013 Jon Holloway. All rights reserved.
//

#import "MultiplePDFViewController.h"
#import "Store.h"
#import "ReaderViewController.h"
#import "PPGName.h"


NSString *tester ;
NSMutableArray *transferlist;

@interface MultiplePDFViewController ()
@end

@implementation MultiplePDFViewController

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
    
    Store * myStore = [Store sharedStore];
    list = [myStore passedData];
    
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"fullname" ascending:YES selector:@selector(localizedCompare:)];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSArray *templist;
    templist = [list sortedArrayUsingDescriptors:sortDescriptors];
    NSMutableArray *qwe = [[NSMutableArray alloc] initWithArray:templist];
    transferlist = qwe;
    
    //eliminate duplicate entries in array
    for (int j=0;j< [transferlist count];j++){
        for (int k=(j+1);k<[transferlist count];k++){
            NSString *str1 = [[transferlist objectAtIndex:j] fullname];
            NSString *str2 = [[transferlist objectAtIndex:k] fullname];
            if ([str1 isEqualToString:str2]){
                [transferlist removeObjectAtIndex:k];
            k--;
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return transferlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [[transferlist objectAtIndex:indexPath.row] fullname];
 
    //[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
    return cell;
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated{
    
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //alert view delegate
   
    //open pdf file normally except pass in password from alert view
    NSString *phrase = [alertView textFieldAtIndex:0].text;
    
    if ([phrase isEqualToString:@"gestation"]) {
    if (buttonIndex==1)
    {
    NSString *filePath = tester;
        //pass this name to the moveFile function to ensure the files are in the Documents Directory
        
        [Store moveFiles:filePath];
        
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
            }
 }


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *phrase = [[transferlist objectAtIndex:indexPath.row] password];
    // Document password (for unlocking most encrypted PDF files)
    tester = [[transferlist objectAtIndex:indexPath.row] fullname];
    if ([phrase isEqualToString: @"password"]) {
    
         UIAlertView *pwordRequest = [[UIAlertView alloc] initWithTitle:@"Password Required" message:@"Guideline is Password Protected. Enter password to unlock" delegate:self
                                                cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        
        //Add Password Text Field
        pwordRequest.alertViewStyle = UIAlertViewStyleSecureTextInput;
        
        [pwordRequest show];
       
     
    }else {
    
    NSString *filePath = [[transferlist objectAtIndex:indexPath.row] fullname]; //assert(filePath != nil); // Path to last PDF file
	//test for blank row at top of array - if selected - do nothing
    if (![filePath isEqual:@" "]) {
        
        
        //pass this name to the moveFile function to ensure the files are in the Documents Directory
        
        [Store moveFiles:filePath];
       
        
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
 
}
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

- (BOOL) shouldAutorotate {
    return NO;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (IBAction)done:(id)sender
{
    [self.delegate MultiplePDFViewControllerDidFinish:self];
    //[self dismissViewControllerAnimated:YES completion: nil];
    }


@end
