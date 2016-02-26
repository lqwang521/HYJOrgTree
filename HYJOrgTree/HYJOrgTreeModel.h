//
//  HYJOrgModel.h
//  HYJOrgTree
//
//  Created by huyujin on 16/2/26.
//  Copyright © 2016年 huyujin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OrganizationNodeState) {
    OrganizationNodeStateNone = 0,      //未选中~
    OrganizationNodeStatePartial,       //部分选中~
    OrganizationNodeStateAll            //全部选中~
};

typedef NS_ENUM(NSInteger, OrganizationNodeAction) {
    OrganizationNodeActionCancel = 1,    //取消操作~
    OrganizationNodeActionSelect         //选中操作~
};

@interface HYJOrgTreeModel : NSObject

@property (nonatomic, copy) NSString *businessID;   ///< 业务id
@property (nonatomic, copy) NSString *name;         ///< 组织结构名
@property (nonatomic, copy) NSString *type;         ///< 组织结构类型：sub & dep
@property (nonatomic, copy) NSString *hasSubOrg;    ///< 是否有子机构
@property (nonatomic, copy) NSString *parentDepId;  ///< 父机构ID(部门)
@property (nonatomic, copy) NSString *parentSubId;  ///< 父机构ID(分部)

@property (nonatomic, copy) NSString *parentID;     ///< 父节点（用来确定唯一的节点）
@property (nonatomic, copy) NSString *uniqueID;     ///< ID(用来确定唯一的组织机构)

@property (nonatomic, copy) NSString *hierarchy; //层级
@property (nonatomic, assign) OrganizationNodeState state; //结点状态~


- (NSMutableArray *)configureOrgTree;

@end
