//  SecurityHelper.m
//  PassengerPaneCocoa
//
// Based on SecurityHelper.m from PassengerPane
// http://github.com/alloy/passengerpane
//

#import "SecurityHelper.h"
#import <Security/AuthorizationTags.h>

@implementation SecurityHelper

// returns an instace of itself, creating one if needed
+ sharedInstance {
	static id sharedTask = nil;
    
	if(sharedTask==nil) 
	{
        sharedTask = [[SecurityHelper alloc] init];
    }
    
	return sharedTask;
}

// initializes the super class and sets authorizationRef to NULL 
- (id)init {
    self = [super init];
    authorizationRef = NULL;
    return self;
}

// Code from: http://svn.kismac-ng.org/kmng/trunk/Subprojects/BIGeneric/BLAuthentication.m
// More Code from: http://developer.apple.com/mac/library/samplecode/BetterAuthorizationSample/Listings/BetterAuthorizationSampleLib_c.html

-(BOOL)executeCommand:(NSString *)pathToCommand withArgs:(NSArray *)arguments {
	char* args[30]; // can only handle 30 arguments to a given command
	OSStatus err = 0;
	unsigned int i = 0;
	
	if( arguments == nil || [arguments count] < 1  ) 
	{
		err = AuthorizationExecuteWithPrivileges(authorizationRef, [pathToCommand fileSystemRepresentation], 0, NULL, NULL);
	}
	else 
	{
		while( i < [arguments count] && i < 19) 
		{
			args[i] = (char*)[[arguments objectAtIndex:i] cStringUsingEncoding:NSUTF8StringEncoding];
			i++;
		}
		args[i] = NULL;
		FILE *channel;
		channel = NULL;

		err = AuthorizationExecuteWithPrivileges(authorizationRef, [pathToCommand fileSystemRepresentation], 0, args, &channel);

		Boolean success;
        char thisLine[1024];
        do {
			if (channel == NULL)
				break;
			
			if (thisLine == NULL)
				break;
			
            success = (fgets(thisLine, sizeof(thisLine), channel) != NULL);
			
			if ( ! success )
			{
                break;
            }
			
        } while (true);
		
		if (channel != NULL) {
			int junk = fclose(channel);
			assert(junk == 0);
		}
    }
    
	
	if(err!=0) 
	{
		NSBeep();
		NSLog(@"Error %d in AuthorizationExecuteWithPrivileges",err);
		return NO;
	}
	else 
	{
		return YES;
	}
}

-(void)setAuthorizationRef:(AuthorizationRef)theAuthorizationRef {
	authorizationRef = theAuthorizationRef;
}

-(AuthorizationRef)authorizationRef {
	return authorizationRef;
}

-(void)deauthorize {
	authorizationRef = NULL;
}

-(BOOL)isAuthorized {
	if (authorizationRef == NULL) 
	{
		return NO;
	} 
	else 
	{
		return YES;
	}
}

@end