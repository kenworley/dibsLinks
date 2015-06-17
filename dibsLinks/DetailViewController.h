//
//  DetailViewController.h
//  dibsLinks
//
//  Created by Ken Worley on 6/17/15.
//  Copyright (c) 2015 1stdibs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailViewControllerDelegate;

@interface DetailViewController : UIViewController

@property (nonatomic, weak) id<DetailViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *initialLink;

@end

@protocol DetailViewControllerDelegate <NSObject>

-(void)detailViewController:(DetailViewController*)dvc addLink:(NSString*)link withTitle:(NSString*)title;

@end