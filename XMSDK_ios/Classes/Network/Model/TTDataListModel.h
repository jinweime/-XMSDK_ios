//
//  TTDataListModel.h
//  TTKanKan
//
//  Created by wjc on 2017/1/12.
//  Copyright © 2017年 kankan. All rights reserved.
//
/**
 * 有关分页功能的公共模型数据,用法：直接继承自该Model即可
 */

#import <Foundation/Foundation.h>

@interface TTDataListModel : NSObject
/** 总数量 */
@property (nonatomic, assign) NSUInteger totalCount;
/** 每次获取的数量 */
@property (nonatomic, assign) NSUInteger perPageCount;
/** 当前页 */
@property (nonatomic, assign) NSUInteger currentPage;
/** 是否还有下一页，1代表有，0代表没有 */
@property (nonatomic, assign) NSUInteger hasNextPage;
/** 模型数组，存储相对应的模型Model */
@property (nonatomic, strong) NSArray *dataList;
/** 下一页的下标， 推荐up主列表有*/
@property (nonatomic, assign) NSInteger nextIndex;

+ (NSDictionary *)modelCustomPropertyMapper;
@end


