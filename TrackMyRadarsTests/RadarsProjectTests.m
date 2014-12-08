#import <Kiwi/Kiwi.h>
#import "RadarsProjectParser.h"
#import "RadarsProject.h"


SPEC_BEGIN(RadarsProjectParsing)

describe(@"When creating the redbooth project for Openradar user 'maria@email.com'", ^{
    
    context(@"When posting a new project in Organization with id '1234'", ^{
        
        NSDictionary *projectarams = [RadarsProjectParser rbProjectParametersWithName:@"Open radars"
                                                                       organizationId:1234];
        
        it(@"Should generate Redbooth API parameter: 'organization_id' as a number 1234", ^{
            NSNumber *organizId = projectarams[@"organization_id"];
            NSInteger value = [organizId integerValue];
            [[organizId should] beKindOfClass:[NSNumber class]];
            [[theValue(value) should] equal:@1234];
        });
        
        it(@"Should generate Redbooth API parameter: 'name' as string 'Open radars'", ^{
            NSString *name = projectarams[@"name"];
            [[name should] beKindOfClass:[NSString class]];
            [[name should] equal:@"Open radars"];
        });
        
        it(@"Should generate Redbooth API parameters: 'publish_pages' as a string 'false'", ^{
            NSString *publish = projectarams[@"publish_pages"];
            [[publish should] beKindOfClass:[NSString class]];
            [[publish should] equal:@"false"];
        });
    });
    
    context(@"When receiving the newly created project info", ^{
        
        NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"newproject_stub" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:path];
        NSError *error = nil;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        
        NSInteger projectId = [RadarsProjectParser projectIdWithJSONInfo:jsonObject];
        it(@"Should get projectId '2222'", ^{
            
            [[theValue(projectId) should] equal:@2222];
        });
        
        it(@"Should generate API parameter: 'project_id' as a number '2222'", ^{
            NSDictionary *taskListParams = [RadarsProjectParser rbTasklistParametersWithProjectId:projectId];
            NSNumber *project = [taskListParams objectForKey:@"project_id"];
            [[project should] beKindOfClass:[NSNumber class]];
            [[theValue([project integerValue]) should] equal:@2222];
        });
        
    });
    
    context(@"When asking for the TaskList created in the new project 'Open radars'", ^{
        
        NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"newtasklist_stub" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:path];
        NSError *error = nil;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        
        RadarsProject *project = [RadarsProjectParser projectWithOpUser:@"maria@email.com"
                                                            projectName:@"Open radars"
                                                     rbTasklistJSONInfo:[jsonArray firstObject]];
        
        it(@"Should have projectId '2222'", ^{
            
            [[theValue(project.radarsProjectId) should] equal:@2222];
        });
        
        it(@"Should have taskId '3333'", ^{
            
            [[theValue(project.radarsTaskListId) should] equal:@3333];
        });
        
        it(@"Should have Openradar email 'maria@email.com'", ^{
            
            [[project.opEmail should] equal:@"maria@email.com"];
        });
        
        it(@"Should have project name 'Open radars'", ^{
            
            [[project.radarsProjectName should] equal:@"Open radars"];
        });
    });
    
});

SPEC_END