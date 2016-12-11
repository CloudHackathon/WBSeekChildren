//
//  WBRegistViewController.h
//  WBSeekChildren
//
//  Created by tank on 11/12/2016.
//  Copyright © 2016 webank. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WBRegistViewControllerDelegate <NSObject>

- (void)WBRegistWithID:(NSString*)IDNo name:(NSString *)name image:(NSString *)image;

@end

@interface WBRegistViewController : UIViewController

@property (nonatomic,weak)id<WBRegistViewControllerDelegate>delegate;

@end
