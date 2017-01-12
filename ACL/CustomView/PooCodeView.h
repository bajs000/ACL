//
//  PooCodeView.h
//  ACL
//
//  Created by YunTu on 2016/11/28.
//  Copyright © 2016年 work. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PooCodeView : UIView

@property (nonatomic, retain) NSArray *changeArray;
@property (nonatomic, retain) NSMutableString *changeString;
@property (nonatomic, retain) UILabel *codeLabel;
@property (nonatomic, copy) NSString *code;
- (NSString *)changeCode;

@end
