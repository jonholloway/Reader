//
//  Store.h
//  test1
//
//  Created by Jon Holloway on 14/01/13.
//  Copyright (c) 2013 Jon Holloway. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject <UIApplicationDelegate>
{
    NSString *passedText;
    NSMutableArray *passedData;
  
}
@property (nonatomic, strong) NSString* passedText;
@property (nonatomic, strong) NSMutableArray* passedData;


+(Store *) sharedStore;

+(void)moveFiles:(NSString *)fileName;
+(void)removeFiles:(NSString *)fileName;


+ (NSURL *)applicationDocumentsDirectory;




@end
