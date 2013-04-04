//
//  NUEndpoint.m
//  
//
//  Created by Jacob Van Order on 2/14/13.
//
//

#import "NUEndpoint.h"
#import "NUEndpointEnvironment.h"

#import "ApplicationInformation.h"

@interface NUEndpoint ()

-(NUEndpointEnvironment *)enviromentBasedOnDataFromArray:(NSArray *)enviromentArray;

@end

@implementation NUEndpoint

#pragma mark delegate methods

#pragma mark customization

+(BOOL)deleteUserEndpoint {
    NSString *libraryDirectory = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [libraryDirectory stringByAppendingString:@"/userEndpoint.plist"];
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

+(NUEndpoint *)userEndpointOnDisk {
    NSString *libraryDirectory = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [libraryDirectory stringByAppendingString:@"/userEndpoint.plist"];
    NUEndpoint *endpoint = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return endpoint;
}

-(void) writeToDisk {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.enviroment.coreURL.absoluteString forKey:CORE_URL];
    [defaults setObject:self.enviroment.pgtReceiveURL.absoluteString forKey:PGT_RECEIVE_URL];
    [defaults setObject:self.enviroment.pgtRetrieveURL.absoluteString forKey:PGT_RETRIEVE_URL];
    [defaults setObject:self.enviroment.casServerURL.absoluteString forKey:CAS_SERVER_URL];
}

-(UIImage *)endpointImage {
    if (_endpointImage) {
        return _endpointImage;
    }
    else {
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:self.imageURL];
        NUEndpoint __weak *weakSelf = self;
        if (imageRequest) {
            [NSURLConnection sendAsynchronousRequest:imageRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                UIImage *image = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
                weakSelf.endpointImage = (image != nil) ? image : [UIImage imageNamed:@"NoImageAvailable"];
                NSDictionary *userInfo = (weakSelf.name) ? @{@"name" : weakSelf.name} : @{};
                [[NSNotificationCenter defaultCenter] postNotificationName:ENDPOINT_IMAGE_DOWNLOADED object:weakSelf userInfo:userInfo];
            }];
        }
        return nil;
    }
}

#pragma mark prototyping

-(NUEndpointEnvironment *)enviromentBasedOnDataFromArray:(NSArray *)enviromentArray {
    
    NSString *chosenEnvironmentName = ([ApplicationInformation isTestEnvironment] == YES) ? STAGING_ENV : PRODUCTION_ENV;
    NSArray *filteredEnvironmentArray = [enviromentArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NUEndpointEnvironment *environment, NSDictionary *bindings) {
        return [environment.name isEqualToString:chosenEnvironmentName];
    }]];
    NUEndpointEnvironment *chosenEnvironment = [filteredEnvironmentArray lastObject];
    return chosenEnvironment;
}

-(NUEndpointEnvironment *)environmentBasedOnCurrentBuildFromArray:(NSArray *)environmentsArray {
    return [self enviromentBasedOnDataFromArray:environmentsArray];
}

+(NUEndpoint *)migrateUserToAutoLocation {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:HAS_MIGRATED_TO_AUTO_LOCATION];

    BOOL validURLSettings = ([defaults objectForKey:CAS_SERVER_URL] &&
                             [defaults objectForKey:CORE_URL] &&
                             [defaults objectForKey:PGT_RETRIEVE_URL] &&
                             [defaults objectForKey:PGT_RECEIVE_URL]);
    if (validURLSettings == YES) {
        NSArray *environmentsArray = @[PRODUCTION_ENV, STAGING_ENV];
        NSArray *newEnvironmentsArray = @[];
        for (NSString *environmentName in environmentsArray) {
            NUEndpointEnvironment *newEnvironment = [NUEndpointEnvironment new];
            newEnvironment.casServerURL = [NSURL URLWithString:[defaults objectForKey:CAS_SERVER_URL]];
            newEnvironment.coreURL = [NSURL URLWithString:[defaults objectForKey:CORE_URL]];
            newEnvironment.pgtReceiveURL = [NSURL URLWithString:[defaults objectForKey:PGT_RECEIVE_URL]];
            newEnvironment.pgtRetrieveURL = [NSURL URLWithString:[defaults objectForKey:PGT_RETRIEVE_URL]];
            newEnvironment.name = environmentName;
            newEnvironmentsArray = [newEnvironmentsArray arrayByAddingObject:newEnvironment];
        }
        NUEndpoint *newEndpoint = [[NUEndpoint alloc] init];
        newEndpoint.name = @"Manual Mode";
        newEndpoint.imageURL = [[NSBundle mainBundle] URLForResource:@"ManualImage" withExtension:@".png"];
        newEndpoint.environmentArray = newEnvironmentsArray;
        newEndpoint.enviroment = [newEndpoint environmentBasedOnCurrentBuildFromArray:newEndpoint.environmentArray];
        newEndpoint.isManualEndpoint = @YES;
        return newEndpoint;
    }
    else {
        return nil;
    }
}

#pragma mark stock code

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _imageURL = [aDecoder decodeObjectForKey:@"imageURL"];
        _environmentArray = [aDecoder decodeObjectForKey:@"environmentArray"];
        _enviroment = [self enviromentBasedOnDataFromArray:_environmentArray];
        _isManualEndpoint = [aDecoder decodeObjectForKey:@"isManualEndpoint"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.imageURL forKey:@"imageURL"];
    [aCoder encodeObject:self.environmentArray forKey:@"environmentArray"];
    [aCoder encodeObject:self.isManualEndpoint forKey:@"isManualEndpoint"];
}

-(instancetype)initWithDataDictionary:(NSDictionary *)dataDictionary {
    self = [super init];
    if (self) {
        _name = dataDictionary[@"name"];
        _imageURL = [NSURL URLWithString:dataDictionary[@"logo_url"]];
        _environmentArray = @[];
        for (NSDictionary *environmentDictionary in dataDictionary[@"environments"]) {
            NUEndpointEnvironment *environment = [[NUEndpointEnvironment alloc] initWithEnviromentDictionary:environmentDictionary];
            _environmentArray = [_environmentArray arrayByAddingObject:environment];
        }
        _enviroment = [self enviromentBasedOnDataFromArray:_environmentArray];
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%@ has the imageURL: %@\ncoreURL: %@\ncasServerURL: %@\npgtReceiveURL: %@\n pgtRetriveURL: %@", self.name, self.imageURL, self.enviroment.coreURL, self.enviroment.casServerURL, self.enviroment.pgtReceiveURL, self.enviroment.pgtRetrieveURL];
}



@end
