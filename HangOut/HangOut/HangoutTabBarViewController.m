//
//  HangoutTabBarViewController.m
//  HangOut
//
//  Created by Ian Ferreira dos Santos on 4/7/14.
//
//

#import "HangoutTabBarViewController.h"

@interface HangoutTabBarViewController ()

@end

@implementation HangoutTabBarViewController

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
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:91.0/255.0 green:205.0/255.0 blue:194.0/255.0 alpha:1]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
