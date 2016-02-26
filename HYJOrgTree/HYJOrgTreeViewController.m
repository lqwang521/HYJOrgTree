//
//  HYJOrgTreeViewController.m
//  HYJOrgTree
//
//  Created by huyujin on 16/2/26.
//  Copyright © 2016年 huyujin. All rights reserved.
//

#import "HYJOrgTreeViewController.h"
#import "HYJHelper.h"
#import "HYJOrgTreeModel.h"
#import "AppContants.h"
#import "HYJOrgTreeTableViewCell.h"
#import "HYJOrgManager.h"


static NSString *kCellIdentifier = @"kCellIdentifier";

static const NSInteger kDefaultBottomViewHeight = 50;
static const NSInteger kDefaultNameLabelMargin = 10;

@interface ButtonLayout : NSObject

@property (nonatomic, assign) float width;
@property (nonatomic, assign) float positionX;

@end

@implementation ButtonLayout

@end


@interface HYJOrgTreeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *primaryDataArr;

@property (nonatomic, strong) NSMutableArray *currentDataArr;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIScrollView *selectedView;

@property (nonatomic, strong) UIView *errorView;

@property (nonatomic, strong) NSMutableArray *buttonLayoutArr;

@end

@implementation HYJOrgTreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    //刷新tableview~
    [self.tableView reloadData];
    //刷新底部view~
    [self refreshBottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initView {
    
    self.view.backgroundColor = [HYJHelper colorWithHexString:@"#f0f1f2"];
    self.title = @"HYJ";
    
    // tableview~
    self.tableView = ({
        UITableView *view = [UITableView new];
        [self.view addSubview:view];
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kDefaultBottomViewHeight);
        view.backgroundColor = [HYJHelper colorWithHexString:@"#f0f1f2"];
        view.separatorColor = [HYJHelper colorWithHexString:@"#e0e0e0"];
        view.rowHeight = 45;
        view.delegate = self;
        view.dataSource = self;
        
        view;
    });
    [self.tableView registerClass:[HYJOrgTreeTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    
    //底部view~
    self.bottomView = ({
        UIView *bottomView = [UIView new];
        [self.view addSubview:bottomView];
        bottomView.frame = CGRectMake(0, SCREEN_HEIGHT-kDefaultBottomViewHeight, SCREEN_WIDTH, kDefaultBottomViewHeight);
        bottomView.backgroundColor = [HYJHelper colorWithHexString:@"#f7f7f7"];
        //右部button~
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [bottomView addSubview:button];
        button.frame = CGRectMake(SCREEN_WIDTH-100, 0, 100, bottomView.frame.size.height);
        button.backgroundColor = [HYJHelper colorWithHexString:@"#df3031"];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        bottomView;
    });
    
    //底部已选中 view~
    self.selectedView = ({
        UIScrollView *selectedView = [UIScrollView new];
        [self.bottomView addSubview:selectedView];
        selectedView.frame = CGRectMake(0, 0, SCREEN_WIDTH-100, self.bottomView.frame.size.height);
        selectedView.backgroundColor = [HYJHelper colorWithHexString:@"#f7f7f7"];
        selectedView.contentSize = CGSizeMake(selectedView.frame.size.width, selectedView.frame.size.height);
        selectedView.showsHorizontalScrollIndicator = NO;
        
        selectedView;
    });
    
}

- (void)initData {
    
    self.primaryDataArr = [NSMutableArray array];
    self.buttonLayoutArr = [NSMutableArray array];
    self.currentDataArr = [NSMutableArray array];
    
    if (self.isFromOthers) {//若来自其他页面~
        
        self.allDataDic = [NSMutableDictionary dictionary];
        self.selectedDataArr = [NSMutableArray array];
        self.recentDataArr = [NSMutableArray array];

        
        [self createOrganizationTree];
        [self updateRecentDataArr];
        //组织结构首页~设置currentDataArr~搜房网下级节点~
        if (self.allDataDic.count>0) {
            [self.allDataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, HYJOrgTreeModel *obj, BOOL * _Nonnull stop) {
                if ([obj.parentID isEqualToString:@""]) {
                    [self.currentDataArr addObject:obj];
                }
            }];
        }
        
    }else {
        //设置currentDataArr
        NSString *uniqueID = self.parentOrganization.uniqueID;
        
        [self.allDataDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, HYJOrgTreeModel *obj, BOOL * _Nonnull stop) {
            if ([uniqueID isEqualToString:obj.parentID]) {
                [self.currentDataArr addObject:obj];
            }
        }];
    }
    
}

#pragma mark - click event~

- (void)confirmBtnClicked:(UIButton *)sender {
    //跳转到页面~
    NSLog(@"%s",__FUNCTION__);
}


#pragma mark - tableview delegate & datasource~
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HYJOrgTreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[HYJOrgTreeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    HYJOrgTreeModel *model = self.currentDataArr[indexPath.row];
    [cell configureCell:cell withController:self Model:model atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //
    [tableView cellForRowAtIndexPath:indexPath];
    NSUInteger index = indexPath.row;
    [self gotoNextAtIndex:index];
}



//跳转到下一级~
- (void)gotoNext:(UIButton *)sender {
    
    NSInteger index = sender.tag-kDefaultSFJumpButtonTag;
    [self gotoNextAtIndex:index];
    
}

- (void)gotoNextAtIndex:(NSUInteger)index {
    
    HYJOrgTreeModel *model = self.currentDataArr[index];
    //若无下级节点，则不进行跳转：
    if ([model.hasSubOrg isEqualToString:@"0"]) {
        return;
    }
    
    HYJOrgTreeViewController *vc = [HYJOrgTreeViewController new];
    vc.isFromOthers = NO;
    vc.parentOrganization = model;
    vc.allDataDic = self.allDataDic;
    vc.selectedDataArr = self.selectedDataArr;
    vc.recentDataArr = self.recentDataArr;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectOrganization:(UIButton *)sender {
    NSInteger index = sender.tag - kDefaultSFSelectButtonTag;
    HYJOrgTreeModel *model = self.currentDataArr[index];
    //根据节点状态修改~
    switch (model.state) {
        case OrganizationNodeStateNone:
        case OrganizationNodeStatePartial:
        {
            //更新组织结构树~
            [self updateOrganizationTree:model withAction:OrganizationNodeActionSelect isNeedUpdateRecentData:YES];
            //更新button
            [sender setImage:[UIImage imageNamed:@"SF_button_select"] forState:UIControlStateNormal];
            
            break;
        }
        case OrganizationNodeStateAll:
        {
            //更新组织结构树~
            [self updateOrganizationTree:model withAction:OrganizationNodeActionCancel isNeedUpdateRecentData:YES];
            //更新button
            [sender setImage:[UIImage imageNamed:@"SF_button_unselect"] forState:UIControlStateNormal];
            
            break;
        }
        default:
            break;
    }
    //刷新底部view
    [self refreshBottomView];
}


#pragma mark - private methods

// 刷新底部view数据~
- (void)refreshBottomView {
    //other logics~
    
    //底部viw布局相关~
    [self bottomViewLayout];
}

//底部view布局相关~
- (void)bottomViewLayout {
    
    //先清除原先的底部subview~
    NSArray *buttonViews = self.selectedView.subviews;
    if (buttonViews.count>0) {
        for (UIView *subView in buttonViews) {
            if (subView.tag>=kDefaultSFNameButtonTag) {
                [subView removeFromSuperview];
            }
        }
    }
    //通用底部view布局~
    if (self.recentDataArr.count>0) {
        [self.buttonLayoutArr removeAllObjects];
        [self.recentDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self createButtonWithObj:obj atIndex:idx];
        }];
        
        //计算最后一个button即可~
        ButtonLayout *buttonLayout = self.buttonLayoutArr.lastObject;
        float contentWidth = buttonLayout.positionX+buttonLayout.width+kDefaultNameLabelMargin;
        self.selectedView.contentSize = CGSizeMake(contentWidth, self.selectedView.frame.size.height);
        
        if (self.selectedView.contentSize.width>self.selectedView.frame.size.width) {
            self.selectedView.contentOffset = CGPointMake(contentWidth-self.selectedView.frame.size.width, 0);
        }
        [self.bottomView setNeedsDisplay];
    }
}

- (UIButton *)createButtonWithObj:(id)obj atIndex:(NSUInteger)index {
    
    UIButton *button = [[UIButton alloc] init];
    [self.selectedView addSubview:button];
    button.tag = kDefaultSFNameButtonTag +index;
    
    //title & button color~
    NSString *info = @"";
    UIColor *backgroundColor = [UIColor whiteColor];
    if ([obj isKindOfClass:[HYJOrgTreeModel class]]) {
        HYJOrgTreeModel *model = (HYJOrgTreeModel *)obj;
        info = model.name;
        backgroundColor = [HYJHelper colorWithHexString:@"#e3edfc"];
    }
    //计算x
    ButtonLayout *buttonLayout = [ButtonLayout new];
    if (index==0) {
        buttonLayout.positionX = kDefaultNameLabelMargin;
        float buttonWidth = [HYJOrgTreeTableViewCell getWidthWithText:info andFont:14.0f]+24;
        buttonLayout.width = buttonWidth;
        [self.buttonLayoutArr addObject:buttonLayout];
        
    }else {
        ButtonLayout *previous = self.buttonLayoutArr[index-1];
        buttonLayout.positionX = previous.positionX+previous.width+kDefaultNameLabelMargin;
        float buttonWidth = [HYJOrgTreeTableViewCell getWidthWithText:info andFont:14.0f]+24;
        buttonLayout.width = buttonWidth;
        [self.buttonLayoutArr addObject:buttonLayout];
        
    }
    
    button.frame = CGRectMake(buttonLayout.positionX, 12, buttonLayout.width, 26);
    
    button.backgroundColor = backgroundColor;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 15.0f;
    
    [button setTitle:info forState:UIControlStateNormal];
    [button setTitleColor:[HYJHelper colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button addTarget:self action:@selector(nameButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

//点击底部已选元素~
- (void)nameButtonClicked:(UIButton *)sender {
    
    NSUInteger index = sender.tag - kDefaultSFNameButtonTag;
    id obj = self.recentDataArr[index];
    //处理点击删除节点的操作：~
    if ([obj isKindOfClass:[HYJOrgTreeModel class]]) {
        //
        HYJOrgTreeModel *model = (HYJOrgTreeModel *)obj;
        [self updateOrganizationTree:model withAction:OrganizationNodeActionCancel isNeedUpdateRecentData:YES];
        //刷新view
        [self.tableView reloadData];
        [self bottomViewLayout];
        
    }else {
        //
        [self.recentDataArr removeObjectAtIndex:index];
        [self bottomViewLayout];
    }
}



/// 根据操作更新 allDataDic & selectedDataArr
- (void)updateOrganizationTree:(HYJOrgTreeModel *)model withAction:(OrganizationNodeAction) action isNeedUpdateRecentData:(BOOL)isNeeded{
    
    switch (action) {
        case OrganizationNodeActionCancel: //取消选中~
        {
            //对下级节点
            NSString *childPrefix = [model.hierarchy stringByAppendingString:@"-"];
            [self.allDataDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, HYJOrgTreeModel *obj, BOOL * _Nonnull stop) {
                if ([key hasPrefix:childPrefix]) {
                    //处理类似这种情况：“s0-s1” & "s0-s1821"
                    obj.state = OrganizationNodeStateNone;
                    [self.allDataDic setObject:obj forKey:key];
                }
            }];
            //对本节点
            model.state = OrganizationNodeStateNone;
            [self.allDataDic setObject:model forKey:model.hierarchy];
            
            // 1.selectedDataArr数据处理~
            childPrefix = [model.hierarchy stringByAppendingString:@"-"];
            [self.selectedDataArr enumerateObjectsUsingBlock:^(HYJOrgTreeModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.hierarchy isEqualToString:model.hierarchy]) { //本节点~
                    [self.selectedDataArr removeObjectAtIndex:idx];
                }else {//子级节点处理~
                    //处理类似这种情况：“s0-s1” & "s0-s1821"
                    if ([obj.hierarchy hasPrefix:childPrefix]) {
                        [self.selectedDataArr removeObjectAtIndex:idx];
                    }
                }
                
            }];
            
            //对上级节点：
            NSString *hierarchy = model.hierarchy;
            int count = (int)[hierarchy componentsSeparatedByString:@"-"].count-1;
            //考虑所有层次节点
            for (int i=count; i>0; i--) {
                //本层级层次~
                NSString *currentHierarchy = hierarchy;
                //查找上一级节点
                //父级层次~
                NSInteger location = [hierarchy rangeOfString:@"-" options:NSBackwardsSearch].location;
                hierarchy = [hierarchy substringToIndex:location];
                HYJOrgTreeModel *parentModel = self.allDataDic[hierarchy];
                BOOL isNone = YES; //子节点是否全部是未选状态~
                BOOL isAll = YES; //子节点是否全部是全选状态~
                childPrefix = [hierarchy stringByAppendingString:@"-"];
                for (NSString *key in self.allDataDic) {
                    //父级子节点
                    //对于子节点（从下而上得到的当前父节点的子节点）(已处理子节点)的处理~
                    if ([key isEqualToString:currentHierarchy]) {
                        HYJOrgTreeModel *tempModel = self.allDataDic[key];
                        if (tempModel.state == OrganizationNodeStatePartial) {
                            parentModel.state = OrganizationNodeStatePartial;
                            isNone = NO;
                        }
                    }else if ([key hasPrefix:childPrefix]) {
                        NSInteger keyCount = [key componentsSeparatedByString:@"-"].count-1;
                        if (keyCount == i) {//
                            HYJOrgTreeModel *tempModel = self.allDataDic[key];
                            //根据下一级节点的状态来确定父节点状态~
                            if (tempModel.state == OrganizationNodeStateAll || tempModel.state ==OrganizationNodeStatePartial) {
                                parentModel.state = OrganizationNodeStatePartial;
                                isNone = NO;
                            }
                            if (tempModel.state == OrganizationNodeStatePartial || tempModel.state == OrganizationNodeStateNone) {
                                isAll = NO;
                            }
                        }
                    }
                }
                if (isNone) {
                    parentModel.state = OrganizationNodeStateNone;
                }
                [self.allDataDic setObject:parentModel forKey:hierarchy];
                
                // 2.selectedDataArr数据处理(处理子节点全部是全选状态时的数据~)
                if (isAll) {
                    //将该层父节点对应的下级所有全选的子节点放入selectedDataArr
                    childPrefix = [hierarchy stringByAppendingString:@"-"];
                    for (NSString *secondKey in self.allDataDic) {
                        if ([secondKey hasPrefix:childPrefix]) {
                            HYJOrgTreeModel *secondModel = self.allDataDic[secondKey];
                            if ([secondModel.parentID isEqualToString:parentModel.uniqueID]) {
                                if (secondModel.state ==OrganizationNodeStateAll) {
                                    [self.selectedDataArr addObject:secondModel];
                                }
                            }
                        }
                    }
                }
                //selectedDataArr去除该层父节点~
                [self.selectedDataArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(HYJOrgTreeModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.uniqueID isEqualToString:parentModel.uniqueID]) {
                        [self.selectedDataArr removeObjectAtIndex:idx];
                    }
                }];
            }
            
            break;
        }
            
        case OrganizationNodeActionSelect: //选中~
        {
            //对下级节点
            NSString *childPrefix = [model.hierarchy stringByAppendingString:@"-"];
            [self.allDataDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, HYJOrgTreeModel *obj, BOOL * _Nonnull stop) {
                if ([key hasPrefix:childPrefix]) {
                    //处理类似这种情况：“s0-s1” & "s0-s1821"
                    obj.state = OrganizationNodeStateAll;
                    [self.allDataDic setObject:obj forKey:key];
                }
            }];
            //对本节点~
            model.state = OrganizationNodeStateAll;
            [self.allDataDic setObject:model forKey:model.hierarchy];
            
            // 1.selectedDataArr数据处理~
            childPrefix = [model.hierarchy stringByAppendingString:@"-"];
            [self.selectedDataArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(HYJOrgTreeModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.hierarchy isEqualToString:model.hierarchy]) { //对于本节点~
                    [self.selectedDataArr removeObjectAtIndex:idx];
                }else if ([obj.hierarchy hasPrefix:childPrefix]) {
                    [self.selectedDataArr removeObjectAtIndex:idx];
                    
                }
            }];
            [self.selectedDataArr addObject:model];
            
            //对上级节点：
            NSString *hierarchy = model.hierarchy;
            int count = (int)[hierarchy componentsSeparatedByString:@"-"].count-1;
             //考虑所有层次节点
            for (int i=count; i>0; i--) {
                //获取父级节点~
                NSInteger location = [hierarchy rangeOfString:@"-" options:NSBackwardsSearch].location;
                hierarchy = [hierarchy substringToIndex:location];
                HYJOrgTreeModel *parentModel = self.allDataDic[hierarchy];
                //
                BOOL isAll = YES; //子节点是否全部是全选状态
                //查询每层节点的子节点，根据子节点的状态来确定父节点状态
                childPrefix = [hierarchy stringByAppendingString:@"-"];
                for (NSString *key in self.allDataDic) {
                    //下一级节点判定方法：prefix && "-"的个数
                    if ([key hasPrefix:childPrefix]) {
                        NSInteger keyCount = [key componentsSeparatedByString:@"-"].count-1;
                        if (keyCount==i) {//i & keyCount
                            HYJOrgTreeModel *tempModel = self.allDataDic[key];
                            //根据下一级节点的状态来确定父节点状态~
                            if (tempModel.state == OrganizationNodeStateNone || tempModel.state==OrganizationNodeStatePartial) {
                                parentModel.state = OrganizationNodeStatePartial;
                                isAll = NO;
                                break;
                            }
                        }
                    }
                }
                //子节点是否全部是全选状态
                if (isAll) {
                    parentModel.state = OrganizationNodeStateAll;
                    // 2.selectedDataArr数据处理~
                    childPrefix = [hierarchy stringByAppendingString:@"-"];
                    [self.selectedDataArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(HYJOrgTreeModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.hierarchy hasPrefix:childPrefix]) {//处理类似这种情况：“s0-s1” & "s0-s1821"
                            [self.selectedDataArr removeObjectAtIndex:idx];
                        }
                        
                    }];
                    [self.selectedDataArr addObject:parentModel];
                }
                //更新上级节点~
                [self.allDataDic setObject:parentModel forKey:hierarchy];
            }
            break;
        }
        default:
            break;
    }
    
    //若需要更新，则更新 recentDataArr
    if (isNeeded) {
        [self updateRecentDataArr];
    }
    
}


// 更新 recentDataArr
- (void)updateRecentDataArr {
    //1. 去掉 recentDataArr中selectedDataArr已不存在的元素~
    if (self.recentDataArr.count>0) {
        if (self.selectedDataArr.count>0) {
            [self.recentDataArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[HYJOrgTreeModel class]]) {
                    HYJOrgTreeModel *model = (HYJOrgTreeModel *)obj;
                    __block BOOL isExist = NO; //recentDataArr中的元素是否在selectedDataArr存在~
                    [self.selectedDataArr enumerateObjectsUsingBlock:^(HYJOrgTreeModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([model.uniqueID isEqualToString:obj.uniqueID]) {
                            *stop = YES;
                            isExist = YES;
                            return ;
                        }
                    }];
                    if (!isExist) { //若不存在，则直接在recentDataArr删除该元素
                        [self.recentDataArr removeObjectAtIndex:idx];
                    }
                }
            }];
        }else { //若selectedDataArr没有值~
            [self.recentDataArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[HYJOrgTreeModel class]]) {
                    [self.recentDataArr removeObjectAtIndex:idx];
                }
            }];
        }
    }
    
    //2. 针对 selectedDataArr中数据 更新recentDataArr
    if (self.selectedDataArr.count>0) {
        if (self.recentDataArr.count>0) {
            [self.selectedDataArr enumerateObjectsUsingBlock:^(HYJOrgTreeModel *model, NSUInteger index, BOOL * _Nonnull stop) {
                __block BOOL isExist = NO;//selectedDataArr中的元素是否在recentDataArr存在~
                [self.recentDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[HYJOrgTreeModel class]]) {
                        HYJOrgTreeModel *temp = (HYJOrgTreeModel *)obj;
                        if ([model.uniqueID isEqualToString:temp.uniqueID]) {
                            [self.recentDataArr replaceObjectAtIndex:idx withObject:model];
                            isExist = YES; //
                            *stop = YES;
                            return ;
                        }
                    }
                }];
                if (!isExist) {//若不存在，则加入recentDataArr
                    [self.recentDataArr addObject:model];
                }
            }];
        }else { //若recentDataArr没有数据，则直接将selectedDataArr放入recentDataArr
            [self.recentDataArr addObjectsFromArray:[self.selectedDataArr mutableCopy]];
        }
    }
}


// 构建组织结构树~
- (void)createOrganizationTree {
    //
    HYJOrgManager *manager = [HYJOrgManager sharedInstance];
    self.primaryDataArr = [manager configureOrgTree];

    HYJOrgTreeModel *model = self.primaryDataArr.firstObject;
    model.hierarchy = model.uniqueID;
    [self.allDataDic setObject:model forKey:model.hierarchy];
    //递归查询子节点~
    [self recursiveSearchOrganizationWithModel:model];
    
}

- (void)recursiveSearchOrganizationWithModel:(HYJOrgTreeModel *)model {
    
    if (self.primaryDataArr.count>0) {
        for (HYJOrgTreeModel *tempModel in self.primaryDataArr) {
            if ([model.uniqueID isEqualToString:tempModel.parentID]) {
                tempModel.hierarchy = [NSString stringWithFormat:@"%@-%@",model.hierarchy,tempModel.uniqueID];
                [self.allDataDic setObject:tempModel forKey:tempModel.hierarchy];
                
                if ([tempModel.hasSubOrg isEqualToString:@"1"]) {//若存在子节点~
                    [self recursiveSearchOrganizationWithModel:tempModel];
                }
            }

        }
    }
    
}




@end
