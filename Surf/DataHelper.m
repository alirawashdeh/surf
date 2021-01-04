//
//  DataHelper.m
//  Surf
//
//  Created by Ali Rawashdeh on 01/01/2021.
//

#import "DataHelper.h"
#import <Foundation/Foundation.h>

NSDictionary* dict2;

@implementation DataHelper

+ (void) init {
    dict2 = [self JSONFromFile];
  }

+ (NSDictionary *)JSONFromFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emoji-withkeywords" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

+ (NSMutableArray*)getMatchingEmoji:(NSString*) string
{
    NSMutableArray *exactMatches = [NSMutableArray array];
    NSMutableArray *keywordMatches = [NSMutableArray array];
    
        for (NSDictionary *item in dict2) {
            NSString *name = [item objectForKey:@"short_name"];
            NSString *unified = [item objectForKey:@"unified"];
            NSArray *allNames = [item objectForKey:@"short_names"];
            NSArray *allKeywords = [item objectForKey:@"keywords"];
            NSString *addedIn = [item objectForKey:@"added_in"];
            NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:addedIn];
            if([decimal compare:[NSNumber numberWithInt:13]] == NSOrderedAscending)
            {
                BOOL exactMatch = false;
                BOOL keywordMatch = false;
                for (NSString *nameItem in allNames) {
                    {
                        if([self shortNameStringMatch:string checkIn:nameItem])
                        {
                            exactMatch = true;
                        }
                    }
                }
                for (NSString *keyword in allKeywords) {
                    {
                        if([keyword containsString:[string substringFromIndex:1 ]])
                        {
                            keywordMatch = true;
                        }
                    }
                }
                if(exactMatch || keywordMatch)
                {
                    NSArray *hexcodes = [unified componentsSeparatedByString:@"-"];
                    NSMutableString *emoji = [NSMutableString stringWithCapacity:50];
                    
                    for(int i = 0; i < [hexcodes count]; i++)
                    {
                        int value = 0;
                        sscanf([hexcodes[i] cStringUsingEncoding:NSUTF8StringEncoding], "%x", &value);
                        uint32_t data = OSSwapHostToLittleInt32(value); // Convert to little-endian
                        NSString *str = [[NSString alloc] initWithBytes:&data length:4 encoding:NSUTF32LittleEndianStringEncoding];
                        [emoji appendString:[NSString stringWithFormat:@"%@",str]];
                    }
                    if(exactMatch)
                    {
                        [exactMatches addObject:[NSString stringWithFormat:@"%@ :%@:", emoji,name]];
                    }
                    if(keywordMatch)
                    {
                        [keywordMatches addObject:[NSString stringWithFormat:@"%@ :%@:", emoji,name]];
                    }
                }
            }
    }
    
    NSMutableArray *mutableList = [NSMutableArray arrayWithArray:exactMatches];
    [mutableList addObjectsFromArray: keywordMatches];
    
    return [DataHelper deduplicateArray:mutableList];
}

+ (NSMutableArray*)deduplicateArray:(NSMutableArray*) nonUniqueValues
{
    NSMutableArray* uniqueValues = [[NSMutableArray alloc] init];
    for(id e in nonUniqueValues)
    {
        if(![uniqueValues containsObject:e])
        {
            [uniqueValues addObject:e];
        }
    }
    return uniqueValues;
}

+ (BOOL)shortNameStringMatch:(NSString*) inputString checkIn:(NSString*)comparisonString{
    NSString* substring = [inputString substringFromIndex:1 ];
    if([comparisonString containsString:substring])
    {
        return true;
    }
    if([comparisonString containsString:[substring stringByReplacingOccurrencesOfString:@" " withString:@"_"]])
    {
        return true;
    }
    if([comparisonString containsString:[substring stringByReplacingOccurrencesOfString:@"-" withString:@"_"]])
    {
        return true;
    }
    return false;
}

@end
