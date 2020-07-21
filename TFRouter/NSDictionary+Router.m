//
//  NSDictionary+Router.m
//  nongpi
//
//  Created by zhutaofeng on 2019/6/25.
//  Copyright © 2019 shengnong. All rights reserved.
//

#import "NSDictionary+Router.h"

@implementation NSDictionary (Router)

-(NSString *)toRouterParam{
    if (self.allKeys.count == 0)return nil;
    NSArray *allkeys = self.allKeys;
    NSMutableString *param = [NSMutableString string];
    for (int i = 0; i < allkeys.count; i++) {
        NSString *key = [allkeys objectAtIndex:i];
        NSString *value = [NSString stringWithFormat:@"%@",[self objectForKey:key]];
        [param appendFormat:@"%@=%@",key,value];
        if (i != allkeys.count - 1) {
            [param appendString:@"&"];
        }
    }
    return param;
}


-(NSString *)toJson{
    if (self.allKeys.count == 0)return nil;
    NSDictionary *filter = [RouterUnit filterDictionaryContentToString:self];
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
