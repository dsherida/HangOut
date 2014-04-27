//
//  CommentsPFViewController.h
//  HangOut
//
//  Created by Ian Ferreira dos Santos on 4/26/14.
//
//

#import <Parse/Parse.h>
#import "HangOutConstants.h"
#import "TTTTimeIntervalFormatter.h"
#import "HangOutDetailsButton.h"

@interface CommentsPFViewController : PFQueryTableViewController <UIAlertViewDelegate>

@property (nonatomic, strong) PFObject *object;
@property (strong, nonatomic) IBOutlet UITextField *commentTextField;
- (IBAction)commentButtonPressed:(id)sender;

@end
