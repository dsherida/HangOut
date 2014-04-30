//
//  ProfileViewController.m
//  HangOut
//
//  Created by Doug Sheridan on 3/23/14.
//
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

UserModel *userModel;
int tableSize;

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        
        // The className to query on
        self.parseClassName = @"wish";
        
        // The key of the PFObject to display in the label of the default cell style
        self.wishTitle = @"title";
//        self.message = @"info";
//        self.profilePic = @"User";
        
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
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Profile view did load");
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    // Return Yes for supported orientations
    return (self.interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - ProfileViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    _doneLoading = NO;
    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    _doneLoading = YES;
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CGFloat height;

    if(indexPath.row == 0) {
        height = 235.0f;
    } else {
        height = 35.0f;
    }
    return height;
}


- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath
{
    if (_doneLoading == YES) {
        if (indexPath.row < 1) {
            return nil;
        } else if (indexPath.row > (self.objects.count + 1)) {
            return nil;
        } else {
            return [super objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section]];
        }
    }
    return nil;
}

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    NSLog(@"Querying for table...");
    PFQuery *queryWish;
    
    if ([PFUser currentUser] != nil) {
        queryWish = [PFQuery queryWithClassName:kWishClassKey];
        [queryWish whereKey:@"User" equalTo:[PFUser currentUser]];
        
        // If Pull To Refresh is enabled, query against the network by default.
        if (self.pullToRefreshEnabled) {
            queryWish.cachePolicy = kPFCachePolicyNetworkOnly;
        }
        
        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
        if (self.objects.count == 0) {
            queryWish.cachePolicy = kPFCachePolicyCacheThenNetwork;
        }
        
        [queryWish orderByDescending:@"createdAt"];
    }
    
    return queryWish;
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
//    NSLog(@"Building table view...");
    static NSString *profileCellIdentifier = @"profileCell";
    static NSString *wishCellIdentifier = @"wishCell";

    PFTableViewCell *profileCell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:profileCellIdentifier];
    PFTableViewCell *wishCell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:wishCellIdentifier];
    
    if ([PFUser currentUser] != nil) {
        if (profileCell == nil) {
            profileCell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:profileCellIdentifier];
        }
        
        if (wishCell == nil) {
            wishCell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:wishCellIdentifier];
        }
        
        // If we are looking at the first row
        if (indexPath.row == 0) {
            // Configure the profileCell
            UIImageView *profileImage = (UIImageView *)[profileCell viewWithTag:1];
            [profileImage setImage:userModel.profileUIImage];
            
            UILabel *userName = (UILabel *)[profileCell viewWithTag:2];
            userName.text = userModel.userName;
            
            UILabel *followers = (UILabel *)[profileCell viewWithTag:4];
            UILabel *following = (UILabel *)[profileCell viewWithTag:5];
            
            PFQuery *followersQuery = [PFQuery queryWithClassName:kActivityClassKey];
            [followersQuery whereKey:@"type" equalTo:@"follow"];
            [followersQuery whereKey:@"toUser" equalTo:[PFUser currentUser]];
            
            [followersQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                followers.text = [NSString stringWithFormat:@"%d", number];
                //following.text = [following.text stringByAppendingString:@"\nfollowers"];
            }];
            
            PFQuery *followingQuery = [PFQuery queryWithClassName:kActivityClassKey];
            [followingQuery whereKey:@"type" equalTo:@"follow"];
            [followingQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
            
            [followingQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                following.text = [NSString stringWithFormat:@"%d", number];
                //following.text = [following.text stringByAppendingString:@"\nfollowing"];
            }];
            
            profileCell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profilecell.png"]];
            
            return profileCell;
        } else  {
            // Configure wishCell
//            NSLog(@"indexPath row: %ld", (long)indexPath.row);
            
            UILabel *wishLabel = (UILabel *)[wishCell viewWithTag:3];
            wishLabel.text = [object objectForKey:@"title"];
            
            HangOutDetailsButton *comments = (HangOutDetailsButton *)[wishCell viewWithTag:4];
            comments.object = object;
            
            HangOutDetailsButton *attendees = (HangOutDetailsButton *)[wishCell viewWithTag:5];
            attendees.object = object;
            
            PFQuery *attendeesQuery = [PFQuery queryWithClassName:kActivityClassKey];
            [attendeesQuery whereKey:@"type" equalTo:@"going"];
            if (object != nil)
                [attendeesQuery whereKey:@"wish" equalTo:object];
    
            [attendeesQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                [attendees setTitle:[NSString stringWithFormat:@"%d", number] forState:UIControlStateNormal];
            }];
            
            PFQuery *commentsQuery = [PFQuery queryWithClassName:kActivityClassKey];
            [commentsQuery whereKey:@"type" equalTo:@"comment"];
            if (object != nil)
                [commentsQuery whereKey:@"wish" equalTo:object];
            
            [commentsQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                [comments setTitle:[NSString stringWithFormat:@"%d", number] forState:UIControlStateNormal];
            }];
            
            return wishCell;
        }
    }
    
    return nil;
}

- (IBAction)detailsButtonClicked:(id)sender {
    NSLog(@"detailsButton was clicked!");
    
    // -- begin reference:
    // Open source code from: http://stackoverflow.com/questions/7504421/getting-row-of-uitableview-cell-on-button-press
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    // -- end reference
    
    // -- begin reference:
    // open source code from: http://stackoverflow.com/questions/2384435/how-can-i-get-a-uitableviewcell-by-indexpath
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    // -- end reference
    
    UILabel *title = (UILabel *)[cell viewWithTag:3];
    NSString *wishTitle = title.text;
    NSLog(@"Wish title: %@", wishTitle);
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Attendees"]) {
        ListOfAttendeesPFViewController *list = [segue destinationViewController];
        HangOutDetailsButton *button = (HangOutDetailsButton*) sender;
        list.object = button.object;
    }
    if ([segue.identifier isEqualToString:@"Comments"]) {
        CommentsPFViewController *list = [segue destinationViewController];
        HangOutDetailsButton *button = (HangOutDetailsButton*) sender;
        list.object = button.object;
    }
}

@end
