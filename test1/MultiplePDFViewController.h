//
//  MultiplePDFViewController.h
//  Reader
//
//  Created by Jon Holloway on 27/02/13.
//  Copyright (c) 2013 Jon Holloway. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MultiplePDFViewController;
@protocol MultiplePDFViewControllerDelegate
- (void)MultiplePDFViewControllerDidFinish:(MultiplePDFViewController *)controller;

@end

@interface MultiplePDFViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>

{
    NSMutableArray *list;
    NSMutableArray *list2;
    //NSMutableArray  *transferlist;
}

@property (weak, nonatomic) id <MultiplePDFViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString * fullname;

- (IBAction)done:(id)sender;
@end
