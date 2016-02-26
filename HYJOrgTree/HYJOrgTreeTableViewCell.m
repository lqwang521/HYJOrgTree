//
//  HYJOrgTreeTableViewCell.m
//  HYJOrgTree
//
//  Created by huyujin on 16/2/26.
//  Copyright © 2016年 huyujin. All rights reserved.
//

#import "HYJOrgTreeTableViewCell.h"
#import "HYJOrgTreeModel.h"
#import "HYJOrgTreeViewController.h"
#import "AppContants.h"
#import "HYJHelper.h"

const NSInteger kDefaultSFSelectButtonTag = 1234;
const NSInteger kDefaultSFJumpButtonTag   = 12345;
const NSInteger kDefaultSFNameButtonTag    = 123456;

static const NSInteger kSelectButtonWidth = 45;
static const NSInteger kJumpButtonWidth = 45;
static const NSInteger kSelectButtonHeight = kSelectButtonWidth;
static const NSInteger kJumpButtonheight = kJumpButtonWidth;

@implementation HYJOrgTreeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectButton = selectButton;
        [self.contentView addSubview:self.selectButton];
        [self configureButton:selectButton withRect:CGRectMake(0, 0, kSelectButtonWidth, kSelectButtonHeight) normalImage:[UIImage imageNamed:@"SF_button_unselect"] imageEdgeInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
        
        UIButton *jumpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.jumpButton = jumpButton;
        [self.contentView addSubview:self.jumpButton];
        [jumpButton setImage:[UIImage imageNamed:@"right_go"] forState:UIControlStateSelected];
        [self configureButton:jumpButton withRect:CGRectMake(SCREEN_WIDTH-kJumpButtonWidth, 0, kJumpButtonWidth, kJumpButtonheight) normalImage:[UIImage imageNamed:@"right_go"] imageEdgeInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
        
        CGFloat nameLabelWidth = SCREEN_WIDTH-kSelectButtonWidth-2-self.jumpButton.frame.size.width-2;
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSelectButtonWidth+2, 0,nameLabelWidth, 45)];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:self.nameLabel];
    }
    
    return self;
}


/// 配置cell
- (HYJOrgTreeTableViewCell *)configureCell:(HYJOrgTreeTableViewCell *)cell withController:(HYJOrgTreeViewController *)vc Model:(HYJOrgTreeModel *)model atIndexPath:(NSIndexPath *)indexPath {
    //
    UIButton *selectButton = cell.selectButton;
    UIButton *jumpButton = cell.jumpButton;
    UILabel *nameLabel = cell.nameLabel;
    //若是最底层节点，则跳转箭头不显示，对应的布局做调整~
    if ([model.hasSubOrg isEqualToString:@"0"]) {
        jumpButton.frame = CGRectMake(jumpButton.frame.origin.x, jumpButton.frame.origin.y, 0, jumpButton.frame.size.height);
        jumpButton.hidden = YES;
        CGFloat nameLabelWidth = SCREEN_WIDTH-kSelectButtonWidth-2-self.jumpButton.frame.size.width-2;
        nameLabel.frame = CGRectMake(kSelectButtonWidth+2, 0,nameLabelWidth, 45);
    }else {
        jumpButton.frame = CGRectMake(jumpButton.frame.origin.x, jumpButton.frame.origin.y, kJumpButtonWidth, jumpButton.frame.size.height);
        jumpButton.hidden = NO;
        CGFloat nameLabelWidth = SCREEN_WIDTH-kSelectButtonWidth-2-self.jumpButton.frame.size.width-2;
        nameLabel.frame = CGRectMake(kSelectButtonWidth+2, 0,nameLabelWidth, 45);
    }
    
    [selectButton addTarget:vc action:@selector(selectOrganization:) forControlEvents:UIControlEventTouchUpInside];
    selectButton.tag = kDefaultSFSelectButtonTag+indexPath.row;
    [jumpButton addTarget:vc action:@selector(gotoNext:) forControlEvents:UIControlEventTouchUpInside];
    jumpButton.tag = kDefaultSFJumpButtonTag+indexPath.row;
    //
    nameLabel.text = model.name;
    nameLabel.font = [UIFont systemFontOfSize:16.0f];
    nameLabel.textColor = [HYJHelper colorWithHexString:@"#333333"];
    
    switch (model.state) {
        case OrganizationNodeStateNone:
        {
            [selectButton setImage:[UIImage imageNamed:@"SF_button_unselect"] forState:UIControlStateNormal];
            break;
        }
        case OrganizationNodeStatePartial:
        {
            [selectButton setImage:[UIImage imageNamed:@"SF_button_partial_select"] forState:UIControlStateNormal];
            break;
        }
        case OrganizationNodeStateAll:
        {
            [selectButton setImage:[UIImage imageNamed:@"SF_button_select"] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark- public methods
- (UIButton *)configureButton:(UIButton *)button withRect:(CGRect)rect normalImage:(UIImage *)image imageEdgeInsets:(UIEdgeInsets)edgeInsets {
    button.frame = rect;
    [button setImage:image forState:UIControlStateNormal];
    button.imageEdgeInsets = edgeInsets;
    return button;
}

// 计算字符串的宽度
+ (float)getWidthWithText:(NSString *)str andFont:(CGFloat)labelFont {
    
    CGSize stringSize = [str sizeWithFont:[UIFont systemFontOfSize:labelFont]];
    
    BOOL iOS7Device = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
    if (iOS7Device) {
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:labelFont]};
        stringSize = [str sizeWithAttributes:attributes];
    }
    float labelWidth = stringSize.width;
    
    return labelWidth;
}

@end
