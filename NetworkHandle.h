//
//  NetworkHandle.h
//  HDTicket
//
//  Created by 周志荣 on 16/12/14.
//  Copyright © 2016年 周志荣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef NS_ENUM(NSInteger,HDHttpMethod) {
    Get = 0,
    Post
};
typedef void (^HDSuccessBlock)(NSURLSessionDataTask *task, NSDictionary* dic);
typedef void (^HDFailureBlock)(NSURLSessionTask *task, NSError *error);

@interface NetworkHandle : NSObject


-(instancetype)initWithConfiguration:(NSURLSessionConfiguration *)config;


-(void)activateWithURL:(NSURL *)url
               headers:(NSMutableDictionary *)headers
                params:(NSDictionary *)params
                method:(HDHttpMethod)method
               success:(HDSuccessBlock)success
              failure:(HDFailureBlock)failure;

@end
