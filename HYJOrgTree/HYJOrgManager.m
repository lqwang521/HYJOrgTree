//
//  HYJOrgManager.m
//  HYJOrgTree
//
//  Created by huyujin on 16/2/26.
//  Copyright © 2016年 huyujin. All rights reserved.
//

#import "HYJOrgManager.h"
#import "HYJOrgTreeModel.h"

@implementation HYJOrgManager

+ (instancetype)sharedInstance {
    
    static HYJOrgManager *instance =nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[HYJOrgManager alloc] init];
    });
    return instance;
}

- (NSMutableArray *)configureOrgTree {
    
    NSMutableArray *arrData = [NSMutableArray array];
    //
    HYJOrgTreeModel *model = [HYJOrgTreeModel new];
    model.uniqueID = @"0";
    model.name = [NSString stringWithFormat:@"NAME-%@",model.uniqueID];
    model.hasSubOrg = @"1";
    model.parentID = @"";
    [arrData addObject:model];
    //
    model = [HYJOrgTreeModel new];
    model.uniqueID = @"10";
    model.name = [NSString stringWithFormat:@"NAME-%@",model.uniqueID];
    model.hasSubOrg = @"1";
    model.parentID = @"0";
    [arrData addObject:model];
    
    model = [HYJOrgTreeModel new];
    model.uniqueID = @"11";
    model.name = [NSString stringWithFormat:@"NAME-%@",model.uniqueID];
    model.hasSubOrg = @"0";
    model.parentID = @"0";
    [arrData addObject:model];
    
    model = [HYJOrgTreeModel new];
    model.uniqueID = @"12";
    model.name = [NSString stringWithFormat:@"NAME-%@",model.uniqueID];
    model.hasSubOrg = @"0";
    model.parentID = @"0";
    [arrData addObject:model];
    //
    model = [HYJOrgTreeModel new];
    model.uniqueID = @"100";
    model.name = [NSString stringWithFormat:@"NAME-%@",model.uniqueID];
    model.hasSubOrg = @"1";
    model.parentID = @"10";
    [arrData addObject:model];
    model = [HYJOrgTreeModel new];
    model.uniqueID = @"101";
    model.name = [NSString stringWithFormat:@"NAME-%@",model.uniqueID];
    model.hasSubOrg = @"0";
    model.parentID = @"10";
    [arrData addObject:model];
    model = [HYJOrgTreeModel new];
    model.uniqueID = @"102";
    model.name = [NSString stringWithFormat:@"NAME-%@",model.uniqueID];
    model.hasSubOrg = @"0";
    model.parentID = @"10";
    [arrData addObject:model];
    
    model = [HYJOrgTreeModel new];
    model.uniqueID = @"1000";
    model.name = [NSString stringWithFormat:@"NAME-%@",model.uniqueID];
    model.hasSubOrg = @"0";
    model.parentID = @"100";
    [arrData addObject:model];
    
    return arrData;
}

@end
