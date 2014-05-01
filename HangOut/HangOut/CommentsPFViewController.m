//
//  CommentsPFViewController.m
//  HangOut
//
//  Created by Ian Ferreira dos Santos on 4/26/14.
//
//

#import "CommentsPFViewController.h"

@interface CommentsPFViewController ()

@end

@implementation CommentsPFViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithClassName:@"Foo"];
    self = [super initWithCoder:aDecoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"activity";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"text";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:kActivityClassKey];
    [query whereKey:@"wish" equalTo:self.object];
    [query whereKey:@"type" equalTo:@"comment"];
    
    // If Pull To Refresh is enabled, query against the network by default.
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"createdAt"];
    
    return query;
}



// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"comment";
    
    PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    PFUser *attendee = [object objectForKey:@"fromUser"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId" equalTo:[attendee objectId]];
    
    PFImageView *imageView = (PFImageView*)[cell viewWithTag:10];
    UILabel *name = (UILabel*)[cell viewWithTag:20];
    
    UILabel *timeAgo = (UILabel *)[cell viewWithTag:30];
    TTTTimeIntervalFormatter *timeFormatter;
    timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
    NSDate *currentDate = [[NSDate alloc] init];
    timeAgo.text = [timeFormatter stringForTimeIntervalFromDate:[object createdAt] toDate:currentDate];
    
    UITextView *comment = (UITextView*)[cell viewWithTag:40];
    comment.text = [object objectForKey:@"info"];
    [comment setTextColor:[UIColor whiteColor]];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        name.text = [object objectForKey:@"username"];
        imageView.file = [object objectForKey:@"profilePic"];
        [imageView loadInBackground];
    }];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment.png"]];
    return cell;
}

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

- (IBAction)commentButtonPressed:(id)sender {
    if ([self.commentTextField.text length] > 0) {
        PFObject *comment = [PFObject objectWithClassName:kActivityClassKey];
        comment[@"wish"] = self.object;
        comment[@"fromUser"] = [PFUser currentUser];
        comment[@"info"] = self.commentTextField.text;
        comment[@"type"] = @"comment";
        [comment saveInBackground];
        
        [self loadObjects];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                        message:@"Your comment was posted successfully."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        self.commentTextField.text = nil;
        [self.commentTextField resignFirstResponder];
    }
}
@end
