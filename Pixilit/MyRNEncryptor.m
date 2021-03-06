//
//  MyRNEncryptor.m
//  Pixilit
//
//  Created by SPT Pixilit on 4/7/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MyRNEncryptor.h"

@implementation MyRNEncryptor

+ (NSData *)encryptData:(NSData *)data password:(NSString *)password error:(NSError **)error {
    
    return [self encryptData:data withSettings:kRNCryptorAES256Settings password:password error:error];
}

+ (NSString *)stringFromData:(NSData *)data {
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end