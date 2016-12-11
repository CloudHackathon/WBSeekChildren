//
//  WBUploadResultViewController.m
//  WBSeekChildren
//
//  Created by tank on 10/12/2016.
//  Copyright © 2016 webank. All rights reserved.
//

#import "WBUploadResultViewController.h"
#import "AFHTTPSessionManager.h"
#import "XHRadarView.h"
#import "WBResultImageViewController.h"


@interface WBUploadResultViewController ()<XHRadarViewDataSource, XHRadarViewDelegate>

@property (nonatomic, strong) XHRadarView *radarView;
@property (nonatomic, strong) NSMutableArray *pointsArray;
@property (nonatomic, strong) UIButton *resultButton;


@property (nonatomic,strong)NSArray *imageUrls;
@end


@implementation WBUploadResultViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.title = @"信息比对";
    
    XHRadarView *radarView = [[XHRadarView alloc] initWithFrame:self.view.bounds];
    radarView.frame = self.view.frame;
    radarView.dataSource = self;
    radarView.delegate = self;
    radarView.radius = 200;
    radarView.backgroundColor = [UIColor colorWithRed:0.251 green:0.329 blue:0.490 alpha:1];
    radarView.backgroundImage = [UIImage imageNamed:@"radar_background"];
    radarView.labelText = @"正在进行比对查找...";
    [self.view addSubview:radarView];
    _radarView = radarView;
    
    _resultButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
    [_resultButton setTitle:@"查看比对结果" forState:UIControlStateNormal];
    _resultButton.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height - 80);
    [_resultButton addTarget:self action:@selector(pushToResultViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x-39, self.view.center.y-39, 78, 78)];
    avatarView.layer.cornerRadius = 39;
    avatarView.layer.masksToBounds = YES;
    
    [avatarView setImage:[UIImage imageNamed:@"video_uploading_hint0.png"]];
    [_radarView addSubview:avatarView];
    [_radarView bringSubviewToFront:avatarView];
    
    
    [_radarView addSubview:_resultButton];
    _resultButton.hidden = YES;
    
    NSMutableArray *arrImages = [NSMutableArray array];
    for (int i = 0; i < 4; ++i) {
        [arrImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"video_uploading_hint%d.png", i]]];
    }
    avatarView.animationImages = arrImages;
    avatarView.animationDuration = 1.2f;
    
    [avatarView startAnimating];
    
    
    [self.radarView scan];
//    [self startUpdatingRadar];
    
    [self netWorking];
    
    

}
- (void)back{
    
    if ([self.delegate respondsToSelector:@selector(backDelegate)]) {
        [self.delegate backDelegate];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)pushToResultViewController{
 
    WBResultImageViewController *reVC = [[WBResultImageViewController alloc]init];
    reVC.imageUrls = self.imageUrls;
    [self.navigationController pushViewController:reVC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
- (void)startUpdatingRadar {
    
    //目标点位置
    NSArray *tmp = @[
                     @[@6, @90],
                     @[@-140, @108],
                     @[@-83, @98],
                     @[@-25, @142],
                     @[@60, @111],
                     @[@-111, @96],
                     @[@150, @145],
                     @[@25, @144],
                     @[@-55, @110],
                     @[@95, @109],
                     @[@170, @180],
                     @[@125, @112],
                     @[@-150, @145],
                     @[@-7, @160],
                     ];
    NSMutableArray *points = [NSMutableArray new];
    
    self.childNum = self.childNum % 14;
    
    for (int i = 0; i < self.childNum; i++) {
        
        [points addObject:tmp[i]];
    }
    
    self.pointsArray = points;
    points = nil;

    
    typeof(self) __weak weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        if (self.childNum > 0) {
            weakSelf.resultButton.hidden = NO;
            weakSelf.radarView.labelText = [NSString stringWithFormat:@"比对已完成，共找到%lu个相似结果", (unsigned long)weakSelf.pointsArray.count];
            [weakSelf.radarView show];
        }else{
            weakSelf.radarView.labelText = [NSString stringWithFormat:@"抱歉，暂时没有查找到相关结果，请持续关注我们！"];
            [weakSelf.radarView show];
        }
        
        
    });
}

#pragma mark - XHRadarViewDataSource
- (NSInteger)numberOfSectionsInRadarView:(XHRadarView *)radarView {
    return 4;
}
- (NSInteger)numberOfPointsInRadarView:(XHRadarView *)radarView {
    return [self.pointsArray count];
}
- (UIView *)radarView:(XHRadarView *)radarView viewForIndex:(NSUInteger)index {
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 25)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [imageView setImage:[UIImage imageNamed:@"point"]];
    [pointView addSubview:imageView];
    return pointView;
}
- (CGPoint)radarView:(XHRadarView *)radarView positionForIndex:(NSUInteger)index {
    NSArray *point = [self.pointsArray objectAtIndex:index];
    return CGPointMake([point[0] floatValue], [point[1] floatValue]);
}

#pragma mark - XHRadarViewDelegate

- (void)radarView:(XHRadarView *)radarView didSelectItemAtIndex:(NSUInteger)index {
    NSLog(@"didSelectItemAtIndex:%lu", (unsigned long)index);
    
}

- (void)netWorking{
    [[AFHTTPSessionManager manager] POST:@"http://123.207.234.128:8080/upload"
                              parameters:nil
               constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         
         UIImage *_originImage = self.image;
         
         NSData *_data = UIImageJPEGRepresentation(_originImage, 0.5f);
         
         NSString *_encodedImageStr = [_data base64EncodedStringWithOptions:0];
         
         //        NSLog(@"===Encoded image:\n%@", _encodedImageStr);
         
         
         NSString *isKnown = @"";
         if (self.isKnown) {
             isKnown = @"yes";
         }else{
            isKnown = @"no";
         }
         
         [formData appendPartWithFormData:[_encodedImageStr dataUsingEncoding:NSUTF8StringEncoding] name:@"image"];
         
         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"latitude"];
         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"longitude"];
         
         
         [formData appendPartWithFormData:[@"2016/12/11 3:6:53" dataUsingEncoding:NSUTF8StringEncoding] name:@"timestamp"];
         [formData appendPartWithFormData:[isKnown dataUsingEncoding:NSUTF8StringEncoding] name:@"is_known"];
         [formData appendPartWithFormData:[@"422823199204082351" dataUsingEncoding:NSUTF8StringEncoding] name:@"idNo"];
         [formData appendPartWithFormData:[@"remark" dataUsingEncoding:NSUTF8StringEncoding] name:@"name"];
         
         [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"remark"];
         
     } progress:^(NSProgress * _Nonnull uploadProgress) {
         //
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         //
         //        dispatch_async(dispatch_get_main_queue(), ^{
         //            [self resultViewButton:6];
         //        });
//         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"responseObject"
//                                                        message:[NSString stringWithFormat:@"%@",responseObject]
//                                                       delegate:nil
//                                              cancelButtonTitle:@"cancle"
//                                              otherButtonTitles:nil,nil];
//         [alert show];

         NSMutableArray *tmp = [NSMutableArray new];
         
         NSInteger code = [responseObject[@"code"] integerValue];
         
         if (code == 1) {
             NSLog(@"对比失败，后台无记录，创建一条新的记录");
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"对比失败，后台无记录，数据库中创建一条新的记录"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil,nil];
             [alert show];

         }else if (code == 2){
             
             NSLog(@"对比成功");
             
             NSString *image_url = responseObject[@"person_id"][@"image_url"];
             [tmp addObject:image_url];
             
         }else if (code == 3){
             
             NSLog(@"上传的照片不包含人脸");
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"人脸比对失败"
                                                            message:@"上传的照片不包含人脸"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil,nil];
             [alert show];
             
         }else if (code == 0){
             
             NSLog(@"注册成功！");
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册成功"
                                                            message:@"请您耐心等候，有相关失踪信息第一时间给您反馈"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil,nil];
             [alert show];
             
         }else{
             NSLog(@"服务异常");
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"服务异常"
                                                            message:@"服务器返回异常，请重试"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil,nil];
             [alert show];
             
         }
         
         self.imageUrls = [NSArray arrayWithArray:tmp];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             
             self.childNum = self.imageUrls.count;
             
             [self startUpdatingRadar];
         });
         

         
         NSLog(@"responseObject:%@",responseObject);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         //
         
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络请求错误"
                                                        message:[NSString stringWithFormat:@"%@",error]
                                                       delegate:nil
                                              cancelButtonTitle:@"cancle"
                                              otherButtonTitles:nil,nil];
         [alert show];
         
         NSLog(@"error:%@",error);
         
         self.childNum = self.imageUrls.count;
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [self startUpdatingRadar];
         });
     }];
    

}

@end
