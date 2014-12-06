#import <Kiwi/Kiwi.h>
#import "RadarTaskParser.h"
#import "RadarTask.h"
#import "RadarsProject.h"

SPEC_BEGIN(OpenRadarsParsing)

describe(@"When receiving array of OpenRadar radars", ^{
    
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"openradars_stub" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    NSArray *jsonArray = [jsonObject objectForKey:@"result"];
    
    context(@"Parsing the whole array to objects", ^{
        
        NSArray *allRadars = [RadarTaskParser radarTasksWithOPArray:jsonArray];
        it(@"Should return an array of 13 radars objects", ^{
            
            [[theValue(allRadars.count) should] equal:@13];
        });
        
        it(@"Should contain the radar number '15394622' with title 'SLComposeViewController hides Twitter auth errors'", ^{
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"radarNumber = %@", @"15394622"];
            NSArray *filtered = [allRadars filteredArrayUsingPredicate:predicate];
            [[theValue(filtered.count) should] equal:@1];
            
            RadarTask *twitterError = filtered[0];
            [[twitterError.radarNumber should] equal:@"15394622"];
            [[twitterError.radarTitle should] equal:@"SLComposeViewController hides Twitter auth errors"];
            
        });
    });
    
    context(@"Importing a radar number '15394622' into a redbooth task", ^{
        
        NSArray *allRadars = [RadarTaskParser radarTasksWithOPArray:jsonArray];
        RadarTask *notImportedRadar = allRadars[4];
        
        context(@"Importing to redbooth project '1234' and tasklist '2222'", ^{
            
            RadarsProject *project = [[RadarsProject alloc] init];
            project.radarsProjectId = 1234;
            project.radarsTaskListId = 2222;
            NSDictionary *taskParams = [RadarTaskParser rbParametersWithRadarTask:notImportedRadar andRadarProject:project];
            
            it(@"Should generate Redbooth API parameter: 'project_id' as a number 1234", ^{
                NSNumber *projId = taskParams[@"project_id"];
                NSInteger value = [projId integerValue];
                [[projId should] beKindOfClass:[NSNumber class]];
                [[theValue(value) should] equal:@1234];
            });
            
            it(@"Should generate Redbooth API parameter: 'task_list_id' as number 2222", ^{
                NSNumber *tasklistId = taskParams[@"task_list_id"];
                NSInteger value = [tasklistId integerValue];
                [[tasklistId should] beKindOfClass:[NSNumber class]];
                [[theValue(value) should] equal:@2222];
            });
            
            it(@"Should generate Redbooth API parameter: 'name' as string 'SLComposeViewController hides Twitter auth errors'", ^{
                NSString *name = taskParams[@"name"];
                [[name should] beKindOfClass:[NSString class]];
                [[name should] equal:@"SLComposeViewController hides Twitter auth errors"];
            });
            
            it(@"Should generate Redbooth API parameters: 'description' as string", ^{
                NSString *desc = taskParams[@"description"];
                [[desc should] beKindOfClass:[NSString class]];
                BOOL match = [desc containsString:@"Summary:\r\nSLComposeViewController has no error structure for reporting bad twitter credentials (HTTP 401 from Twitter), and does not provide useful information to the user when it fails.\r\n\r\nI have multiple accounts in Settings > Twitter:"];
                [[theValue(match) should] beTrue];
            });
            
            it(@"Should generate Redbooth API parameters: 'is_private' as a string 'false'", ^{
                NSString *isPrivate = taskParams[@"is_private"];
                [[isPrivate should] beKindOfClass:[NSString class]];
                [[isPrivate should] equal:@"false"];
            });
        });
        
    });
    
});

SPEC_END


SPEC_BEGIN(RedboothRadarsParsing)

describe(@"When receiving array of Redbooth radar tasks", ^{
    
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"redboothradars_stub" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    context(@"Parsing the whole array to objects", ^{
        
        NSArray *allRadars = [RadarTaskParser radarTasksWithRBArray:jsonArray];
        it(@"Should return an array of 4 RadarTask objects", ^{
            
            [[theValue(allRadars.count) should] equal:@4];
        });
        
        it(@"Should contain the task with id '15865431' with title 'SLComposeViewController hides Twitter auth errors'", ^{
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskId = %@", @15865431];
            NSArray *filtered = [allRadars filteredArrayUsingPredicate:predicate];
            [[theValue(filtered.count) should] equal:@1];
            
            RadarTask *twitterError = filtered[0];
            [[theValue(twitterError.taskId) should] equal:@15865431];
            [[twitterError.radarTitle should] equal:@"SLComposeViewController hides Twitter auth errors"];
            
        });
    });
    
});

SPEC_END

