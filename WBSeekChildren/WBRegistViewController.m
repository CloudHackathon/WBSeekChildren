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
@property (weak, nonatomic) IBOutlet UITextField *idNO;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *remark;

@end

@implementation WBRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.button.layer.cornerRadius = 10.0;
    
    
}
- (IBAction)buttonClicked:(id)sender {
    
    [self.view endEditing:YES];

    
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(WBRegistWithID:name:image:)]) {
            [self.delegate WBRegistWithID:_idNO.text name:_name.text image:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
