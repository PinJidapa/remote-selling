*** Settings ***
Library         RequestsLibrary
Library         ../Scripts/validate.py
Library         Collections
Library         OperatingSystem
Resource        ./GetTokenPage.robot

*** Keywords *** 
Patch Submit Case
    [Arguments]    ${accessToken}    ${baseUrl}    ${caseId}    ${expectedStatus}
    ${headers} =    Create Dictionary
    ${data} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${accessToken}
    ${responseCases} =    PATCH    ${baseUrl}/cases/${caseId}/submit
    ...    expected_status=${expectedStatus}
    ...    headers=${headers}
