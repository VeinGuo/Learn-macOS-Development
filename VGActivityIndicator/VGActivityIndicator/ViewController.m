//
//  ViewController.m
//  VGActivityIndicator
//
//  Created by Vein on 2018/11/6.
//  Copyright © 2018 vein. All rights reserved.
//

#import "ViewController.h"
#import "VGActivityIndicatorView.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    VGActivityIndicatorView *view = [[VGActivityIndicatorView alloc] initWithActivityIndicatorStyle:VGActivityIndicatorViewStyleWhite];
    [view startAnimating];
    [self.view addSubview:view];
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
