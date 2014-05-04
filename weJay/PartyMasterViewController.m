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
@property (weak, nonatomic) IBOutlet UIButton *playPauseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *rdyPartyView;

- (IBAction)nextSongAction:(id)sender;
- (IBAction)prevSongAction:(id)sender;
- (IBAction)playPauseAction:(id)sender;
- (IBAction)startThePartyAction:(id)sender;

@property (weak, nonatomic) DataManager *dataManager;
@property (weak, nonatomic) MPMusicPlayerController *mpController;

@end

@implementation PartyMasterViewController

@synthesize dataManager, artistAlbumLbl, artworkImgView, songNameLbl, mpController, mpVolumeSlider, playPauseBtn, backgroundImageView, rdyPartyView;

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
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    //menuBtn.target = self.revealViewController;
    //menuBtn.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    dataManager = [DataManager sharedInstance];
    dataManager.volChangePcnt = .35;
    dataManager.downvotePcnt = .30;
    dataManager.viewSongs = 5;
    
    self.navigationController.navigationBarHidden = YES;
	
    mpController = [MPMusicPlayerController iPodMusicPlayer];
    
    [self registerMediaPlayerNotifications];
    
    MPMediaItemCollection *mediaCollection = [[MPMediaItemCollection alloc] initWithItems:dataManager.playQueue];
    [mpController setQueueWithItemCollection:mediaCollection];
    [mpController stop];
    
    rdyPartyView.backgroundColor = [UIColor whiteColor];
    [self.view bringSubviewToFront:rdyPartyView];
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
        artworkImage = [artwork imageWithSize: CGSizeMake (275, 275)];
    }
    
    UIImage *backgroundImage = [self blur:artworkImage];
    [backgroundImageView setImage:backgroundImage];
    [backgroundImageView setFrame:CGRectMake(backgroundImageView.frame.origin.x, backgroundImageView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    
    DominantColor *newDominantColor = [[DominantColor alloc] init];
    UIColor *dominantColor = [newDominantColor getDominantColor:artworkImage];
    mpVolumeSlider.tintColor = dominantColor;
    //menuBtn.tintColor = dominantColor;
    
    [artworkImgView setImage:artworkImage];
    
    NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    if (titleString)
        songNameLbl.text = [NSString stringWithFormat:@"%@",titleString];
    else
        songNameLbl.text = @"Unknown title";
    
    NSString *albumString = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    if (artistString)
        artistString = [NSString stringWithFormat:@"%@ — ",artistString];
    else
        artistString = @"Unknown Artist — ";
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
        [playPauseBtn setImage:[UIImage imageNamed:@"playButtonWhite.png"] forState:UIControlStateNormal];
        
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        [playPauseBtn setImage:[UIImage imageNamed:@"pauseButtonWhite.png"] forState:UIControlStateNormal];
        
    } else if (playbackState == MPMusicPlaybackStateStopped) {
        
        [playPauseBtn setImage:[UIImage imageNamed:@"playButtonWhite.png"] forState:UIControlStateNormal];
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

- (UIImage*) blur:(UIImage*)theImage
{
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    return [UIImage imageWithCGImage:cgImage scale:.20 orientation:UIImageOrientationUp];
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

- (IBAction)startThePartyAction:(id)sender {
    [mpController play];
    [rdyPartyView removeFromSuperview];
}

@end
