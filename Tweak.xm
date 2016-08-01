%hook UIViewController

- (void)presentViewController:(UIAlertController *)arg1
                     animated:(BOOL)arg2
					 completion:(void (^)(void))arg3
{
	BOOL canShow = YES;

	NSArray* array = [[arg1 title] componentsSeparatedByString:@" "];
	for(NSString* string in array)
	{
		if([[string lowercaseString] isEqualToString:@"rate"])
			canShow = NO;
	}
	array = [[arg1 message] componentsSeparatedByString:@" "];
	for(NSString* string in array)
	{
		if([[string lowercaseString] isEqualToString:@"rate"])
			canShow = NO;
	}
	if(canShow){
		%orig;
	}
	else{
		// continue with the Controller's Default choice?
	}

}
%end

%ctor
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	if([NSHomeDirectory() hasPrefix:@"/var/mobile/Containers/Data/Application/"])	// only hook App Store applications
	{
		%init;
	}
	[pool drain];
}
