//
//  ViewController.m
//  Alert
//
//  Created by Vein on 2018/11/15.
//  Copyright © 2018 Vein. All rights reserved.
//

#import "ViewController.h"

#import "UUAlertController.h"
#import "UUResetPasswordViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UUAlertController *alertController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (IBAction)showAlert:(NSButton *)sender {
    if (self.alertController.popoverIsVisible) {
        [self.alertController closePopover:nil];
    } else {
        [self.alertController presentPopoverInView:sender anchorsToPositionView:YES];
    }
}

- (UUAlertController *)alertController {
    if (!_alertController) {
        UUResetPasswordViewController *vc = [[UUResetPasswordViewController alloc] initWithNibName:@"UUResetPasswordViewController" bundle:nil];
        _alertController = [[UUAlertController alloc] initWithContentViewController:vc];
    }
    return _alertController;
}


@end
