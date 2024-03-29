*** Settings ***
Library         RequestsLibrary
Library         ../Scripts/validate.py
Library         Collections
Library         OperatingSystem
Resource        ./GetTokenPage.robot

*** Keywords *** 
Patch Expired Case
    [Documentation]    Patch close case by case id to make the link expire
    ...                Requires
    ...                - accessToken
    ...                - case id from create case response

    [Arguments]    ${accessToken}    ${baseUrl}    ${caseId}    ${expectedStatus}
    ${headers} =    Create Dictionary
    ${data} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${accessToken}
    ${responseCases} =    PATCH    ${baseUrl}/cases/${caseId}/close
    ...    expected_status=${expectedStatus}
    ...    headers=${headers}
