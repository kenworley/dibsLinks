//
//  MasterViewController.m
//  dibsLinks
//
//  Created by Ken Worley on 6/17/15.
//  Copyright (c) 2015 1stdibs. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

static NSString* const kLinksStorageKey = @"com.1stdibs.dibsLinks.urls";

@interface MasterViewController () <DetailViewControllerDelegate>

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];

    self.objects = [[[NSUserDefaults standardUserDefaults] objectForKey:kLinksStorageKey] mutableCopy];
    if (self.objects.count == 0)
    {
        // Add initial set
        self.objects = [NSMutableArray array];
        [self.objects addObject:@{@"title":@"Latest Jewelry", @"link":@"dibs://www.1stdibs.com/jewelry/?latest=true&h=true"}];
        [self.objects addObject:@{@"title":@"Postmodern Design Collection", @"link":@"dibs://www.1stdibs.com/collections/postmodern-design/"}];
        [self.objects addObject:@{@"title":@"A Magritte Painting", @"link":@"dibs://www.1stdibs.com/art/prints-works-on-paper/rene-magritte-golconde-golconda/id-a_135592/"}];
        [self.objects addObject:@{@"title":@"Contemporary Oil Paintings from 70s", @"link":@"dibs://www.1stdibs.com/art/style/contemporary/?material=oil-paint&per=1970-1980"}];
        [self.objects addObject:@{@"title":@"Furniture from Ireland", @"link":@"dibs://www.1stdibs.com/locations/ireland-europe/furniture"}];
        [self.objects addObject:@{@"title":@"Paul Evans", @"link":@"dibs://www.1stdibs.com/creators/paul-evans/furniture/"}];
        [self.objects addObject:@{@"title":@"EW Musical Instruments Co", @"link":@"dibs://www.1stdibs.com/creators/east-west-musical-instruments-company/fashion/"}];
        [self.objects addObject:@{@"title":@"20th Century Specialists", @"link":@"dibs://www.1stdibs.com/collections/20th-century-specialists/"}];
        [self.objects addObject:@{@"title":@"1stdibs @ NYDC", @"link":@"dibs://www.1stdibs.com/associations/1stdibs-at-nydc-new-york-design-center/"}];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveLinks
{
    if (self.objects != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:self.objects forKey:kLinksStorageKey];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"addLink"]) {
        DetailViewController *dvc = (DetailViewController*)[segue destinationViewController];
        dvc.delegate = self;

        NSString *pbString = [UIPasteboard generalPasteboard].string;
        if (pbString.length > 0)
        {
            // Don't suggest pasteboard string if it's already in my list
            if (![[self.objects valueForKey:@"link"] containsObject:pbString])
            {
                NSURL *url = [NSURL URLWithString:pbString];
                if (url != nil)
                {
                    dvc.initialLink = pbString;
                }
            }
        }
    }
}

#pragma mark - Detail View Delegate

-(void)detailViewController:(DetailViewController *)dvc addLink:(NSURL *)link withTitle:(NSString *)title
{
    [dvc.navigationController popViewControllerAnimated:YES];
    
    if (title.length == 0)
    {
        title = @"Link";
    }
    
    if (link != nil)
    {
        if (!self.objects) {
            self.objects = [[NSMutableArray alloc] init];
        }
        
        [self.tableView beginUpdates];
        [self.objects addObject:@{@"title":title, @"link":link}];
        NSIndexPath *newRow = [NSIndexPath indexPathForRow:self.objects.count-1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[newRow] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
        [self saveLinks];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *dict = self.objects[indexPath.row];
    cell.textLabel.text = dict[@"title"];
    cell.detailTextLabel.text = dict[@"link"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.objects[indexPath.row];
    NSString *link = dict[@"link"];
    NSURL *url = [NSURL URLWithString:link];
    if (url != nil)
    {
        [[UIApplication sharedApplication] openURL:url];
    }

    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self saveLinks];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end

