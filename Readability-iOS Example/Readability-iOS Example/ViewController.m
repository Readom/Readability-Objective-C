//
//  ViewController.m
//  Readability-iOS Example
//
//  Created by Bracken Spencer <bracken.spencer@gmail.com>.
//  Copyright (c) 2014 Bracken Spencer. All rights reserved.
//

#import "ViewController.h"
#import "Readability_iOS.h"

@interface ViewController () <UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UILabel *fleschReadingEaseLabel;
@property (nonatomic, weak) IBOutlet UILabel *fleschKincaidGradeLevelLabel;
@property (nonatomic, weak) IBOutlet UILabel *gunningFogScoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *smogIndexLabel;
@property (nonatomic, weak) IBOutlet UILabel *automatedReadabilityIndexLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self textViewDidChange:self.textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length) {
        NSDecimalNumber *automatedReadabilityIndex = [Readability_iOS automatedReadabilityIndexForString:self.textView.text];
        NSDecimalNumber *fleschKincaidGradeLevel = [Readability_iOS fleschKincaidGradeLevelForString:self.textView.text];
        NSDecimalNumber *fleschReadingEase = [Readability_iOS fleschReadingEaseForString:self.textView.text];
        NSDecimalNumber *gunningFogScore = [Readability_iOS gunningFogScoreForString:self.textView.text];
        NSDecimalNumber *smogIndex = [Readability_iOS smogIndexForString:self.textView.text];
        
        [self.automatedReadabilityIndexLabel setText:[NSString stringWithFormat:@"%@", automatedReadabilityIndex]];
        [self.fleschKincaidGradeLevelLabel setText:[NSString stringWithFormat:@"%@", fleschKincaidGradeLevel]];
        [self.fleschReadingEaseLabel setText:[NSString stringWithFormat:@"%@", fleschReadingEase]];
        [self.gunningFogScoreLabel setText:[NSString stringWithFormat:@"%@", gunningFogScore]];
        [self.smogIndexLabel setText:[NSString stringWithFormat:@"%@", smogIndex]];
    } else {
        [self.automatedReadabilityIndexLabel setText:@"N/A"];
        [self.fleschKincaidGradeLevelLabel setText:@"N/A"];
        [self.fleschReadingEaseLabel setText:@"N/A"];
        [self.gunningFogScoreLabel setText:@"N/A"];
        [self.smogIndexLabel setText:@"N/A"];
    }
}

@end

