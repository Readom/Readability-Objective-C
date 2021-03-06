//
//  Readability_Objective_C_ExampleTests.m
//  Readability-Objective-C Example
//
//  Created by Bracken Spencer <bracken.spencer@gmail.com>.
//  Copyright (c) 2014-2015 Bracken Spencer. All rights reserved.
//

@import UIKit;
@import XCTest;

#import "Readability.h"
#import "SyllableCounter.h"

@interface Readability (Test)

- (NSDecimalNumber *)roundFloat:(CGFloat)aFloat places:(NSInteger)places;
- (NSUInteger)wordsInString:(NSString *)string;
- (NSUInteger)sentencesInString:(NSString *)string;
- (NSUInteger)alphanumericCharactersInString:(NSString *)string;
- (NSString *)alphanumericString:(NSString *)string;
- (NSString *)cleanupWhiteSpace:(NSString *)string;
- (BOOL)isWordPolysyllable:(NSString *)word excludeCommonSuffixes:(BOOL)excludeCommonSuffixes;
- (NSUInteger)polysyllableWordsInString:(NSString *)string excludeCommonSuffixes:(BOOL)excludeCommonSuffixes;
- (BOOL)isWordCapitalized:(NSString *)word;
- (NSUInteger)complexWordsInString:(NSString *)string;

@end

@interface Readability_Objective_C_ExampleTests : XCTestCase

@property (nonatomic, strong) NSString *testString1;
@property (nonatomic, strong) NSString *testString2;
@property (nonatomic, strong) Readability *readability;

@end

@implementation Readability_Objective_C_ExampleTests

- (void)setUp {
    [super setUp];

    //                              read-able.com   readability-score.com   Readability-iOS-Objective-C 14.9
    // Automated Readability Index: 9.7             9.7                     9.7
    //          Coleman–Liau Index: 15.0            15.0                    14.9
    //         Flesch Reading Ease: 24.4            30.9                    24.4
    //  Flesch–Kincaid Grade Level: 13.1            12.2                    13.1
    //           Gunning Fog Score: 14.4            11.4                    14.4
    //                  SMOG Grade: 11.6            10.1                    11.6
    self.testString1 = @"The Australian platypus is seemingly a hybrid of a mammal and reptilian creature.";
    
    //                              read-able.com   readability-score.com   Readability-iOS-Objective-C
    // Automated Readability Index: 12.1            12.1                    12.1
    //          Coleman–Liau Index: 9.2             9.2                     9.1
    //         Flesch Reading Ease: 65.4            65.4                    64.8
    //  Flesch–Kincaid Grade Level: 10.9            10.9                    11.0
    //           Gunning Fog Score: 13.8            13.8                    12.6
    //                  SMOG Grade: 8.3             8.3                     8.3
    self.testString2 = @"Four score and seven years ago our fathers brought forth on this continent a new nation, conceived in liberty, and dedicated to the proposition that all men are created equal. Now we are engaged in a great civil war, testing whether that nation, or any nation so conceived and so dedicated, can long endure. We are met on a great battlefield of that war. We have come to dedicate a portion of that field, as a final resting place for those who here gave their lives that that nation might live. It is altogether fitting and proper that we should do this. But, in a larger sense, we can not dedicate, we can not consecrate, we can not hallow this ground. The brave men, living and dead, who struggled here, have consecrated it, far above our poor power to add or detract. The world will little note, nor long remember what we say here, but it can never forget what they did here. It is for us the living, rather, to be dedicated here to the unfinished work which they who fought here have thus far so nobly advanced. It is rather for us to be here dedicated to the great task remaining before us -- that from these honored dead we take increased devotion to that cause for which they gave the last full measure of devotion -- that we here highly resolve that these dead shall not have died in vain -- that this nation, under God, shall have a new birth of freedom -- and that government of the people, by the people, for the people, shall not perish from the earth.";
    
    self.readability = [[Readability alloc] init];
}

#pragma mark - Readability_iOS

- (void)testReadabilityString1 {
    XCTAssert([Readability automatedReadabilityIndexForString:self.testString1].doubleValue == 9.7);
    XCTAssert([Readability colemanLiauIndexForString:self.testString1].doubleValue == 14.9);
    XCTAssert([Readability fleschKincaidGradeLevelForString:self.testString1].doubleValue == 13.1);
    XCTAssert([Readability fleschReadingEaseForString:self.testString1].doubleValue == 24.4);
    XCTAssert([Readability gunningFogScoreForString:self.testString1].doubleValue == 14.4);
    XCTAssert([Readability smogGradeForString:self.testString1].doubleValue == 11.6);
}

- (void)testReadabilityString2 {
    XCTAssert([Readability automatedReadabilityIndexForString:self.testString2].doubleValue == 12.1);
    XCTAssert([Readability colemanLiauIndexForString:self.testString2].doubleValue == 9.1);
    XCTAssert([Readability fleschKincaidGradeLevelForString:self.testString2].doubleValue == 11.0);
    XCTAssert([Readability fleschReadingEaseForString:self.testString2].doubleValue == 64.8);
    XCTAssert([Readability gunningFogScoreForString:self.testString2].doubleValue == 12.6);
    XCTAssert([Readability smogGradeForString:self.testString2].doubleValue == 8.3);
}

- (void)testRoundFloat {
    XCTAssert([self.readability roundFloat:9.7069229712853051f places:1].doubleValue == 9.7);
    XCTAssert([self.readability roundFloat:13.079999923706055f places:1].doubleValue == 13.1);
    XCTAssert([self.readability roundFloat:24.440014648437511f places:1].doubleValue == 24.4);
    XCTAssert([self.readability roundFloat:14.430769445804451f places:1].doubleValue == 14.4);
    XCTAssert([self.readability roundFloat:11.573498725891113f places:1].doubleValue == 11.6);
}

- (void)testWordsInString {
    XCTAssertEqual([self.readability wordsInString:self.testString1], 13);
    XCTAssertEqual([self.readability wordsInString:self.testString2], 271);
}

- (void)testSentencesInString {
    XCTAssertEqual([self.readability sentencesInString:self.testString1], 1);
    XCTAssertEqual([self.readability sentencesInString:self.testString2], 10);
}

- (void)testCountAlphanumericCharactersInString {
    XCTAssertEqual([self.readability alphanumericCharactersInString:self.testString1], 68);
    XCTAssertEqual([self.readability alphanumericCharactersInString:self.testString2], 1149);
}

- (void)testAlphanumericString {
    XCTAssertEqual([self.readability alphanumericString:self.testString1].length, @"The Australian platypus is seemingly a hybrid of a mammal and reptilian creature".length);
    XCTAssertEqual([self.readability alphanumericString:self.testString2].length, @"Four score and seven years ago our fathers brought forth on this continent a new nation conceived in liberty and dedicated to the proposition that all men are created equal Now we are engaged in a great civil war testing whether that nation or any nation so conceived and so dedicated can long endure We are met on a great battlefield of that war We have come to dedicate a portion of that field as a final resting place for those who here gave their lives that that nation might live It is altogether fitting and proper that we should do this But in a larger sense we can not dedicate we can not consecrate we can not hallow this ground The brave men living and dead who struggled here have consecrated it far above our poor power to add or detract The world will little note nor long remember what we say here but it can never forget what they did here It is for us the living rather to be dedicated here to the unfinished work which they who fought here have thus far so nobly advanced It is rather for us to be here dedicated to the great task remaining before us that from these honored dead we take increased devotion to that cause for which they gave the last full measure of devotion that we here highly resolve that these dead shall not have died in vain that this nation under God shall have a new birth of freedom and that government of the people by the people for the people shall not perish from the earth".length);
}

- (void)testCleanupWhiteSpace {
    XCTAssertEqual([self.readability cleanupWhiteSpace:@"   Test      test        test test          "].length, @"Test test test test".length);
}

- (void)testIsWordPolysyllable {
    XCTAssert([self.readability isWordPolysyllable:@"crowdsourcing" excludeCommonSuffixes:NO] == YES);
    XCTAssert([self.readability isWordPolysyllable:@"crowdsourcing" excludeCommonSuffixes:YES] == NO);
}

- (void)testCountPolysyllablesInString {
    XCTAssertEqual([self.readability polysyllableWordsInString:self.testString1 excludeCommonSuffixes:NO], 4);
    XCTAssertEqual([self.readability polysyllableWordsInString:self.testString1 excludeCommonSuffixes:YES], 4);
    
    XCTAssertEqual([self.readability polysyllableWordsInString:self.testString2 excludeCommonSuffixes:NO], 20);
    XCTAssertEqual([self.readability polysyllableWordsInString:self.testString2 excludeCommonSuffixes:YES], 12);
}

- (void)testIsWordCapitalized {
    XCTAssert([self.readability isWordCapitalized:@"Test"] == YES);
    XCTAssert([self.readability isWordCapitalized:@"Test "] == YES);
    XCTAssert([self.readability isWordCapitalized:@"TEST"] == YES);
    XCTAssert([self.readability isWordCapitalized:@"A "] == YES);
    XCTAssert([self.readability isWordCapitalized:@"test"] == NO);
    XCTAssert([self.readability isWordCapitalized:@"tEst"] == NO);
    XCTAssert([self.readability isWordCapitalized:@" Test"] == NO);
}

- (void)testCountComplexWordsInString {
    XCTAssertEqual([self.readability complexWordsInString:self.testString1], 3);
    XCTAssertEqual([self.readability complexWordsInString:self.testString2], 12);
}

#pragma mark - SyllableCounter

- (void)testSyllableCountForWord {
    XCTAssertEqual([SyllableCounter syllableCountForWord:@"The"], 1);
    XCTAssertEqual([SyllableCounter syllableCountForWord:@"Australian"], 4);
    XCTAssertEqual([SyllableCounter syllableCountForWord:@"platypus"], 3);
    XCTAssertEqual([SyllableCounter syllableCountForWord:@"is"], 1);
    XCTAssertEqual([SyllableCounter syllableCountForWord:@"seemingly"], 3);
    XCTAssertEqual([SyllableCounter syllableCountForWord:@"a"], 1);
    XCTAssertEqual([SyllableCounter syllableCountForWord:@"hybrid"], 2);
    XCTAssertEqual([SyllableCounter syllableCountForWord:@"of"], 1);
    XCTAssertEqual([SyllableCounter syllableCountForWord:@"mammal"], 2);
    XCTAssertEqual([SyllableCounter syllableCountForWord:@"and"], 1);
    XCTAssertEqual([SyllableCounter syllableCountForWord:@"reptilian"], 4);
    XCTAssertEqual([SyllableCounter syllableCountForWord:@"creature."], 2);
}

- (void)testSyllableCountForWords {
    NSString *cleaned1 = [self.readability alphanumericString:self.testString1];
    NSString *cleaned2 = [self.readability alphanumericString:self.testString2];
                   
    XCTAssertEqual([SyllableCounter syllableCountForWords:cleaned1], 26);
    XCTAssertEqual([SyllableCounter syllableCountForWords:cleaned2], 367);
}

@end
