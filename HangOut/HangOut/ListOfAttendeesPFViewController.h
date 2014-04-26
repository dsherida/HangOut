//
//  ListOfAttendeesPFViewController.h
//  HangOut
//
//  Created by Ian Ferreira dos Santos on 4/22/14.
//
//

#import <Parse/Parse.h>
#import "HangOutConstants.h"

@interface ListOfAttendeesPFViewController : PFQueryTableViewController

@property (nonatomic, strong) PFObject *object;

@end
