

#import "APLAppDelegate.h"

@implementation APLAppDelegate

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler
{
    BLog();
    /*
     Store the completion handler. The completion handler is invoked by the view controller's checkForAllDownloadsHavingCompleted method (if all the download tasks have been completed).
     */
	self.backgroundSessionCompletionHandler = completionHandler;
}


-(void)applicationWillResignActive:(UIApplication *)application
{
    BLog();
}


-(void)applicationDidBecomeActive:(UIApplication *)application
{
    BLog();
}


@end
