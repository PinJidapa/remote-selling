*** Settings ***
Library         RequestsLibrary
Library         ../Scripts/validate.py
Library         Collections
Library         OperatingSystem
Resource        ./GetTokenPage.robot

*** Variables ***
${SCHEMA}    {"type": "object", "properties": {"key": {"type": "string"}}, "required": ["key"]}
${JSON_DATA}    {"key": "value"}

*** Keywords *** 
Create Case
    [Documentation]    Post create case for generate proprietors id, case id, and verification id For Patch The EKYC Data
    ...                Requires
    ...                - accessToken to authenticate
    ...                - base url
    ...                - case type is the file name which is Request body with raw JSON
    ...                - expect status after post create case

    [Arguments]    ${accessToken}    ${baseUrl}    ${caseType}    ${expectedStatus}
    ${headers} =    Create Dictionary
    Set To Dictionary    ${headers}    Content-Type    application/json
    Set To Dictionary    ${headers}    Authorization    Bearer ${accessToken}
    ${filePath} =    Get File    ${EXECDIR}/Body/${caseType}.json
    ${jsonData} =    Evaluate    json.loads('''${filePath}''')
    ${responseCases} =    POST    ${baseUrl}/cases    json=${jsonData}
    ...    expected_status=${expectedStatus}
    ...    headers=${headers}
    
    ${responseBodyCases} =    Set Variable    ${responseCases.text}
    ${responseDictCases} =    Evaluate    json.loads($responseBodyCases)    json

    Return From Keyword   ${responseDictCases}


    #validate the response body from the API with the expected value (the expected value file is located in Schema folder)
Validate Verification Response
    [Arguments]    ${responseDictCases}        ${expectedResponse}
    Validate Json Schema    ${responseDictCases}     ${EXECDIR}/Schema/${expectedResponse}.json