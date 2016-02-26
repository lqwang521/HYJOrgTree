//
//  HYJOrgTreeViewController.h
//  HYJOrgTree
//
//  Created by huyujin on 16/2/26.
//  Copyright © 2016年 huyujin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYJOrgTreeModel;

@protocol HYJOrgTreeVCDelegate <NSObject>

- (void)popOrgVCWithData:(NSMutableArray *)data;

@end

@interface HYJOrgTreeViewController : UIViewController

@property (nonatomic, weak) id<HYJOrgTreeVCDelegate> delegate;

@property (nonatomic, strong) HYJOrgTreeModel *parentOrganization; //当前页面的父节点
@property (nonatomic, strong) NSMutableDictionary *allDataDic;         //组织结构树~
@property (nonatomic, strong) NSMutableArray *selectedDataArr;         // 已选组织结构数组~

///// 通知页面传来的数据~
@property (nonatomic, strong) NSMutableArray *recentDataArr;    // 通知页传来的已选数据~
@property (nonatomic, assign) BOOL isFromOthers;                // 从其他页面进入组织结构页~

- (void)selectOrganization:(UIButton *)sender;
- (void)gotoNext:(UIButton *)sender;

@end
