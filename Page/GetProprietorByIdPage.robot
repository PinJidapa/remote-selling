*** Settings ***
Library         RequestsLibrary
Library         ../Scripts/validate.py
Library         Collections
Library         OperatingSystem
Resource        ./GetTokenPage.robot

*** Keywords *** 
Get Proprietors By ID
    [Arguments]    ${accessToken}    ${baseUrl}    ${proprietorId}    ${expectedStatus}
    ${headers} =    Create Dictionary
    ${data} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${accessToken}
    ${responseCases} =    GET    ${baseUrl}/proprietors/${proprietorId}
    ...    expected_status=${expectedStatus}
    ...    headers=${headers}