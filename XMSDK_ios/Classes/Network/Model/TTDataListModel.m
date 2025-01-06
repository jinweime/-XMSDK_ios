//
//  TTDataListModel.m
//  TTKanKan
//
//  Created by wjc on 2017/1/12.
//  Copyright © 2017年 kankan. All rights reserved.
//

#import "TTDataListModel.h"

@implementation TTDataListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"totalCount"  : @"total",
             @"perPageCount"  : @"per_page",
             @"currentPage"  : @"current_page",
             @"hasNextPage" : @"has_next_page",
             @"nextIndex"  : @"next",
            };
}

@end



