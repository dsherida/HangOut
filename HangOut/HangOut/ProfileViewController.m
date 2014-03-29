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
//        self.wishTitle = @"title";
//        self.message = @"info";
//        self.profilePic = @"User";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        //self.objectsPerPage = 25;
    }
    return self;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count;
    if ((int)[userModel.wishArray count] == 0) {
        count = 1;
    } else {
        count = (int)[userModel.wishArray count] + 1;
    }
    return count;
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



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
//        PFTableViewCell *wishCell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"wishCell"];
//        UILabel *wishLabel = (UILabel *)[wishCell viewWithTag:3];
//        NSLog(@"wishLabel: %@", wishLabel.text);
    }
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
        
        return profileCell;
    } else if (indexPath.row > 0) {
        // Configure wishCell
        NSLog(@"indexPath row: %ld", (long)indexPath.row);
        
        UILabel *wishLabel = (UILabel *)[wishCell viewWithTag:3];
        //wishLabel.text = @"wish label test";
        long i = indexPath.row - 1;
        if ((int)[userModel.wishArray count] > 0) {
            if (i < [userModel.wishArray count]) {
                wishLabel.text = [userModel.wishArray objectAtIndex:i];
            }
        }
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Profile view did load");
    userModel = [UserModel sharedUserModel];
    
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)wishListElementClicked:(UIButton *)sender {
}
@end
