*** Settings ***
Library         RequestsLibrary
Library         ../Scripts/validate.py
Library         Collections
Library         OperatingSystem
Resource        ./GetToken.robot

*** Variables ***
${SCHEMA}    {"type": "object", "properties": {"key": {"type": "string"}}, "required": ["key"]}
${JSON_DATA}    {"key": "value"}

*** Keywords *** 
Create Case
    [Arguments]    ${accessToken}    ${baseUrl}    ${caseType}
    ${headers} =    Create Dictionary
    Set To Dictionary    ${headers}    Content-Type    application/json
    Set To Dictionary    ${headers}    Authorization    Bearer ${accessToken}
    ${filePath} =    Get File    ${EXECDIR}/Body/${caseType}.json
    ${jsonData} =    Evaluate    json.loads('''${filePath}''')
    ${responseCases} =    POST    ${baseUrl}/cases    json=${jsonData}
    ...    headers=${headers}
    ${responseBodyCases} =    Set Variable    ${responseCases.text}
    ${responseDictCases} =    Evaluate    json.loads($responseBodyCases)    json
    Return From Keyword    ${responseDictCases}

Validate Verification Response
    [Arguments]    ${responseDictCases}
    Validate Json Schema    ${responseDictCases}     ${EXECDIR}/Schema/verificationResponseSchema.json
    

Validate Invite Type As SMS
    [Arguments]    ${responseDictCases}
    ${inviteType}=    Get From Dictionary       ${responseDictCases["proprietors"][0]}    inviteType
    Should Be Equal As Strings    ${inviteType}      sms

Validate Invite Type As Email
    [Arguments]    ${responseDictCases}
    ${inviteType}=    Get From Dictionary       ${responseDictCases["proprietors"][0]}    inviteType
    Should Be Equal As Strings    ${inviteType}      email
    

    

