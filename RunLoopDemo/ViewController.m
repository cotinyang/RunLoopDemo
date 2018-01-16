//
//  ViewController.m
//  RunLoopDemo
//
//  Created by cotin on 15/01/2018.
//  Copyright © 2018 cotin. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "CTYWoker.h"

@interface ViewController () {
    CTYWoker *worker;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    worker = [[CTYWoker alloc] init];
    [worker start];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pingButtonAction:(id)sender {
    [worker pingSource];
}
- (IBAction)stopButtonAction:(id)sender {
    [worker invalidateSource];
}


@end
