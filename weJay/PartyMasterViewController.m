//
//  PartyMasterViewController.m
//  weJay
//
//  Created by Brian Corbin on 3/11/14.
//  Copyright (c) 2014 Brian Corbin. All rights reserved.
//

#import "PartyMasterViewController.h"

@interface PartyMasterViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *artworkImgView;
@property (weak, nonatomic) IBOutlet UILabel *songNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *artistAlbumLbl;
@property (weak, nonatomic) IBOutlet MPVolumeView *mpVolumeSlider;

- (IBAction)nextSongAction:(id)sender;
- (IBAction)prevSongAction:(id)sender;
- (IBAction)playPauseAction:(id)sender;

@property (weak, nonatomic) DataManager *dataManager;
@property (weak, nonatomic) MPMusicPlayerController *mpController;

@end

@implementation PartyMasterViewController

@synthesize dataManager, artistAlbumLbl, artworkImgView, songNameLbl, mpController, mpVolumeSlider;

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
    
    dataManager = [DataManager sharedInstance];
    
    self.navigationController.navigationBarHidden = YES;
	
    mpController = [MPMusicPlayerController iPodMusicPlayer];
    
    MPMediaItemCollection *mediaCollection = [[MPMediaItemCollection alloc] initWithItems:dataManager.playQueue];
    [mpController setQueueWithItemCollection:mediaCollection];
    [self registerMediaPlayerNotifications];
    [mpController play];
}

- (void) registerMediaPlayerNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_NowPlayingItemChanged:)
                               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object: mpController];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_PlaybackStateChanged:)
                               name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object: mpController];
    
    [mpController beginGeneratingPlaybackNotifications];
}

- (void) handle_NowPlayingItemChanged: (id) notification
{
    MPMediaItem *currentItem = [mpController nowPlayingItem];
    UIImage *artworkImage = [UIImage imageNamed:@"noArtworkImage.png"];
    MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
    
    if (artwork) {
        artworkImage = [artwork imageWithSize: CGSizeMake (200, 200)];
    }
    DominantColor *newDominantColor = [[DominantColor alloc] init];
    UIColor *dominantColor = [newDominantColor getDominantColor:artworkImage];
    mpVolumeSlider.tintColor = dominantColor;
    
    
    [artworkImgView setImage:artworkImage];
    
    NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    if (titleString) {
        songNameLbl.text = [NSString stringWithFormat:@"%@",titleString];
    } else {
        songNameLbl.text = @"Unknown title";
    }
    
    NSString *albumString = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    if (artistString)
        artistString = [NSString stringWithFormat:@"%@ — ",artistString];
    else
        artistString = @"Unknown Artist";
    if(albumString)
        albumString = [NSString stringWithFormat:@"%@",albumString];
    else
        albumString = @"Unknown Album";
    artistAlbumLbl.text = [NSString stringWithFormat:@"%@%@", artistString, albumString];
    
}

- (void) handle_PlaybackStateChanged: (id) notification
{
    MPMusicPlaybackState playbackState = [mpController playbackState];
    
    if (playbackState == MPMusicPlaybackStatePaused) {
        //[playPauseBtn setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
        
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        //[playPauseBtn setImage:[UIImage imageNamed:@"pauseButton.png"] forState:UIControlStateNormal];
        
    } else if (playbackState == MPMusicPlaybackStateStopped) {
        
        //[playPauseBtn setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
        [mpController stop];
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextSongAction:(id)sender {
    [mpController skipToNextItem];
}

- (IBAction)prevSongAction:(id)sender {
    if(mpController.currentPlaybackTime < 2.5)
        [mpController skipToPreviousItem];
    else
        [mpController skipToBeginning];
}

- (IBAction)playPauseAction:(id)sender {
    if ([mpController playbackState] == MPMusicPlaybackStatePlaying) {
        [mpController pause];
        
    } else {
        [mpController play];
    }
}
@end
