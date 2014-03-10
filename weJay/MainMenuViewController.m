//
//  MainMenuViewController.m
//  weJay
//
//  Created by Brian Corbin on 3/9/14.
//  Copyright (c) 2014 Brian Corbin. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

- (IBAction)startAPartyAction:(id)sender;
- (IBAction)startAParty:(id)sender;

@end

@implementation MainMenuViewController

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
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startAPartyAction:(id)sender {
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"StartAPartyViewController"] animated:YES];
}

- (IBAction)startAParty:(id)sender {
}
@end
