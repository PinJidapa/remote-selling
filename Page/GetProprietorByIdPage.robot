*** Settings ***
Library         RequestsLibrary
Library         ../Scripts/validate.py
Library         Collections
Library         OperatingSystem
Resource        ./GetTokenPage.robot

*** Keywords *** 
Get Proprietors By ID
    [Documentation]       Get Propietors by id from the api for geting EKYC resule
    ...                   Requires
    ...                   - accessToken to authenticated 
    ...                   - proprietorId which get from create case api

    [Arguments]    ${accessToken}    ${baseUrl}    ${proprietorId}    ${expectedStatus}    ${expectedResponse}
    ${headers} =    Create Dictionary
    ${data} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${accessToken}
    ${responseCases} =    GET    ${baseUrl}/proprietors/${proprietorId}
    ...    expected_status=${expectedStatus}
    ...    headers=${headers}

    ${responseBodyCases} =    Set Variable    ${responseCases.text}
    ${responseDictCases} =    Evaluate    json.loads($responseBodyCases)    json

    Validate Json Schema    ${responseDictCases}     ${EXECDIR}/Schema/${expectedResponse}.json