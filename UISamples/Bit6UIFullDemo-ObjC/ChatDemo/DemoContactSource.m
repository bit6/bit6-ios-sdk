//
//  Bit6DemoContactSource.m
//  Bit6UI
//
//  Created by Carlos Thurber on 12/22/15.
//  Copyright © 2015 Bit6. All rights reserved.
//

#import "DemoContactSource.h"

@implementation DemoContactSource

- (NSDictionary<NSString*,id<BXUContact>>*)source{
    if (!_source) {
        #warning here you can set the displaynames and avatars for each user
        _source = @{
                    @"usr:alex":[[DemoContact alloc] initWithURI:@"usr:alex" name:@"Alexey Goloshubin" avatarURLString:nil],
                    @"usr:julia":[[DemoContact alloc] initWithURI:@"usr:julia" name:@"Julia Goloshubin" avatarURLString:nil],
                    @"usr:calitb":[[DemoContact alloc] initWithURI:@"usr:calitb" name:@"Carlos Thurber" avatarURLString:nil]
                    };
    }
    return _source;
}

- (id<BXUContact>)contactForURI:(NSString *)uri
{
    return self.source[uri];
}

@end

@implementation DemoContact

- (nonnull instancetype)initWithURI:(nonnull NSString*)uri name:(nonnull NSString*)name avatarURLString:(nullable NSString*)avatarURLString
{
    self = [super init];
    if (self) {
        self.uri = uri;
        self.name = name;
        self.avatarURL = [NSURL URLWithString:avatarURLString];
    }
    return self;
}

@end
