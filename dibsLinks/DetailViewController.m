//
//  DetailViewController.m
//  dibsLinks
//
//  Created by Ken Worley on 6/17/15.
//  Copyright (c) 2015 1stdibs. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) NSURL* link;
@property (weak, nonatomic) IBOutlet UITextView *urlTextView;
@property (weak, nonatomic) IBOutlet UITextField *urlTitleField;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.initialLink.length > 0)
    {
        self.urlTitleField.text = @"From Pasteboard";
        self.urlTextView.text = self.initialLink;
    }
    else
    {
        self.urlTitleField.text = nil;
        self.urlTextView.text = nil;
    }
}

-(IBAction)dibsify:(id)sender
{
    NSMutableString *linkTxt = [self.urlTextView.text mutableCopy];
    if (linkTxt.length == 0)
    {
        return;
    }
    
    [linkTxt replaceOccurrencesOfString:@"https://" withString:@"dibs://" options:NSCaseInsensitiveSearch range:NSMakeRange(0, linkTxt.length)];
    [linkTxt replaceOccurrencesOfString:@"http://" withString:@"dibs://" options:NSCaseInsensitiveSearch range:NSMakeRange(0, linkTxt.length)];
    
    self.urlTextView.text = linkTxt;
}

-(IBAction)saveLink:(id)sender
{
    NSURL *url = [NSURL URLWithString:self.urlTextView.text];
    if (url != nil)
    {
        [self.delegate detailViewController:self addLink:self.urlTextView.text withTitle:self.urlTitleField.text];
    }
    else if ([self.urlTextView.text rangeOfString:@"INVALID LINK:"].location == NSNotFound)
    {
        self.urlTextView.text = [NSString stringWithFormat:@"INVALID LINK: %@", self.urlTextView.text];
    }
}

-(IBAction)cancelLink:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
