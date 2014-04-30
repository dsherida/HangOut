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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
}
*/

- (IBAction)doneButtonClicked:(id)sender
{
    //NSLog(@"%@", self.titleTextField.text);
    //NSLog(@"%@", self.messageTextField.text);
    //NSLog(@"%@", self.placeTextField.text);
    //NSLog(@"%@", self.dateTextField.date);
    
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
    
    /*
    [wish setObject:[PFUser currentUser] forKey:kUserClassKey];
    [wish setObject:self.titleTextField.text forKey:kWishTitleKey];
    [wish setObject:self.messageTextField.text forKey:kWishInfoKey];
    [wish setObject:self.placeTextField.text forKey:kWishPlaceKey];
    [wish setObject:self.dateTextField.date forKey:kWishDateKey];
    [wish setObject:[NSNumber numberWithBool:self.privacySwitch.on] forKey:kWishPrivacyKey];
     */
    
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
    
    //[wish saveInBackground];
    
    [[self navigationController] popViewControllerAnimated:YES];
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
