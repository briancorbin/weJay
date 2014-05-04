//
//  DataManager.h
//  weJay
//
//  Created by Brian Corbin on 3/11/14.
//  Copyright (c) 2014 Brian Corbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface DataManager : NSObject

@property (strong, nonatomic) NSArray *playQueue;
@property (strong, nonatomic) NSString *partyName;
@property (strong, nonatomic) NSString *partyPassword;
@property float volChangePcnt;
@property float downvotePcnt;
@property int viewSongs;

+(DataManager *)sharedInstance;

@end
