//
//  DMPhoneFormatterTextField.m
//  DMPhoneFormatter
//
//  Created by Avvakumov Dmitry on 26.11.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import "DMPhoneFormatterTextField.h"

#import "DMPhoneFormatter.h"

@interface UITextField() <UITextFieldDelegate>

@end

@implementation DMPhoneFormatterTextField

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self == nil) return nil;
    
    [self initView];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self == nil) return nil;
    
    [self initView];
    
    return self;
}

- (void)initView {
    [self addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    
    
    
    self.delegate = self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0 && range.length == 1 && range.location == (textField.text.length - 1)) {
        NSString *text = [[DMPhoneFormatter defaultFormatter] removeGarbageChars:textField.text];
        NSString *newText = [text stringByReplacingCharactersInRange:NSMakeRange(text.length - 1, 1) withString:@""];
        
        NSInteger offset = 0;
        NSString *frmText = [[DMPhoneFormatter defaultFormatter] autoFormat:newText positionOffset:&offset];
        
        textField.text = frmText;
        
        [self moveCursorToPosition:offset];
        
        return NO;
    }
    
    return YES;
}

- (void)textChanged:(UITextField *)sender {
    NSInteger offset = 0;
    NSString *text = [[DMPhoneFormatter defaultFormatter] autoFormat:sender.text positionOffset:&offset];
    
    sender.text = text;
    
    [self moveCursorToPosition:offset];
}

- (void)moveCursorToPosition:(NSInteger)offset {
    // set cursor position
    UITextPosition *beginning = [self beginningOfDocument];
    UITextPosition *newSelectedRange = [self positionFromPosition:beginning offset:offset];
    UITextRange *textRange = [self textRangeFromPosition:newSelectedRange toPosition:newSelectedRange];
    
    [self setSelectedTextRange:textRange];
}

@end
