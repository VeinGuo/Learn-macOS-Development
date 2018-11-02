//
//  TableData.h
//  TableView
//
//  Created by Vein on 2018/10/30.
//  Copyright © 2018 Vein. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableData : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *remark;

- (instancetype)initWithTitle:(NSString *)title
                       remark:(NSString *)remark;

@end

NS_ASSUME_NONNULL_END
