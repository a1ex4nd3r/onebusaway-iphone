//
//  OBACompactRouteBookmarkCell.m
//  OBAKit
//
//  Created by Aaron Brethorst on 12/30/17.
//  Copyright © 2017 OneBusAway. All rights reserved.
//

#import <OBAKit/OBACompactRouteBookmarkCell.h>
#import <OBAKit/OBABookmarkedRouteRow.h>
#import <OBAKit/OBAMacros.h>

@interface OBACompactRouteBookmarkCell ()
@property(nonatomic,copy,readonly) OBABookmarkedRouteRow* bookmarkedRouteRow;
@end

@implementation OBACompactRouteBookmarkCell
@synthesize tableRow = _tableRow;

#pragma mark - OBATableCell

- (void)setTableRow:(OBABaseRow *)tableRow {
    OBAGuardClass(tableRow, OBABookmarkedRouteRow) else {
        return;
    }

    _tableRow = [tableRow copy];
}

- (OBABookmarkedRouteRow*)bookmarkedRouteRow {
    return (OBABookmarkedRouteRow*)self.tableRow;
}

@end
