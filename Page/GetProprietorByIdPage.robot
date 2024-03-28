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

    [Arguments]    ${accessToken}    ${baseUrl}    ${proprietorId}    ${expectedStatus}
    ${headers} =    Create Dictionary
    ${data} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${accessToken}
    ${responseProprietor} =    GET    ${baseUrl}/proprietors/${proprietorId}
    ...    expected_status=${expectedStatus}
    ...    headers=${headers}

    ${responseBodyProprietor} =    Set Variable    ${responseProprietor.text}
    ${responseDictProprietor} =    Evaluate    json.loads($responseBodyProprietor)    json
    Return From Keyword    ${responseDictProprietor}    

Validate Proprietors Response
    [Arguments]    ${responseDictProprietor}     ${expectedResponse}
    Validate Json Schema    ${responseDictProprietor}     ${EXECDIR}/Schema/ProprietorResponse/${expectedResponse}.json