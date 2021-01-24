//
//  DataHelper.m
//  Surf
//
//  Created by Ali Rawashdeh on 01/01/2021.
//

#import "DataHelper.h"
#import "Preferences.h"
#import "Emoji.h"
#import <Foundation/Foundation.h>

NSMutableArray *emojiArray;

@implementation DataHelper

+ (void) init {
    emojiArray = [self JSONFromFile];
  }

+ (NSMutableArray *)JSONFromFile
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emoji-withkeywords" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    for (NSDictionary *item in jsonDict) {
        Emoji *emoji = [[Emoji alloc] init];
        [emoji setShortName:[item objectForKey:@"short_name"]];
        [emoji setUnified:[item objectForKey:@"unified"]];
        
        [emoji setAllNames:[item objectForKey:@"short_names"]];
        [emoji setAllKeywords:[item objectForKey:@"keywords"]];
        NSString *addedIn = [item objectForKey:@"added_in"];
        [emoji setDecimal:[NSDecimalNumber decimalNumberWithString:addedIn]];
        [returnArray addObject:emoji];
    }
    return returnArray;
}

+ (NSMutableArray*)getMatchingEmoji:(NSString*) string
{
    NSDictionary *userDefinedDict = [Preferences getUserDefinedKeywords];
    
    NSMutableArray *exactMatches = [NSMutableArray array];
    NSMutableArray *userDefinedKeywordMatches = [NSMutableArray array];
    NSMutableArray *keywordMatches = [NSMutableArray array];
    
    
        for (Emoji *emoji in emojiArray) {
        
            // Check version and search
            if([emoji.decimal compare:[NSNumber numberWithInt:13]] == NSOrderedAscending)
            {
                // Convert hex to emoji
                NSArray *hexcodes = [emoji.unified componentsSeparatedByString:@"-"];
                NSMutableString *emojiChar = [NSMutableString stringWithCapacity:50];
                for(int i = 0; i < [hexcodes count]; i++)
                {
                    int value = 0;
                    sscanf([hexcodes[i] cStringUsingEncoding:NSUTF8StringEncoding], "%x", &value);
                    uint32_t data = OSSwapHostToLittleInt32(value); // Convert to little-endian
                    NSString *str = [[NSString alloc] initWithBytes:&data length:4 encoding:NSUTF32LittleEndianStringEncoding];
                    [emojiChar appendString:[NSString stringWithFormat:@"%@",str]];
                }
                
                // Check for matches
                BOOL exactMatch = false;
                BOOL keywordMatch = false;
                BOOL userDefinedKeywordMatch = false;
                for (NSString *nameItem in emoji.allNames) {
                    {
                        if([self shortNameStringMatch:string checkIn:nameItem])
                        {
                            exactMatch = true;
                        }
                    }
                }
                for (NSString *keyword in emoji.allKeywords) {
                    {
                        if([keyword containsString:[string substringFromIndex:1 ]])
                        {
                            keywordMatch = true;
                        }
                    }
                }
                if(userDefinedDict[emojiChar] != nil)
                {
                   NSArray *userKeywords = [[userDefinedDict objectForKey:emojiChar] componentsSeparatedByString:@","];
                   for (NSString *userKeyword in userKeywords) {
                        {
                            if([userKeyword containsString:[string substringFromIndex:1 ]])
                            {
                                userDefinedKeywordMatch = true;
                            }
                        }
                    }
                }
                if(exactMatch || keywordMatch || userDefinedKeywordMatch)
                {
                    if(exactMatch)
                    {
                        [exactMatches addObject:[NSString stringWithFormat:@"%@ :%@:", emojiChar,emoji.shortName]];
                    }
                    if(keywordMatch)
                    {
                        [keywordMatches addObject:[NSString stringWithFormat:@"%@ :%@:", emojiChar,emoji.shortName]];
                    }
                    if(userDefinedKeywordMatch)
                    {
                        [userDefinedKeywordMatches addObject:[NSString stringWithFormat:@"%@ :%@:", emojiChar,emoji.shortName]];
                    }
                }
            }
    }
    
    NSMutableArray *mutableList = [NSMutableArray arrayWithArray:exactMatches];
    [mutableList addObjectsFromArray: userDefinedKeywordMatches];
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
