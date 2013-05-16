//
//  TranslationTest.m
//  NCSNavField
//
//  Created by Jacob Van Order on 5/14/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "TranslationTest.h"

#import "MultiSurveyTVC.h"
#import "NUOneCell.h"

#import "SurveyResponseSetRelationship.h"
#import "NUSurvey.h"
#import "ResponseSet.h"
#import "Response.h"

#import "JSONKit.h"

@interface TranslationTest ()

@property (nonatomic, strong) MultiSurveyTVC *multiSurveyTVC;
@property (nonatomic, strong) NUSectionTVC *sectionTVC;

-(void)selectSectionTVCCellAtIndex:(NSUInteger)rowIndex;
-(void)setLocale:(NSString *)localeString forSectionTVC:(NUSectionTVC *)sectionTVC;
-(Response *)getLatestResponse;

@end

@implementation TranslationTest

-(void)setUp {
    [super setUp];
    
    UISplitViewController *splitViewController = [[UISplitViewController alloc] init];
    NSString *surveyJSON = [self surveyJSON];
    NUSurvey *survey = [[NUSurvey alloc] init];
    survey.jsonString = surveyJSON;
    
    NSDictionary *surveyDictionary = [surveyJSON objectFromJSONString];
    ResponseSet *responseSet = [ResponseSet newResponseSetForSurvey:surveyDictionary withModel:self.managedObjectContext.persistentStoreCoordinator.managedObjectModel inContext:self.managedObjectContext];
    
    SurveyResponseSetRelationship *surveyResponseSetRelationship = [[SurveyResponseSetRelationship alloc] initWithSurvey:survey responseSet:responseSet];
    self.multiSurveyTVC = [[MultiSurveyTVC alloc] initWithSurveyResponseSetRelationships:@[surveyResponseSetRelationship]];
    self.sectionTVC = self.multiSurveyTVC.sectionTVC;
    
    UINavigationController *containerController = [[UINavigationController alloc] initWithRootViewController:self.sectionTVC];
    splitViewController.viewControllers = @[self.multiSurveyTVC, containerController];
    
    [splitViewController view];
    [self.multiSurveyTVC.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark tests

-(void)testTranslationsQuestionAnswerUUID {
    [self selectSectionTVCCellAtIndex:0];
    
    Response *nonTranslatedResponse = [self getLatestResponse];
    NSDate *nonTranslatedResponseCreationDate = [nonTranslatedResponse performSelector:@selector(createdAt)];
    
    [nonTranslatedResponse deleteInContext:self.managedObjectContext];
    
    [self.sectionTVC.tableView reloadData];
    
    [self setLocale:@"es" forSectionTVC:self.sectionTVC];
    
    [self selectSectionTVCCellAtIndex:0];
    
    Response *secondResponse = [self getLatestResponse];
    NSString *secondQuestionUUID = secondResponse.question;
    NSString *secondAnswerUUID = secondResponse.answer;
    NSDate *secondCreationDate = [secondResponse performSelector:@selector(createdAt)];
    
    STAssertFalse([nonTranslatedResponseCreationDate isEqualToDate:secondCreationDate], @"The two responses' date should not be equal");
    STAssertTrue([secondQuestionUUID isEqualToString:@"10c6fcca-9443-4ddf-ab98-01ee622dba20"], @"The translated question uuid was not correct.");
    STAssertTrue([secondAnswerUUID isEqualToString:@"1c66da71-bc59-4da5-b3b9-dd3439d40392"], @"The translated answer uuid was not correct.");
}

-(void)testTranslationTestDoesNotProduceFalseNegatives {
    [self selectSectionTVCCellAtIndex:0];
    Response *nonTranslatedResponse = [self getLatestResponse];
    NSDate *firstResponseCreationDate = [nonTranslatedResponse performSelector:@selector(createdAt)];
    NSString *firstResponseAnswerUUID = nonTranslatedResponse.answer;
    
    [nonTranslatedResponse deleteInContext:self.managedObjectContext];
    
    [self.sectionTVC.tableView reloadData];
    
    [self setLocale:@"fr" forSectionTVC:self.sectionTVC];
    
    [self selectSectionTVCCellAtIndex:1];
    
    Response *translatedResponse = [self getLatestResponse];
    NSDate *translatedResponseCreationDate = [translatedResponse performSelector:@selector(createdAt)];
    NSString *translatedDifferentAnswerUUID = translatedResponse.answer;
    
    STAssertFalse([firstResponseCreationDate isEqualToDate:translatedResponseCreationDate], @"The two responses' date should not be equal");
    STAssertFalse([firstResponseAnswerUUID isEqualToString:translatedDifferentAnswerUUID], @"The uuid for different answers were the same.");
}

#pragma mark helper methods

-(void)selectSectionTVCCellAtIndex:(NSUInteger)rowIndex {
    NUOneCell *cell = self.sectionTVC.tableView.visibleCells[0];
    [cell selectedinTableView:self.sectionTVC.tableView indexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0]];
}

-(void)setLocale:(NSString *)localeString forSectionTVC:(NUSectionTVC *)sectionTVC {
    NSArray *translations = [self.sectionTVC performSelector:@selector(translationsArray)];
    NSDictionary *translationDictionary = [[translations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"locale = %@", localeString]] lastObject];
    [sectionTVC performSelector:@selector(refreshSectionWithTranslation:) withObject:translationDictionary];
}

-(Response *)getLatestResponse {
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Response"];
    NSArray *responses = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    return [responses lastObject];
}

-(NSString *)surveyJSON {
    return @"{"
    "    \"sections\": ["
    "        {"
    "            \"display_order\": 1, "
    "            \"questions_and_groups\": ["
    "                {"
    "                    \"answers\": ["
    "                        {"
    "                            \"reference_identifier\": \"1\", "
    "                            \"text\": \"Yes\", "
    "                            \"uuid\": \"1c66da71-bc59-4da5-b3b9-dd3439d40392\""
    "                        }, "
    "                        {"
    "                            \"reference_identifier\": \"2\", "
    "                            \"text\": \"No\", "
    "                            \"uuid\": \"d7644801-fdd2-4fed-827c-70b0a17afff8\""
    "                        }"
    "                    ], "
    "                    \"data_export_identifier\": \"TRANSLATE_SECTION\", "
    "                    \"help_text\": \"This is help text.\", "
    "                    \"pick\": \"one\", "
    "                    \"reference_identifier\": \"RELEASE\", "
    "                    \"text\": \"Should {You/We} Translate?\", "
    "                    \"uuid\": \"10c6fcca-9443-4ddf-ab98-01ee622dba20\""
    "                }"
    "            ], "
    "            \"reference_identifier\": \"TRANSLATE_INT\", "
    "            \"title\": \"Translation section\","
    "            \"uuid\" : \"CB55340A-BB1F-4CA8-A093-E77429C2BF02\""
    "        }"
    "    ], "
    "    \"translations\": ["
    "        {"
    "            \"locale\": \"fr\","
    "            \"localizedName\": \"Français\","
    "            \"uuid\": \"016718D0-2BEC-40DE-99DF-A6ADC37530BB\","
    "            \"title\": \"Title of Section\","
    "            \"sections\": ["
    "                {"
    "                    \"display_order\": 1, "
    "                    \"questions_and_groups\": ["
    "                        {"
    "                            \"answers\": ["
    "                                {"
    "                                    \"reference_identifier\": \"1\", "
    "                                    \"text\": \"Oui\", "
    "                                    \"uuid\": \"1c66da71-bc59-4da5-b3b9-dd3439d40392\""
    "                                }, "
    "                                {"
    "                                    \"reference_identifier\": \"2\", "
    "                                    \"text\": \"No\", "
    "                                    \"uuid\": \"d7644801-fdd2-4fed-827c-70b0a17afff8\""
    "                                }"
    "                            ], "
    "                            \"data_export_identifier\": \"TRANSLATE_SECTION\", "
    "                            \"help_text\": \"Ceci est un texte d'aide.\", "
    "                            \"pick\": \"one\", "
    "                            \"reference_identifier\": \"RELEASE\", "
    "                            \"text\": \"Si {You/We} traduire?\", "
    "                            \"uuid\": \"10c6fcca-9443-4ddf-ab98-01ee622dba20\""
    "                        }"
    "                    ], "
    "                    \"reference_identifier\": \"TRANSLATE_INT\", "
    "                    \"title\": \"Section de traduction\","
    "                    \"uuid\" : \"CB55340A-BB1F-4CA8-A093-E77429C2BF02\""
    "                }"
    "            ]"
    "        },"
    "        {"
    "            \"locale\": \"es\","
    "            \"localizedName\": \"Espanol\","
    "            \"uuid\": \"966B584B-0055-4F4A-B58C-AF8306A5495C\","
    "            \"title\": \"Title of Section\","
    "            \"sections\": ["
    "                    {"
    "                        \"display_order\": 1, "
    "                        \"questions_and_groups\": ["
    "                            {"
    "                                \"answers\": ["
    "                                    {"
    "                                        \"reference_identifier\": \"1\", "
    "                                        \"text\": \"Sí\", "
    "                                        \"uuid\": \"1c66da71-bc59-4da5-b3b9-dd3439d40392\""
    "                                    }, "
    "                                    {"
    "                                        \"reference_identifier\": \"2\", "
    "                                        \"text\": \"No\", "
    "                                        \"uuid\": \"d7644801-fdd2-4fed-827c-70b0a17afff8\""
    "                                    }"
    "                                ], "
    "                                \"data_export_identifier\": \"TRANSLATE_SECTION\", "
    "                                \"help_text\": \"Este es el texto de ayuda.\", "
    "                                \"pick\": \"one\", "
    "                                \"reference_identifier\": \"RELEASE\", "
    "                                \"text\": \"Debe {You/We} traducir?\", "
    "                                \"uuid\": \"10c6fcca-9443-4ddf-ab98-01ee622dba20\""
    "                            }"
    "                        ], "
    "                        \"reference_identifier\": \"TRANSLATE_INT\", "
    "                        \"title\": \"sección de Traducción\","
    "                        \"uuid\" : \"CB55340A-BB1F-4CA8-A093-E77429C2BF02\""
    "                    }"
    "            ]"
    "        },"
    "        {"
    "            \"locale\": \"en\","
    "            \"localizedName\": \"English\","
    "            \"uuid\": \"3E7CA3BF-0718-4966-AFC9-BDB36680EE8A\""
    "        }"
    "    ],"
    "    \"title\": \"Title of Section\", "
    "    \"uuid\": \"c7bc2d06-e036-4e69-b297-8ad4cb93a126\""
    "}";
}

@end
