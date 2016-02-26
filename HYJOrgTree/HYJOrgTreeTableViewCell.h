//
//  HYJOrgTreeTableViewCell.h
//  HYJOrgTree
//
//  Created by huyujin on 16/2/26.
//  Copyright © 2016年 huyujin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYJOrgTreeViewController;
@class HYJOrgTreeModel;

FOUNDATION_EXPORT NSInteger const kDefaultSFSelectButtonTag;
FOUNDATION_EXPORT NSInteger const kDefaultSFJumpButtonTag;
FOUNDATION_EXPORT NSInteger const kDefaultSFNameButtonTag;

@interface HYJOrgTreeTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *selectButton;  /// 选择button
@property (nonatomic, strong) UILabel *nameLabel;      /// 部门名字label
@property (nonatomic, strong) UIButton *jumpButton;    /// 跳转button~


- (HYJOrgTreeTableViewCell *)configureCell:(HYJOrgTreeTableViewCell *)cell withController:(HYJOrgTreeViewController *)vc Model:(HYJOrgTreeModel *)model atIndexPath:(NSIndexPath *)indexPath;

- (UIButton *)configureButton:(UIButton *)button withRect:(CGRect)rect normalImage:(UIImage *)image imageEdgeInsets:(UIEdgeInsets)edgeInsets;

+ (float)getWidthWithText:(NSString *)labelStr andFont:(CGFloat)labelFont;

@end
