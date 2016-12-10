//
//  ViewController.m
//  WBSeekChildren
//
//  Created by tank on 10/12/2016.
//  Copyright © 2016 webank. All rights reserved.
//

#import "ViewController.h"

#include <mach/mach_time.h>
#import "WBUploadResultViewController.h"
#import "WBRegistViewController.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UIButton *takePicBtn;
@property (weak, nonatomic) IBOutlet UIButton *choosePicBtn;
@property (nonatomic,strong) UIImagePickerController *imagePicker;

@property (nonatomic ,assign) BOOL isTakePic;
@property (nonatomic ,assign) BOOL isChoosePic;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.picImageView.image = [UIImage imageNamed:@"pic11.png"];
    
    self.isTakePic = YES;
    self.isChoosePic = YES;
    self.takePicBtn.layer.cornerRadius = 50.0;
    self.choosePicBtn.layer.cornerRadius = 50.0;
}

- (void)viewWillAppear:(BOOL)animated{
    
    
    if(self.isTakePic){
        [self.takePicBtn setTitle:@"相机" forState:UIControlStateNormal];
    }else{
        [self.takePicBtn setTitle:@"点击上传" forState:UIControlStateNormal];
        [self.choosePicBtn setTitle:@"相册" forState:UIControlStateNormal];

    }
    
    if(self.isChoosePic){
        [self.choosePicBtn setTitle:@"相册" forState:UIControlStateNormal];
        
    }else{
        [self.choosePicBtn setTitle:@"点击上传" forState:UIControlStateNormal];
        [self.takePicBtn setTitle:@"相机" forState:UIControlStateNormal];
    }
    
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePicButtonClicked:(id)sender {
    
    if (100 == [(UIButton *)sender tag]) {
        
        if (self.isTakePic) {
            
            self.imagePicker = [[UIImagePickerController alloc] init];
            self.imagePicker.delegate = self;
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
    
        }else{
            
            [self uploadPicButtonClicked];
        }

    }else{
        if (self.isChoosePic) {
            
            self.imagePicker = [[UIImagePickerController alloc] init];
            self.imagePicker.delegate = self;
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您是否需要完善其他信息"
                                                           message:@"信息越全，比对成功概率就越大"
                                                          delegate:self
                                                 cancelButtonTitle:@"需要"
                                                 otherButtonTitles:@"不要",nil];
            [alert show];
            [self uploadPicButtonClicked];

        }
    }
}


- (void)resultViewButton:(NSInteger)childNum {
    
    WBUploadResultViewController *resultVc = [[WBUploadResultViewController alloc]init];
    
    resultVc.childNum = childNum;
    
     UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:resultVc];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    
}
- (IBAction)resultViewButtonClicked:(id)sender {
    [self resultViewButton:0];
}

// 10.66.126.51:8080/upload
- (void)uploadPicButtonClicked{
    
    NSLog(@"-----上传-----");
    WBUploadResultViewController *resultVc = [[WBUploadResultViewController alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:resultVc];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    
        
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
//    NSLog(@"info:%@",info);
    
    _picImageView.image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        self.isTakePic = NO;
    }else{
        self.isChoosePic = NO;
    }
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark alert view
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        NSLog(@"路人");
        [self uploadPicButtonClicked];

    }else{
        NSLog(@"家人");
        // 通过storyboard对象初始化指定的控制器
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        WBRegistViewController *vc = (WBRegistViewController *)[storyboard instantiateViewControllerWithIdentifier:@"WBRegistViewController"];
        [self presentViewController:vc animated:YES completion:nil];
       
    }
}

@end
