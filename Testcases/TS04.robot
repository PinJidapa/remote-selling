*** Settings ***
Library         SeleniumLibrary
Library         JSONLibrary
Resource        ../Page/GetTokenPage.robot
Resource        ../Page/CreateCasePage.robot
Resource        ../Page/ResendPage.robot
Resource        ../Page/GetCaseByIdPage.robot
Resource        ../Keywords/KycKeyword.robot
Resource        ../Page/GetProprietorByIdPage.robot
Resource        ../Page/PatchExpiredCasePage.robot
Resource        ../Page/PatchSubmitCasePage.robot
Resource        ../Resourse/Env/${env}/Credential.robot
Resource        ../Resourse/Env/${env}/Url.robot

*** Test Cases ***
TS04 Close The Case To Be Expired
    ${accessToken}=     Get Token
    ...    ${clientId}    
    ...    ${clientSecret}    
    ...    ${authUrl}
    
    ${responseDictCreateCases}=    Create Case
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    OneProprietorCaseBySms
    ...    201

    ${caseId} =    Get From Dictionary    ${responseDictCreateCases}    id
    Log To Console    ${caseId}

     Patch Expired Case
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${caseId}
    ...    204

    Sleep    5s
    # retrieve the access token from get token api, and case id from create case api 
    # which the status code should be 200
    ${responseDictCases}=    Get Case By Id
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${caseId}
    ...    200

    Validate Case Detail Response
    ...    ${responseDictCases}
    ...    CaseResponsAfterExpireCaseTS004