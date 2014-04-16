//
//  HangOutAlertView.h
//  HangOut
//
//  Created by Ian Ferreira dos Santos on 4/9/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "HangOutJoinButton.h"

@interface HangOutAlertView : UIAlertView

@property (weak, nonatomic) PFObject *object;
@property (weak, nonatomic) HangOutJoinButton *button;

@end
