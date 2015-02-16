//
//  SwitchCell.m
//  Yelp
//
//  Created by Vijay Ramakrishnan on 2/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SwitchCell.h"

@interface SwitchCell ()
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *downArrow;
@property (weak, nonatomic) IBOutlet UILabel *seeMore;
- (IBAction)switchValueChanged:(id)sender;
@end

@implementation SwitchCell

- (void)awakeFromNib {
    // Initialization code
    self.seeMore.text = @"See more";
    self.seeMore.textColor = [UIColor lightGrayColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.downArrow.hidden = YES;
    self.seeMore.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchValueChanged:(id)sender {
    [self.delegate switchCell:self didUpdateValue:self.toggleSwitch.on];
}

- (void) hideSeeMore {
    self.seeMore.hidden = YES;
    self.titleLabel.hidden = NO;
    self.toggleSwitch.hidden = NO;
}

-(void) unhideSeeMore {
    self.seeMore.hidden = NO;
    self.titleLabel.hidden = YES;
    self.toggleSwitch.hidden = YES;
}

- (void) hideSwitch {
    self.downArrow.hidden = NO;
    self.toggleSwitch.hidden = YES;
}

- (void) unhideSwitch {
    self.downArrow.hidden = YES;
    self.toggleSwitch.hidden = NO;
}

- (void) setOn: (BOOL)on {
    [self setOn:on animated:NO];
}

- (void) setOn:(BOOL)on animated:(BOOL)animated {
    _on = on;
    [self.toggleSwitch setOn:on animated:animated];
}

@end
