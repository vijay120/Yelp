//
//  SwitchCell.h
//  Yelp
//
//  Created by Vijay Ramakrishnan on 2/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchCell;

@protocol SwitchCellDelegate <NSObject>

- (void) switchCell: (SwitchCell *)cell didUpdateValue:(BOOL)value;



@end

@interface SwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) BOOL on;
@property (nonatomic, weak) id<SwitchCellDelegate> delegate;

- (void) setOn:(BOOL)on animated:(BOOL)animated;
- (void) hideSwitch;
- (void) unhideSwitch;
- (void) hideSeeMore;
- (void) unhideSeeMore;

@end
