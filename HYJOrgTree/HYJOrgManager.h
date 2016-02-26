//
//  HYJOrgManager.h
//  HYJOrgTree
//
//  Created by huyujin on 16/2/26.
//  Copyright © 2016年 huyujin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYJOrgManager : NSObject

+ (instancetype)sharedInstance;

- (NSMutableArray *)configureOrgTree;

@end
