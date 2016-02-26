//
//  ViewController.m
//  HYJOrgTree
//
//  Created by huyujin on 16/2/26.
//  Copyright © 2016年 huyujin. All rights reserved.
//

#import "ViewController.h"
#import "AppContants.h"
#import "HYJOrgTreeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


- (void)initView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"HYJ";
    
    UIButton *button = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, 50);
        button.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [button setTitle:@"welcome to another world" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        button;
    });
    [self.view addSubview:button];
    
}

- (void)buttonPressed:(UIButton *)sender {
    HYJOrgTreeViewController *vc = [HYJOrgTreeViewController new];
    vc.isFromOthers = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
