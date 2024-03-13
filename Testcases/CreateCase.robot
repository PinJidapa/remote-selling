*** Settings ***
Library           SeleniumLibrary
Library         JSONLibrary
Resource        ../Page/GetToken.robot
Resource        ../Page/CreateCase.robot
Resource        ../Resourse/Env/${env}/Credential.robot
Resource        ../Resourse/Env/${env}/Url.robot

*** Test Cases ***
Post Create Case By Email

    ${accessToken}=     Get Token
    ...    ${clientId}    
    ...    ${clientSecret}    
    ...    ${authUrl}
    Create Case
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    TwoProprietorCaseByEmail
    Validate Create Case Response
    Validate Invite Type As Email

# Validate frontIdCardConfig JSON
#     ${expected_json}=    Set Variable    "{ \"attempts\": 3, \"required\": true, \"isEditable\": true, \"threshHold\": 0.8, \"validations\": [], \"currentAttempt\": 3, \"dependenciesRequired\": false, \"compareNonEssentialFields\": false }"
#     ${actual_json}=    Set Variable    "{ \"attempts\": 3, \"required\": true, \"isEditable\": true, \"threshHold\": 0.8, \"validations\": [], \"currentAttempt\": 3, \"dependenciesRequired\": false, \"compareNonEssentialFields\": false }"
#     Should Be Equal As Strings    ${expected_json}    ${actual_json}