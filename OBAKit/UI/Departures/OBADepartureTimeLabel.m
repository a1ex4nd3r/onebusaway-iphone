//
//  OBADepartureTimeLabel.m
//  org.onebusaway.iphone
//
//  Created by Chad Royal on 9/25/16.
//  Copyright © 2016 OneBusAway. All rights reserved.
//

#import <OBAKit/OBADepartureTimeLabel.h>
#import <OBAKit/OBAAnimation.h>
#import <OBAKit/OBADepartureCellHelpers.h>
#import <OBAKit/OBADepartureStatus.h>
#import <OBAKit/OBATheme.h>
#import <OBAKit/UIFont+OBAAdditions.h>
#import <OBAKit/OBAMacros.h>
@import Masonry;

@interface OBADepartureTimeLabel ()
@property(nonatomic,strong) UILabel *minutesLabel;
@property(nonatomic,strong) UILabel *abbrLabel;
@property(nonatomic,strong) UIStackView *stackView;
@property(nonatomic,copy) NSString *previousMinutesText;
@property(nonatomic,copy) UIColor *previousMinutesColor;
@property(nonatomic,assign) BOOL firstRenderPass;
@end

@implementation OBADepartureTimeLabel

- (instancetype)init {
    self = [super init];

    if (self) {
        self.backgroundColor = [UIColor redColor];
        _minutesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _minutesLabel.font = OBATheme.headlineFont;
        _minutesLabel.textAlignment = NSTextAlignmentCenter;
        [_minutesLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_minutesLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

        _abbrLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _abbrLabel.hidden = YES;
        _abbrLabel.font = OBATheme.footnoteFont.oba_fontWithSmallCaps;
        _abbrLabel.text = OBALocalized(@"departure_time_label.minutes_abbreviation", @"No more than 3 character abbreviation for minutes. In English: min.");
        _abbrLabel.textAlignment = NSTextAlignmentCenter;
        [_abbrLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_abbrLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_minutesLabel, _abbrLabel]];
        _stackView.axis = UILayoutConstraintAxisVertical;
        [self addSubview:_stackView];

        [_stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        _firstRenderPass = YES;
    }

    return self;
}

- (void)prepareForReuse {
    self.minutesLabel.text = nil;
    self.abbrLabel.hidden = YES;
}

#pragma mark - Label Logic

- (void)setText:(NSString *)minutesUntilDeparture forStatus:(OBADepartureStatus)status {
    self.abbrLabel.hidden = (minutesUntilDeparture.length == 0);
    UIColor *backgroundColor = [OBADepartureCellHelpers colorForStatus:status];

    BOOL textChanged = ![minutesUntilDeparture isEqual:self.previousMinutesText];
    BOOL colorChanged = ![backgroundColor isEqual:self.previousMinutesColor];

    self.previousMinutesText = minutesUntilDeparture;
    self.minutesLabel.text = minutesUntilDeparture;

    self.previousMinutesColor = backgroundColor;
    self.minutesLabel.textColor = backgroundColor;
    self.abbrLabel.textColor = backgroundColor;

    // don't animate the first rendering of the cell.
    if (self.firstRenderPass) {
        self.firstRenderPass = NO;
        return;
    }

    if (textChanged || colorChanged) {
        self.layer.backgroundColor = [OBATheme propertyChangedColor].CGColor;

        [UIView animateWithDuration:OBALongAnimationDuration animations:^{
            self.layer.backgroundColor = self.backgroundColor.CGColor;
        }];
    }
}

@end
