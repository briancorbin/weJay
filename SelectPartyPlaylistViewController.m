//
//  SelectPartyPlaylistViewController.m
//  weJay
//
//  Created by Brian Corbin on 3/9/14.
//  Copyright (c) 2014 Brian Corbin. All rights reserved.
//

#import "SelectPartyPlaylistViewController.h"

@interface SelectPartyPlaylistViewController ()

@property (weak, nonatomic) NSArray *playlists;
@property (weak, nonatomic) NSArray *allSongs;
@property (weak, nonatomic) DataManager *dataManager;

@end

@implementation SelectPartyPlaylistViewController

@synthesize dataManager, playlists, allSongs;

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
    
    self.navigationItem.title = @"Pick A Playlist";
    
    MPMediaQuery *playlistQuery = [MPMediaQuery playlistsQuery];
    playlists = [playlistQuery collections];
    
    MPMediaQuery *allSongsQuery = [MPMediaQuery songsQuery];
    allSongs = [allSongsQuery items];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [playlists count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"playlistCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *playlistNameLbl = (UILabel *)[cell viewWithTag:1];
    UILabel *playlistCountLbl = (UILabel *)[cell viewWithTag:2];
    UIImageView *playlistImageView = (UIImageView *)[cell viewWithTag:3];
    
    if(indexPath.item == 0)
    {
        playlistNameLbl.text = @"All Songs";
        playlistCountLbl.text = [NSString stringWithFormat:@"%lu songs",[allSongs count]];
        playlistImageView.image = [UIImage imageNamed:@"noArtworkImage.png"];
    }
    else
    {
        MPMediaPlaylist *playlist = [playlists objectAtIndex:indexPath.item - 1];
        playlistNameLbl.text = [playlist valueForProperty:MPMediaPlaylistPropertyName];
        playlistCountLbl.text = [NSString stringWithFormat:@"%lu songs", [playlist count]];
        playlistImageView.image = [UIImage imageNamed:@"noArtworkImage.png"];
        NSArray *songs = [playlist items];
        if(songs.count != 0)
        {
            MPMediaItem *song = [songs objectAtIndex:0];
            MPMediaItemArtwork *artwork = [song valueForProperty:MPMediaItemPropertyArtwork];
            UIImage *artworkImage;
            if (artwork)
                artworkImage = [artwork imageWithSize: CGSizeMake (64, 64)];
            else
                artworkImage = [UIImage imageNamed:@"noArtworkImage.png"];
            [playlistImageView setImage:artworkImage];
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item == 0)
    {
        dataManager.playQueue = allSongs;
    }
    else
    {
        MPMediaPlaylist *playlist = [playlists objectAtIndex:indexPath.item - 1];
        dataManager.playQueue = playlist.items;
    }
    
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"PartyMasterViewController"] animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
