//
//  AddForFriendsTableViewController.h
//  HangOut
//
//  Created by Ian Ferreira dos Santos on 3/23/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "HangOutConstants.h"
#import <Mapkit/MapKit.h>
#import "UserModel.h"

@interface AddWishTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *messageTextField;
@property (weak, nonatomic) IBOutlet UITextField *placeTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateTextField;
@property (weak, nonatomic) IBOutlet UISwitch *privacySwitch;

- (IBAction)doneButtonClicked:(id)sender;

@end
