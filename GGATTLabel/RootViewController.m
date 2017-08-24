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
    
    GGATTLabel * ggLabel = [[GGATTLabel alloc] initWithFrame:CGRectMake(10, 100, self.view.bounds.size.width-20, 400)];
    
//    [ggLabel setText:@"GGLab\nel表情[:D][8o|][(D)]http://baidu.com A http://baidu.com \n0411-85326111 " stickerDic:[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"faceMap_ch" ofType:@"plist"]] stickerSize:CGSizeMake(15,15) pattern:@"\\[([^\\[\\]]+)\\]"];
    
    

    
    [[ggLabel setText:@"GGLab\nel表情[:D][:D][:D][:D][:D][:D][:D][8o|][(D)][(D)][(D)][(D)][(D)][(D)][(D)][(D)][(D)][(D)][(D)][(D)][(D)][(D)][(D)][(D)][(D)][(D)][(D)][(D)][(D)][(D)]http://baidu.com A http://baidu.com \n0411-85326111 "] addAttributeWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName
                                value:[UIColor redColor]
                                range:NSMakeRange(0, 1)];
        
        [mutableAttributedString addAttribute:NSUnderlineStyleAttributeName
                                        value:@(NSUnderlineStyleSingle)
                                        range:NSMakeRange(1, 3)];
 
        return mutableAttributedString;
    }] ;
    [ggLabel addAttributeWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(0, mutableAttributedString.length)];
        return mutableAttributedString;
    }];
    [ggLabel stickerDic:[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"faceMap_ch" ofType:@"plist"]] stickerSize:CGSizeMake(30,30) pattern:@"\\[([^\\[\\]]+)\\]"] ;
//    [ggLabel setFont:[UIFont systemFontOfSize:30]];

    [ggLabel urlColor:[UIColor greenColor] pattern:@"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?" tapBlock:^(NSString *selectStr, NSRange range) {
        NSLog(@"str:%@ range:%@",selectStr,NSStringFromRange(range));
        
    }];
    
    [ggLabel urlColor:[UIColor blueColor] pattern:@"\\d{4}-\\d{8}|\\d{4}-\{7,8}" tapBlock:^(NSString *selectStr, NSRange range) {
        NSLog(@"str:%@ range:%@",selectStr,NSStringFromRange(range));
        
    }];
    
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
