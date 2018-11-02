//
//  TableData.m
//  TableView
//
//  Created by Vein on 2018/10/30.
//  Copyright © 2018 Vein. All rights reserved.
//

#import "TableData.h"

@implementation TableData

- (instancetype)initWithTitle:(NSString *)title
                       remark:(NSString *)remark {
    self = [super init];
    if (self) {
        _title = title;
        _remark = remark;
    }
    return self;
}

@end
