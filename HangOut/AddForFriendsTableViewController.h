//
//  AddForFriendsTableViewController.h
//  HangOut
//
//  Created by Ian Ferreira dos Santos on 3/23/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddForFriendsTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *messageTextField;
@property (weak, nonatomic) IBOutlet UITextField *placeTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateTextField;

- (IBAction)doneButtonClicked:(id)sender;

@end
