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
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
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
//    userModel = [UserModel sharedUserModel];
    
    //    [userModel getAndSetWishArray];
    //    tableSize = [userModel.wishArray count] + 1;
    
    //NSLog(@"Loaded Profile View");
    //NSLog(@"Username: %@", userModel.userName);
    
    //[self.tableView reloadData];
    
    //UIImage *image = [UIImage imageWithData:userModel.profilePictureData];
    //[_UIProfilePic setImage:image];
    
    //[_UINameLabel setText:userModel.userName];
    //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    
    //PFUser *user = [PFUser currentUser];
    //self.userName.text = user.username;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    
    PFQuery *queryWish = [PFQuery queryWithClassName:kWishClassKey];
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
    
    return queryWish;
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


// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    NSLog(@"Building table view...");
    static NSString *profileCellIdentifier = @"profileCell";
    static NSString *wishCellIdentifier = @"wishCell";

    PFTableViewCell *profileCell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:profileCellIdentifier];
    PFTableViewCell *wishCell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:wishCellIdentifier];
    
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
        
//        self.object = [object objectForKey:@"title"];
        //NSLog(@"%@", self.object);
//        for(id key in self.object)
//            NSLog(@"key=%@ value=%@", key, [self.object objectForKey:key]);
        
        return profileCell;
    } else  { //if (indexPath.row > 0)
        // Configure wishCell
        NSLog(@"indexPath row: %ld", (long)indexPath.row);
        
        UILabel *wishLabel = (UILabel *)[wishCell viewWithTag:3];
        wishLabel.text = [object objectForKey:@"title"];
        return wishCell;
    }
    
    return nil;
}




//- (id)initWithStyle:(UITableViewStyle)style {
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}










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

- (IBAction)wishListElementClicked:(UIButton *)sender {
}

@end
