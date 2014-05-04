//
//  PartyOptionsViewController.m
//  weJay
//
//  Created by Brian Corbin on 3/18/14.
//  Copyright (c) 2014 Brian Corbin. All rights reserved.
//

#import "PartyOptionsViewController.h"

@interface PartyOptionsViewController ()

@property (weak, nonatomic) DataManager *dataManager;

@property (weak, nonatomic) IBOutlet UISlider *downvotePcntSlider;
@property (weak, nonatomic) IBOutlet UISlider *volPcntSlider;
@property (weak, nonatomic) IBOutlet UILabel *downvoteLbl;
@property (weak, nonatomic) IBOutlet UILabel *volPcntLbl;
@property (weak, nonatomic) IBOutlet UILabel *viewableSongsLbl;

- (IBAction)downvotePcntChngAction:(id)sender;
- (IBAction)volPcntChngAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;

@end

@implementation PartyOptionsViewController

@synthesize downvotePcntSlider, volPcntSlider, dataManager;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dataManager = [DataManager sharedInstance];
    
    downvotePcntSlider.value = dataManager.downvotePcnt;
    volPcntSlider.value = dataManager.volChangePcnt;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)downvotePcntChngAction:(id)sender {
    dataManager.downvotePcnt = downvotePcntSlider.value;
}

- (IBAction)volPcntChngAction:(id)sender {
    dataManager.volChangePcnt = volPcntSlider.value;
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
