//
//  PPGName.h
//  Reader
//
//  Created by Jon Holloway on 25/02/13.
//  Copyright (c) 2013 Jon Holloway. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PPGName : NSManagedObject

@property (nonatomic, retain) NSString * fullname;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * shortname;

@end
