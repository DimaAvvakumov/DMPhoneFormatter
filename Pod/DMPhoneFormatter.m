//
//  DMPhoneFormatter.m
//  polyphone
//
//  Created by Avvakumov Dmitry on 26.11.15.
//  Copyright © 2015 East Media Ltd. All rights reserved.
//

#import "DMPhoneFormatter.h"

@implementation DMPhoneFormatter

- (NSString *)autoFormat:(NSString *)phoneNumber {
    NSString *originalString = [self removeGarbageChars:phoneNumber];
    
    // original length
    NSUInteger originalStringLength = [originalString length];
    
    // check length
    if (originalStringLength == 0) return phoneNumber;
    
    NSMutableString *digitNumber = [NSMutableString stringWithCapacity:originalStringLength];
    
    BOOL digitWasFound = NO;
    NSInteger startLocation = 0;
    for (NSInteger i = 0; i < originalStringLength; i++) {
        unichar c = [originalString characterAtIndex:i];
        
        if (c >= '0' && c <= '9') {
            [digitNumber appendString:[NSString stringWithCharacters:&c length:1]];
            
            if (digitWasFound == NO) {
                startLocation = i;
            }
            digitWasFound = YES;
        } else if (digitWasFound) {
            break;
        }
    }
    
    // check digitNumber length. If it 0, then nothing to analize
    NSUInteger digitNumberLength = [digitNumber length];
    if (digitNumberLength == 0) return originalString;
    
    if (digitNumberLength < 2 || digitNumberLength > 11) return originalString;
    
    // vars
    unichar firstChar = [originalString characterAtIndex:0];
    BOOL firstIsPlus = (firstChar == '+') ? YES : NO;
    unichar digit1 = [digitNumber characterAtIndex:0];
    unichar digit2 = [digitNumber characterAtIndex:1];
    
    BOOL russianFormatting = NO;
    if (firstIsPlus && digit1 == '7') {
        russianFormatting = YES;
    }
    if (NO == firstIsPlus && digit1 == '8') {
        russianFormatting = YES;
    }
    
    if (russianFormatting) {
        // insert "-"
        if (digitNumberLength > 9) {
            originalString = [originalString stringByReplacingCharactersInRange:NSMakeRange(startLocation + 9, 0) withString:@"-"];
        }
        
        if (digitNumberLength > 7) {
            originalString = [originalString stringByReplacingCharactersInRange:NSMakeRange(startLocation + 7, 0) withString:@"-"];
        }
        
        if (digitNumberLength > 4) {
            originalString = [originalString stringByReplacingCharactersInRange:NSMakeRange(startLocation + 4, 0) withString:@" "];
        }
        
        unichar digit3 = (digitNumberLength > 2) ? [digitNumber characterAtIndex:2] : ' ';
        unichar digit4 = (digitNumberLength > 3) ? [digitNumber characterAtIndex:3] : ' ';
        
        NSRange range = NSMakeRange(startLocation, MIN(4, [originalString length] - startLocation));
        NSString *formattedString = [NSString stringWithFormat:@"%c (%c%c%c)", digit1, digit2, digit3, digit4];
        originalString = [originalString stringByReplacingCharactersInRange:range withString:formattedString];

    }
    
    return originalString;
}

- (NSString *) removeGarbageChars: (NSString *)originalString {
    NSUInteger originalStringLength = [originalString length];
    
    // check length
    if (originalStringLength == 0) return originalString;
    
    NSMutableString *cleanString = [NSMutableString stringWithCapacity:originalStringLength];
    
    for (NSInteger i = 0; i < originalStringLength; i++) {
        unichar c = [originalString characterAtIndex:i];
        
        BOOL insert = NO;
        
        if (c >= '0' && c <= '9') {
            insert = YES;
        } else if (c == '+') {
            insert = YES;
        } else if (c == '*' || c == '#') {
            insert = YES;
        } else if (c == ',' || c == ';') {
            insert = YES;
        }
        
        if (insert) {
            [cleanString appendString:[NSString stringWithCharacters:&c length:1]];
        }
    }
    
    return cleanString;
}

@end
