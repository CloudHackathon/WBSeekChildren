//
//  WBRegistViewController.m
//  WBSeekChildren
//
//  Created by tank on 11/12/2016.
//  Copyright © 2016 webank. All rights reserved.
//

#import "WBRegistViewController.h"

@interface WBRegistViewController ()

@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation WBRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.button.layer.cornerRadius = 50.0;
    
    
}
- (IBAction)buttonClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
