//
//  DataManager.m
//  weJay
//
//  Created by Brian Corbin on 3/11/14.
//  Copyright (c) 2014 Brian Corbin. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

- (id)init
{
    self = [super init];
    
    if (self) {
        ;
    }
    return self;
}

+(DataManager *)sharedInstance
{
    static DataManager *sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^
                  {
                      sharedInstance = [[DataManager alloc]init];
                  });
    
    return sharedInstance;
}


@end
