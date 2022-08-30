//
//  RouterUnit.m
//  nongpi
//
//  Created by zhutaofeng on 2019/6/26.
//  Copyright © 2019 shengnong. All rights reserved.
//

#import "RouterUnit.h"

@implementation RouterUnit


+(NSDictionary *)filterDictionaryContentToString:(NSDictionary *)dic{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) return @{};
    else if (dic.allKeys.count == 0) return dic;
    
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
    NSArray *keys = dic.allKeys;
    for (NSInteger i = 0; i < keys.count; i++) {
        
        NSString *key = [keys objectAtIndex:i];
        id value = [dic objectForKey:key];
        
        if (![key isKindOfClass:[NSString class]])
            key = [NSString stringWithFormat:@"%@",key];
        
        if (![value isKindOfClass:[NSString class]]) {
            if ([value isKindOfClass:[NSDictionary class]]) {
                value = [self filterDictionaryContentToString:value];
            }else if([value isKindOfClass:[NSArray class]]){
                value = [self filterArrayContentToString:value];
            }else{
                value = [NSString stringWithFormat:@"%@",value];
            }
            [tmp setObject:value forKey:key];
        }else{
            [tmp setObject:value forKey:key];
        }
    }
    return tmp;
}

+(NSArray *)filterArrayContentToString:(NSArray *)array{
    if (!array || array.count == 0) return array;
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < array.count; i++) {
        id value = [array objectAtIndex:i];
        if ([value isKindOfClass:[NSString class]]) {
            [tmp addObject:value];
        }else if([value isKindOfClass:[NSArray class]]){
            [tmp addObject:[self filterArrayContentToString:value]];
        }else if([value isKindOfClass:[NSDictionary class]]){
            [tmp addObject:[self filterDictionaryContentToString:value]];
        }else{
            [tmp addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    return tmp;
}



@end
