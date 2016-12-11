//
//  WBUploadResultViewController.h
//  WBSeekChildren
//
//  Created by tank on 10/12/2016.
//  Copyright © 2016 webank. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WBUploadResultDelegate <NSObject>

- (void)backDelegate;

@end

@interface WBUploadResultViewController : UIViewController

@property (nonatomic ,assign)NSInteger childNum;
@property (nonatomic ,strong)UIImage *image;
@property (nonatomic ,strong)NSString *name;

@property (nonatomic ,assign)BOOL isKnown;
@property (nonatomic ,weak)id<WBUploadResultDelegate>delegate;

@end
