//
//  Flesch–Kincaid-iOS.m
//  Flesch–Kincaid-iOS Example
//
//  Created by Bracken Spencer <bracken.spencer@gmail.com>.
//  Copyright (c) 2014 Bracken Spencer. All rights reserved.
//

#import "Readability_iOS.h"
#import <UIKit/UIKit.h>
#import "SyllableCounter.h"

@implementation Readability_iOS

+ (NSDecimalNumber *)automatedReadabilityIndexForString:(NSString *)string {
    CGFloat totalWords = [Readability_iOS count:NSStringEnumerationByWords inString:string];
    CGFloat totalSentences = [Readability_iOS count:NSStringEnumerationBySentences inString:string];
    CGFloat totalAlphanumericCharacters = [Readability_iOS countAlphanumericCharactersInString:string];
    
    // Formula from http://en.wikipedia.org/wiki/Automated_Readability_Index
    CGFloat score = 4.71f * (totalAlphanumericCharacters / totalWords) + 0.5f * (totalWords / totalSentences) - 21.43f;

    return [Readability_iOS roundFloat:score places:1];
}

+ (NSDecimalNumber *)fleschKincaidGradeLevelForString:(NSString *)string {
    CGFloat totalWords = [Readability_iOS count:NSStringEnumerationByWords inString:string];
    CGFloat totalSentences = [Readability_iOS count:NSStringEnumerationBySentences inString:string];
    CGFloat totalSyllables = [SyllableCounter syllableCountForWords:string];
    
    // Formula from http://en.wikipedia.org/wiki/Flesch–Kincaid_readability_tests
    CGFloat score = 0.39f * (totalWords / totalSentences) + 11.8f * (totalSyllables / totalWords) - 15.59f;
    
    return [Readability_iOS roundFloat:score places:1];
}

+ (NSDecimalNumber *)fleschReadingEaseForString:(NSString *)string {
    CGFloat totalWords = [Readability_iOS count:NSStringEnumerationByWords inString:string];
    CGFloat totalSentences = [Readability_iOS count:NSStringEnumerationBySentences inString:string];
    CGFloat totalSyllables = [SyllableCounter syllableCountForWords:string];
    
    // Formula from http://en.wikipedia.org/wiki/Flesch–Kincaid_readability_tests
    CGFloat score = 206.835f - 1.015f * (totalWords / totalSentences) - 84.6f * (totalSyllables / totalWords);
    
    return [Readability_iOS roundFloat:score places:1];
}

+ (NSDecimalNumber *)gunningFogScoreForString:(NSString *)string {
    // TODO
    // The following text scores differently on read-able.com (the difference is probably due to what's considered a complex word):
    // The Readability Test Tool provides a quick and easy way to test the readability of your work. It is the most flexible readability software for assessing readability formulas.
    
    CGFloat totalWords = [Readability_iOS count:NSStringEnumerationByWords inString:string];
    CGFloat totalSentences = [Readability_iOS count:NSStringEnumerationBySentences inString:string];
    CGFloat totalComplexWords = [Readability_iOS countComplexWordsInString:string];
    
    // Formula for http://en.wikipedia.org/wiki/Gunning_fog_index
    CGFloat score = 0.4f * ( (totalWords / totalSentences) + 100.0f * (totalComplexWords /  totalWords) );
    
    return [Readability_iOS roundFloat:score places:1];
}

+ (NSDecimalNumber *)smogIndexForString:(NSString *)string {
    CGFloat totalPolysyllables = [Readability_iOS countPolysyllablesInString:string excludeCommonSuffixes:NO];
    CGFloat totalSentences = [Readability_iOS count:NSStringEnumerationBySentences inString:string];
    
    // Formula from http://en.wikipedia.org/wiki/SMOG
    CGFloat score = 1.0430f * sqrtf(totalPolysyllables * (30.0f / totalSentences) + 3.1291f);
    
    return [Readability_iOS roundFloat:score places:1];
}

#pragma mark - Helpers

+ (NSDecimalNumber *)roundFloat:(CGFloat)aFloat places:(NSInteger)places {
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

+ (NSUInteger)count:(NSStringEnumerationOptions)option inString:(NSString *)string {
    __block NSUInteger count = 0;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length)
                               options:option
                            usingBlock:^(NSString *word, NSRange wordRange, NSRange enclosingRange, BOOL *stop) {
                                count++;
                            }];
    
    return count;
}

+ (NSUInteger)countAlphanumericCharactersInString:(NSString *)string {
    NSCharacterSet *charactersToRemove = [NSCharacterSet alphanumericCharacterSet].invertedSet;
    
    return [[string componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""].length;
}

+ (BOOL)isWordPolysyllable:(NSString *)word excludeCommonSuffixes:(BOOL)excludeCommonSuffixes {
    BOOL polysyllable = NO;
    
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

+ (NSUInteger)countPolysyllablesInString:(NSString *)string excludeCommonSuffixes:(BOOL)excludeCommonSuffixes {
    __block NSUInteger count = 0;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length)
                               options:NSStringEnumerationByWords
                            usingBlock:^(NSString *word, NSRange wordRange, NSRange enclosingRange, BOOL *stop) {
                                
                                if ([Readability_iOS isWordPolysyllable:word excludeCommonSuffixes:excludeCommonSuffixes]) {
                                    count++;
                                }
                                
                            }];
    
    return count;
}

+ (BOOL)isWordCapitalized:(NSString *)word {
    return [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[word characterAtIndex:0]];
}

+ (NSUInteger)countComplexWordsInString:(NSString *)string {
    __block NSUInteger count = 0;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length)
                               options:NSStringEnumerationByWords
                            usingBlock:^(NSString *word, NSRange wordRange, NSRange enclosingRange, BOOL *stop) {
                                
                                // Attemping the complex word suggestions at http://en.wikipedia.org/wiki/Gunning_fog_index
                                BOOL polysyllable = [Readability_iOS isWordPolysyllable:word excludeCommonSuffixes:YES];
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
