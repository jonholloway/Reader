//
//  PDFObject.h
//  Reader
//
//  Created by Jon Holloway on 5/03/13.
//  Copyright (c) 2013 Jon Holloway. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDFObject : NSObject {
    NSString *fullname;
    NSString *password;
}
@property (nonatomic, retain) NSString * fullname;
@property (nonatomic, retain) NSString * password;
@end
