//
//  Store.m
//  test1
//
//  Created by Jon Holloway on 14/01/13.
//  Copyright (c) 2013 Jon Holloway. All rights reserved.
//

#import "Store.h"
#import "ReaderViewController.h"


@implementation Store
@synthesize passedText;
@synthesize passedData;




static Store *sharedStore = nil;


+ (Store *) sharedStore {
    @synchronized (self) {
        if (sharedStore == nil) {
            sharedStore = [[self alloc]init];
            sharedStore.passedData = [[NSMutableArray alloc]init];
        }
    }
    return sharedStore;
}

+ (NSURL *) applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+(void)moveFiles:(NSString *)fileName {
    
    NSString *plistFileName = [fileName stringByAppendingPathExtension:@"plist"];
    NSString *pdfFileName =[fileName stringByAppendingPathExtension:@"pdf"];
        
    NSURL *plistURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:plistFileName];
    NSURL *pdfURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:pdfFileName];
    
    if( ![[NSFileManager defaultManager]
          fileExistsAtPath:[plistURL path]] )
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist" inDirectory:nil];
        
        NSError *anyError = nil;
        BOOL success = [[NSFileManager defaultManager]
                        copyItemAtPath:plistPath toPath:[plistURL path] error:&anyError];
    }
    if( ![[NSFileManager defaultManager]
          fileExistsAtPath:[pdfURL path]] )
    {
        NSString *pdfPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"pdf" inDirectory:nil];
        
        NSError *anyError = nil;
        BOOL success = [[NSFileManager defaultManager]
                        copyItemAtPath:pdfPath toPath:[pdfURL path] error:&anyError];
    }

}


+(void)removeFiles:(NSString *)fileName {
    
    NSString *plistFileName = [fileName stringByAppendingPathExtension:@"plist"];
    NSString *pdfFileName =[fileName stringByAppendingPathExtension:@"pdf"];
    
    NSURL *plistURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:plistFileName];
    NSURL *pdfURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:pdfFileName];
    
    if( [[NSFileManager defaultManager]
          fileExistsAtPath:[plistURL path]] )
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist" inDirectory:nil];
        
        NSError *anyError = nil;
        BOOL success = [[NSFileManager defaultManager]
                        removeItemAtURL:plistURL error:&anyError];
    }
    if( [[NSFileManager defaultManager]
          fileExistsAtPath:[pdfURL path]] )
    {
        NSString *pdfPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"pdf" inDirectory:nil];
        
        NSError *anyError = nil;
        BOOL success = [[NSFileManager defaultManager]
                        removeItemAtURL:pdfURL error:&anyError];
    }
    
}

@end
