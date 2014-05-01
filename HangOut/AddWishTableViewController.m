//
//  AddForFriendsTableViewController.m
//  HangOut
//
//  Created by Ian Ferreira dos Santos on 3/23/14.
//
//

#import "AddWishTableViewController.h"

@interface AddWishTableViewController ()

@end

@implementation AddWishTableViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (IBAction)doneButtonClicked:(id)sender {
    
    if (!self.titleTextField.hasText || !self.messageTextField.hasText || !self.placeTextField.hasText) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your wish"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Dismiss",nil];
        [alert show];
        return;
    }
    
    // Create Wish Object
    PFObject *wish = [PFObject objectWithClassName:kWishClassKey];
    wish[@"User"] = [PFUser currentUser];
    wish[kWishTitleKey] = self.titleTextField.text;
    wish[kWishInfoKey] = self.messageTextField.text;
    wish[kWishPlaceKey] = self.placeTextField.text;
    wish[kWishDateKey] = self.dateTextField.date;
    wish[kWishPrivacyKey] = [NSNumber numberWithBool:self.privacySwitch.on];
    
    // Wishes are public, but only the creator can modify it
    PFACL *wishACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [wishACL setPublicReadAccess:YES];
    wish.ACL = wishACL;
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder geocodeAddressString:self.placeTextField.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Geocode failed with error: %@", error);
            return;
        }
        
        if (placemarks && placemarks.count > 0)
        {
            CLPlacemark *placemark = placemarks[0];
            CLLocation *location = placemark.location;
            CLLocationCoordinate2D coordinate = [location coordinate];
            PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude
                                                          longitude:coordinate.longitude];
            
            wish[@"location"] = geoPoint;
            [wish saveInBackground];
            
            
        } else {
            UserModel *userModel = [UserModel sharedUserModel];
            
            wish[@"location"] = [userModel location];
            [wish saveInBackground];
        }
    }];
    
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
