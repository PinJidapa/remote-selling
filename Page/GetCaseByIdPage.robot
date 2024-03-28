*** Settings ***
Library         RequestsLibrary
Library         ../Scripts/validate.py
Library         Collections
Library         OperatingSystem
Resource        ./GetTokenPage.robot

*** Keywords *** 
Get Case By Id
    [Documentation]       Get case by id from the api for geting the case detail
    ...                   Requires
    ...                   - accessToken to authenticated 
    ...                   - caseId which get from create case api

    [Arguments]    ${accessToken}    ${baseUrl}    ${caseId}    ${expectedStatus}        ${expectedResponse}
    ${headers} =    Create Dictionary
    ${data} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${accessToken}
    ${responseCases} =    GET    ${baseUrl}/cases/${caseId}
    ...    expected_status=${expectedStatus}
    ...    headers=${headers}
    
    ${responseBodyCases} =    Set Variable    ${responseCases.text}
    ${responseDictCases} =    Evaluate    json.loads($responseBodyCases)    json

    #validate the response body from the API with the expected value (the expected value file is located in Schema folder)
    Validate Json Schema    ${responseDictCases}    ${EXECDIR}/Schema/${expectedResponse}.json