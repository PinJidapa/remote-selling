*** Settings ***
Library           SeleniumLibrary
Resource        ../Page/GetToken.robot
Resource        ../Page/CreateCase.robot
Resource        ../Resourse/Env/${env}/Credential.robot
Resource        ../Resourse/Env/${env}/Url.robot

*** Test Cases ***
Post Create Case
    ${accessToken}=     Get Token
    ...    ${clientId}    
    ...    ${clientSecret}    
    ...    ${authUrl}
    Create Case
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    TwoProprietorCaseByEmail
    Validate Create Case Response

