*** Settings ***
Library         RequestsLibrary
# Library         JSONSchemaLibrary
Library         JSONLibrary
Library         Collections
Resource        ./GetToken.robot
Library         OperatingSystem

*** Variables ***
${SCHEMA}    {"type": "object", "properties": {"key": {"type": "string"}}, "required": ["key"]}
${JSON_DATA}    {"key": "value"}

*** Keywords *** 
Create Case
    [Arguments]    ${accessToken}    ${baseUrl}    ${caseType}
    ${headers} =    Create Dictionary
    ${data} =    Create Dictionary
    Set To Dictionary    ${headers}    Content-Type    application/json
    Set To Dictionary    ${headers}    Authorization    Bearer ${accessToken}
    ${filePath} =    Get File    ${EXECDIR}/Body/${caseType}.json
    ${jsonData} =    Evaluate    json.loads('''${filePath}''')
    ${responseCases} =    POST    ${baseUrl}/cases    json=${jsonData}
    ...    headers=${headers}
    ${responseBodyCases} =    Set Variable    ${responseCases.text}
    ${responseDictCases} =    Evaluate    json.loads($responseBodyCases)    json
    Set Test Variable    ${responseDictCases}

Validate Create Case Response

    ${meetingRoom}=    Get From Dictionary    ${responseDictCases}    meetingRoomId
    Should Not Be Empty   ${meetingRoom}

    ${frontIdCardAttempt}=    Get From Dictionary    ${responseDictCases["proprietors"][0]["verificationCache"]}    frontIdCardConfig
    # Log To Console    ${frontIdCardAttempt}

    # ${parsed_json}=    Evaluate    json.loads($frontIdCardAttempt)
    ${formatted_json}=    Evaluate    json.dumps($frontIdCardAttempt)
    # Log To Console    ${formatted_json}
    # Should Be Equal As Strings    ${expected_json}    ${actual_json}
    ${actual_json}=    Set Variable    {\"attempts\": 3, \"required\": true, \"isEditable\": true, \"threshHold\": 0.8, \"validations\": [], \"currentAttempt\": 3, \"dependenciesRequired\": false, \"compareNonEssentialFields\": false}
    Should Be Equal As Strings     ${formatted_json}    ${actual_json}

Validate Invite Type As SMS
    ${inviteType}=    Get From Dictionary       ${responseDictCases["proprietors"][0]}    inviteType
    Should Be Equal As Strings    ${inviteType}      sms

Validate Invite Type As Email
    ${inviteType}=    Get From Dictionary       ${responseDictCases["proprietors"][0]}    inviteType
    Should Be Equal As Strings    ${inviteType}      email
    

    

