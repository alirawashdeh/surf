//
//  DataHelper.h
//  Surf
//
//  Created by Ali Rawashdeh on 01/01/2021.
//

#import <Foundation/Foundation.h>

@interface DataHelper : NSObject

+ (void)init;
+ (NSMutableArray*)JSONFromFile;
+ (NSMutableArray*)getMatchingEmoji:(NSString*) string;
+ (NSMutableArray*)deduplicateArray:(NSMutableArray*) nonUniqueValues;
@end
