*** Settings ***
Library         RequestsLibrary
Library         ../Scripts/validate.py
Library         Collections
Library         OperatingSystem
Resource        ./GetToken.robot

*** Variables ***
${invite}    invite?inviteType=
${Response}    Response [204]

*** Keywords *** 
Resend Link
    [Arguments]    ${accessToken}    ${baseUrl}    ${proprietorId}    ${inviteType}    ${expectedStatus}
    ${headers} =    Create Dictionary
    ${data} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${accessToken}
    ${responseCases} =    POST    ${baseUrl}/proprietors/${proprietorId}/${invite}${inviteType}    
    ...    expected_status=${expectedStatus}
    ...    headers=${headers}
    
    # ${data}     Convert To String       ${responseCases.json()}

    # Status Should Be    ${responseCases}    204


