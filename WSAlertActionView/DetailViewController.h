//
//  DetailViewController.h
//  WSAlertActionView
//
//  Created by warron on 16/9/21.
//  Copyright © 2016年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
