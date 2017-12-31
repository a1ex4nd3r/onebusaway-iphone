//
//  OBAClassicDepartureView.m
//  org.onebusaway.iphone
//
//  Created by Aaron Brethorst on 5/26/16.
//  Copyright © 2016 OneBusAway. All rights reserved.
//

#import <OBAKit/OBAClassicDepartureView.h>
@import Masonry;
#import <OBAKit/OBAAnimation.h>
#import <OBAKit/OBADepartureTimeLabel.h>
#import <OBAKit/OBAUIBuilder.h>
#import <OBAKit/OBATheme.h>
#import <OBAKit/OBADateHelpers.h>
#import <OBAKit/OBADepartureCellHelpers.h>
#import <OBAKit/OBAMacros.h>

#define kUseDebugColors NO
#define kBodyFont OBATheme.bodyFont
#define kBoldBodyFont OBATheme.boldBodyFont
#define kSmallFont OBATheme.subheadFont

@interface OBAClassicDepartureView ()
@property(nonatomic,strong,readwrite) UIButton *contextMenuButton;
@property(nonatomic,strong) UILabel *routeLabel;
@property(nonatomic,strong) UILabel *departureTimeLabel;
@property(nonatomic,strong,readwrite) OBADepartureTimeLabel *leadingLabel;
@property(nonatomic,strong) UIView *leadingWrapper;

@property(nonatomic,strong,readwrite) OBADepartureTimeLabel *centerLabel;
@property(nonatomic,strong) UIView *centerWrapper;

@property(nonatomic,strong,readwrite) OBADepartureTimeLabel *trailingLabel;
@property(nonatomic,strong) UIView *trailingWrapper;
@end

@implementation OBAClassicDepartureView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithLabelAlignment:OBAClassicDepartureViewLabelAlignmentCenter];
}

- (instancetype)initWithLabelAlignment:(OBAClassicDepartureViewLabelAlignment)labelAlignment {
    self = [super initWithFrame:CGRectZero];

    if (self) {
        self.clipsToBounds = YES;

        _labelAlignment = OBAClassicDepartureViewLabelAlignmentCenter;

        _routeLabel = ({
            UILabel *l = [[UILabel alloc] init];
            [l setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [l setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
            [l setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
            l;
        });
        _departureTimeLabel = ({
            UILabel *l = [[UILabel alloc] init];
            [l setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [l setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
            [l setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
            l;
        });

        _leadingLabel = [self.class departureTimeLabel];
        _leadingWrapper = [self.class wrapLabel:_leadingLabel withLabelAlignment:_labelAlignment];

        _centerLabel = [self.class departureTimeLabel];
        _centerWrapper = [self.class wrapLabel:_centerLabel withLabelAlignment:_labelAlignment];

        _trailingLabel = [self.class departureTimeLabel];
        _trailingWrapper = [self.class wrapLabel:_trailingLabel withLabelAlignment:_labelAlignment];

        _contextMenuButton = [OBAUIBuilder contextMenuButton];

        if (kUseDebugColors) {
            self.backgroundColor = [UIColor purpleColor];
            _routeLabel.backgroundColor = [UIColor greenColor];
            _departureTimeLabel.backgroundColor = [UIColor blueColor];

            _leadingLabel.backgroundColor = [UIColor magentaColor];
            _leadingWrapper.backgroundColor = [UIColor redColor];

            _centerLabel.backgroundColor = [UIColor magentaColor];
            _centerWrapper.backgroundColor = [UIColor blueColor];

            _trailingLabel.backgroundColor = [UIColor magentaColor];
            _trailingWrapper.backgroundColor = [UIColor brownColor];

            _contextMenuButton.backgroundColor = [UIColor yellowColor];
        }

        UIStackView *labelStack = [[UIStackView alloc] initWithArrangedSubviews:@[_routeLabel, _departureTimeLabel]];
        labelStack.axis = UILayoutConstraintAxisVertical;
        labelStack.distribution = UIStackViewDistributionFill;
        labelStack.spacing = 0;

        UIStackView *horizontalStack = ({
            UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[labelStack, _leadingWrapper, _centerWrapper, _trailingWrapper, _contextMenuButton]];
            stack.axis = UILayoutConstraintAxisHorizontal;
            stack.distribution = UIStackViewDistributionFill;
            stack.spacing = OBATheme.compactPadding;
            stack;
        });
        [self addSubview:horizontalStack];

        [horizontalStack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        [_contextMenuButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@40);
            make.height.greaterThanOrEqualTo(@40);
        }];
    }
    return self;
}

#pragma mark - Reuse

- (void)prepareForReuse {
    self.routeLabel.text = nil;
    self.departureTimeLabel.text = nil;
    [self.leadingLabel prepareForReuse];
    [self.centerLabel prepareForReuse];
    [self.trailingLabel prepareForReuse];
}

#pragma mark - Row Logic

- (void)setDepartureRow:(OBADepartureRow *)departureRow {
    if (_departureRow == departureRow) {
        return;
    }

    _departureRow = [departureRow copy];

    [self renderRouteLabel];
    [self renderDepartureTimeLabel];

    if ([self departureRow].upcomingDepartures.count > 0) {
        self.leadingWrapper.hidden = NO;
        [self setDepartureStatus:[self departureRow].upcomingDepartures[0] forLabel:self.leadingLabel];
    }
    else {
        self.leadingWrapper.hidden = YES;
    }

    if ([self departureRow].upcomingDepartures.count > 1) {
        self.centerWrapper.hidden = NO;
        [self setDepartureStatus:[self departureRow].upcomingDepartures[1] forLabel:self.centerLabel];
    }
    else {
        self.centerWrapper.hidden = YES;
    }

    if ([self departureRow].upcomingDepartures.count > 2) {
        self.trailingWrapper.hidden = NO;
        [self setDepartureStatus:[self departureRow].upcomingDepartures[2] forLabel:self.trailingLabel];
    }
    else {
        self.centerWrapper.hidden = YES;
    }
}

- (void)setDepartureStatus:(OBAUpcomingDeparture*)departure forLabel:(OBADepartureTimeLabel*)label {
    label.accessibilityLabel = [OBADateHelpers formatAccessibilityLabelMinutesUntilDate:departure.departureDate];
    [label setText:[OBADateHelpers formatMinutesUntilDate:departure.departureDate] forStatus:departure.departureStatus];
}

#pragma mark - Label Logic

- (void)renderRouteLabel {
    if ([self departureRow].destination) {
        self.routeLabel.text = [NSString stringWithFormat:OBALocalized(@"text_route_to_orientation_newline_params", @"Route formatting string. e.g. 10 to Downtown Seattle"), [self departureRow].routeName, [self departureRow].destination];
    }
    else {
        self.routeLabel.text = [self departureRow].routeName;
    }

    NSMutableAttributedString *routeText = [[NSMutableAttributedString alloc] initWithString:self.routeLabel.text attributes:@{NSFontAttributeName: kBodyFont}];

    [routeText addAttribute:NSFontAttributeName value:kBoldBodyFont range:NSMakeRange(0, [self departureRow].routeName.length)];
    self.routeLabel.attributedText = routeText;
}

- (void)renderDepartureTimeLabel {
    OBAUpcomingDeparture *upcoming = [self departureRow].upcomingDepartures.firstObject;
    NSAttributedString *departureTime = [OBADepartureCellHelpers attributedDepartureTimeWithStatusText:[self departureRow].statusText upcomingDeparture:upcoming];

    self.departureTimeLabel.attributedText = departureTime;
}

#pragma mark - Label and Wrapper Builders

+ (OBADepartureTimeLabel*)departureTimeLabel {
    OBADepartureTimeLabel *label = [[OBADepartureTimeLabel alloc] init];
    return label;
}

+ (UIView*)wrapLabel:(OBADepartureTimeLabel*)label withLabelAlignment:(OBAClassicDepartureViewLabelAlignment)labelAlignment {
    UIView *minutesWrapper = [[UIView alloc] initWithFrame:CGRectZero];
    minutesWrapper.clipsToBounds = YES;
    [minutesWrapper addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        MASConstraint *constraint = labelAlignment == OBAClassicDepartureViewLabelAlignmentTop ? make.top : make.centerY;
        constraint.equalTo(minutesWrapper);
        make.left.and.right.equalTo(minutesWrapper);
    }];

    return minutesWrapper;
}

@end
