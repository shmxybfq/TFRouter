//
//  NSArray+Router.m
//  nongpi
//
//  Created by zhutaofeng on 2019/6/25.
//  Copyright © 2019 shengnong. All rights reserved.
//

#import "NSArray+Router.h"

@implementation NSArray (Router)


-(NSString *)toJson{
    if (self.count == 0)return nil;
    NSArray *filter = [RouterUnit filterArrayContentToString:self];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:filter
                                                       options:kNilOptions
                                                         error:&error];
    if (error) return nil;
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSMutableString *muJsonString = [NSMutableString stringWithString:jsonString];
    return muJsonString;
}

@end
