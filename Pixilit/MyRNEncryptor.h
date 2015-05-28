//
//  MyRNEncryptor.h
//  Pixilit
//
//  Created by SPT Pixilit on 4/7/15.
//  Copyright (c) 2015 PixilitSeniorProject. All rights reserved.
//

#ifndef Pixilit_MyRNEncryptor_h
#define Pixilit_MyRNEncryptor_h

#import "RNEncryptor.h"

@interface MyRNEncryptor : RNEncryptor

+ (NSData *)encryptData:(NSData *)data password:(NSString *)password error:(NSError **)error;
+ (NSString *)stringFromData:(NSData *)data;

@end

#endif


