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
        [emoji setAllShortNames:[item objectForKey:@"short_names"]];
        [emoji setKeywords:[item objectForKey:@"keywords"]];
        NSString *addedIn = [item objectForKey:@"added_in"];
        [emoji setVersion:[NSDecimalNumber decimalNumberWithString:addedIn]];
        [emoji setEmojiCharFromUnified:emoji.unified];
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
            if([emoji.version compare:[NSNumber numberWithInt:13]] == NSOrderedAscending)
            {
                // Check for matches
                BOOL exactMatch = false;
                BOOL keywordMatch = false;
                BOOL userDefinedKeywordMatch = false;
                for (NSString *nameItem in emoji.allShortNames) {
                    {
                        if([self shortNameStringMatch:string checkIn:nameItem])
                        {
                            exactMatch = true;
                        }
                    }
                }
                for (NSString *keyword in emoji.keywords) {
                    {
                        if([keyword containsString:[string substringFromIndex:1 ]])
                        {
                            keywordMatch = true;
                        }
                    }
                }
                if(userDefinedDict[emoji.emojiChar] != nil)
                {
                   NSArray *userKeywords = [[userDefinedDict objectForKey:emoji.emojiChar] componentsSeparatedByString:@","];
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
                        [exactMatches addObject:emoji];
                    }
                    if(keywordMatch)
                    {
                        [keywordMatches addObject:emoji];
                    }
                    if(userDefinedKeywordMatch)
                    {
                        [userDefinedKeywordMatches addObject:emoji];
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
    for(Emoji *e in nonUniqueValues)
    {
        BOOL found = false;
        for(int j = 0; j < uniqueValues.count; j++)
        {
            Emoji *unique = uniqueValues[j];
            if([e compareTo:unique])
            {
                found = true;
                break;
            }
        }
        if(!found)
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
