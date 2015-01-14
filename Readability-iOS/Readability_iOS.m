//
//  Flesch–Kincaid-iOS.m
//  Flesch–Kincaid-iOS Example
//
//  Created by Bracken Spencer <bracken.spencer@gmail.com>.
//  Copyright (c) 2014-2015 Bracken Spencer. All rights reserved.
//

#import "Readability_iOS.h"
#import <UIKit/UIKit.h>
#import "SyllableCounter.h"

@implementation Readability_iOS

+ (NSDecimalNumber *)automatedReadabilityIndexForString:(NSString *)string {
    Readability_iOS *readability = [[Readability_iOS alloc] init];
    
    CGFloat totalWords = [readability wordsInString:string];
    CGFloat totalSentences = [readability sentencesInString:string];
    CGFloat totalAlphanumericCharacters = [readability countAlphanumericCharactersInString:string];
    
    // Formula from http://en.wikipedia.org/wiki/Automated_Readability_Index
    CGFloat score = 4.71f * (totalAlphanumericCharacters / totalWords) + 0.5f * (totalWords / totalSentences) - 21.43f;

    return [readability roundFloat:score places:1];
}

+ (NSDecimalNumber *)fleschKincaidGradeLevelForString:(NSString *)string {
    Readability_iOS *readability = [[Readability_iOS alloc] init];
    
    CGFloat totalWords = [readability wordsInString:string];
    CGFloat totalSentences = [readability sentencesInString:string];
    NSString *alphaNumeric = [readability alphanumericString:string];
    CGFloat totalSyllables = [SyllableCounter syllableCountForWords:alphaNumeric];
    
    // Formula from http://en.wikipedia.org/wiki/Flesch–Kincaid_readability_tests
    CGFloat score = 0.39f * (totalWords / totalSentences) + 11.8f * (totalSyllables / totalWords) - 15.59f;
    
    return [readability roundFloat:score places:1];
}

+ (NSDecimalNumber *)fleschReadingEaseForString:(NSString *)string {
    Readability_iOS *readability = [[Readability_iOS alloc] init];
    
    CGFloat totalWords = [readability wordsInString:string];
    CGFloat totalSentences = [readability sentencesInString:string];
    CGFloat totalSyllables = [SyllableCounter syllableCountForWords:string];
    
    // Formula from http://en.wikipedia.org/wiki/Flesch–Kincaid_readability_tests
    CGFloat score = 206.835f - 1.015f * (totalWords / totalSentences) - 84.6f * (totalSyllables / totalWords);
    
    return [readability roundFloat:score places:1];
}

+ (NSDecimalNumber *)gunningFogScoreForString:(NSString *)string {
    Readability_iOS *readability = [[Readability_iOS alloc] init];
    
    CGFloat totalWords = [readability wordsInString:string];
    CGFloat totalSentences = [readability sentencesInString:string];
    CGFloat totalComplexWords = [readability countComplexWordsInString:string];
    
    // Formula for http://en.wikipedia.org/wiki/Gunning_fog_index
    CGFloat score = 0.4f * ( (totalWords / totalSentences) + 100 * (totalComplexWords /  totalWords) );
    
    return [readability roundFloat:score places:1];
}

+ (NSDecimalNumber *)smogIndexForString:(NSString *)string {
    Readability_iOS *readability = [[Readability_iOS alloc] init];
    
    CGFloat totalSentences = [readability sentencesInString:string];
    CGFloat totalPolysyllables = [readability countPolysyllablesInString:string excludeCommonSuffixes:NO];
    
    // Formula from http://en.wikipedia.org/wiki/SMOG
    CGFloat score = 1.0430f * sqrtf(totalPolysyllables * (30 / totalSentences) + 3.1291f);
    
    return [readability roundFloat:score places:1];
}

#pragma mark - Helpers

- (NSDecimalNumber *)roundFloat:(CGFloat)aFloat places:(NSInteger)places {
    NSDecimalNumber *decimalNumber = [[NSDecimalNumber alloc] initWithFloat:aFloat];
    NSDecimalNumberHandler *decimalNumberHandler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                                          scale:places
                                                                                               raiseOnExactness:NO
                                                                                                raiseOnOverflow:NO
                                                                                               raiseOnUnderflow:NO
                                                                                            raiseOnDivideByZero:NO];
    NSDecimalNumber *decimalNumberRounded = [decimalNumber decimalNumberByRoundingAccordingToBehavior:decimalNumberHandler];
    
    return decimalNumberRounded;
}

- (NSUInteger)wordsInString:(NSString *)string {
    Readability_iOS *readability = [[Readability_iOS alloc] init];
    
    return [readability count:NSStringEnumerationByWords inString:string];
}

- (NSUInteger)sentencesInString:(NSString *)string {
    Readability_iOS *readability = [[Readability_iOS alloc] init];
    
    return [readability count:NSStringEnumerationBySentences inString:string];
}

- (NSUInteger)count:(NSStringEnumerationOptions)option inString:(NSString *)string {
    __block NSUInteger count = 0;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length)
                               options:option
                            usingBlock:^(NSString *word, NSRange wordRange, NSRange enclosingRange, BOOL *stop) {
                                count++;
                            }];
    
    return count;
}

- (NSUInteger)countAlphanumericCharactersInString:(NSString *)string {
    NSCharacterSet *charactersToRemove = [NSCharacterSet alphanumericCharacterSet].invertedSet;
    
    return [[string componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""].length;
}

- (NSString *)alphanumericString:(NSString *)string {
    Readability_iOS *readability = [[Readability_iOS alloc] init];
    
    NSCharacterSet *charactersToRemove = [NSCharacterSet alphanumericCharacterSet].invertedSet;
    NSString *charactersRemoved = [[string componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@" "];

    return [readability cleanupWhiteSpace:charactersRemoved];
}

- (NSString *)cleanupWhiteSpace:(NSString *)string {
    NSString *squashed = [string stringByReplacingOccurrencesOfString:@"[ ]+"
                                                             withString:@" "
                                                                options:NSRegularExpressionSearch
                                                                  range:NSMakeRange(0, string.length)];
    
    return [squashed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isWordPolysyllable:(NSString *)word excludeCommonSuffixes:(BOOL)excludeCommonSuffixes {
    __block BOOL polysyllable = NO;
    
    if ([SyllableCounter syllableCountForWord:word] > 2) {
        
        if (excludeCommonSuffixes) {
            
            if (![word.lowercaseString hasSuffix:@"es"] &&
                ![word.lowercaseString hasSuffix:@"ed"] &&
                ![word.lowercaseString hasSuffix:@"ing"]) {
                polysyllable = YES;
            }
            
        } else {
            polysyllable = YES;
        }
        
    }
    
    return polysyllable;
}

- (NSUInteger)countPolysyllablesInString:(NSString *)string excludeCommonSuffixes:(BOOL)excludeCommonSuffixes {
    Readability_iOS *readability = [[Readability_iOS alloc] init];
    
    __block NSUInteger count = 0;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length)
                               options:NSStringEnumerationByWords
                            usingBlock:^(NSString *word, NSRange wordRange, NSRange enclosingRange, BOOL *stop) {
                                
                                if ([readability isWordPolysyllable:word excludeCommonSuffixes:excludeCommonSuffixes]) {
                                    count++;
                                }
                                
                            }];
    
    return count;
}

- (BOOL)isWordCapitalized:(NSString *)word {
    return [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[word characterAtIndex:0]];
}

- (NSUInteger)countComplexWordsInString:(NSString *)string {
    Readability_iOS *readability = [[Readability_iOS alloc] init];
    
    __block NSUInteger count = 0;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length)
                               options:NSStringEnumerationByWords
                            usingBlock:^(NSString *word, NSRange wordRange, NSRange enclosingRange, BOOL *stop) {
                                
                                // Attemping the complex word suggestions at http://en.wikipedia.org/wiki/Gunning_fog_index
                                BOOL polysyllable = [readability isWordPolysyllable:word excludeCommonSuffixes:YES];
                                BOOL properNoun = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[word characterAtIndex:0]];
                                BOOL familiarJargon = NO; // TODO
                                BOOL compound = NO; // TODO
                                
                                if (polysyllable && !properNoun && !familiarJargon && !compound) {
                                    count++;
                                }
                            }];
    
    return count;
}

@end
