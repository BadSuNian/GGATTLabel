//
//  RootViewController.m
//  GGATTLabel
//
//  Created by 高鹏 on 2017/8/16.
//  Copyright © 2017年 高鹏. All rights reserved.
//

#import "RootViewController.h"
#import "GGATTLabel.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    GGATTLabel * ggLabel = [[GGATTLabel alloc] initWithFrame:CGRectMake(10, 100, self.view.bounds.size.width-20, 200)];
    ggLabel.font = [UIFont systemFontOfSize:15];
    [[[[ggLabel setText:@"GGLabel表情[:D][8o|]http://baidu.com"] addAttributeWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName
                                value:[UIColor redColor]
                                range:NSMakeRange(0, 1)];
        return mutableAttributedString;
    }] stickerDic:[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"faceMap_ch" ofType:@"plist"]] stickerSize:CGSizeMake(15,15) pattern:@"\\[([^\\[\\]]+)\\]"] urlColor:[UIColor greenColor]];
    
    
    ggLabel.numberOfLines = 0;
    [self.view addSubview:ggLabel];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
