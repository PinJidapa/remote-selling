*** Settings ***
Library         RequestsLibrary
Library         ../Scripts/validate.py
Library         Collections
Library         OperatingSystem
Resource        ./GetTokenPage.robot

*** Keywords *** 
Get Case By Id
    [Documentation]       Get case by id from the api for geting the case detail
    ...                       Requires
    ...                           - accessToken to authenticated 
    ...                           - base url
    ...                           - case id which get from create case api
    ...                           - expected status after get case detail by case id


    [Arguments]    ${accessToken}    ${baseUrl}    ${caseId}    ${expectedStatus}
    ${headers} =    Create Dictionary
    ${data} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${accessToken}
    ${responseCase} =    GET    ${baseUrl}/cases/${caseId}
    ...    expected_status=${expectedStatus}
    ...    headers=${headers}
    
    ${responseBodyCase} =    Set Variable    ${responseCase.text}
    ${responseDictCase} =    Evaluate    json.loads($responseBodyCase)    json

    Return From Keyword    ${responseDictCase}
    
Validate Case Detail Response
    #validate the response body from the API with the expected value (the expected value file is located in Schema folder)
    [Arguments]    ${responseDictCase}    ${expectedResponse}
    Validate Json Schema   ${responseDictCase}    ${EXECDIR}/Schema/CaseResponse/${expectedResponse}.json