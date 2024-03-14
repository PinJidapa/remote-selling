*** Settings ***
Library         RequestsLibrary
# Library         JSONSchemaLibrary
# Library         JSONLibrary
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
    Return From Keyword    ${responseDictCases}

Validate Verification Response
    [Arguments]    ${responseDictCases}
    ${meetingRoom}=    Get From Dictionary    ${responseDictCases}    meetingRoomId
    Should Not Be Empty   ${meetingRoom}

    ${frontIdCardConfig}=    Get From Dictionary    ${responseDictCases["proprietors"][0]["verificationCache"]}    frontIdCardConfig
    ${formattedActualFrontIdCardConfig}=    Evaluate    json.dumps($frontIdCardConfig)
   
    ${filePath} =    Get File    ${EXECDIR}/Resourse/TestData/CreateCase/verificationResponse.json
    ${verificationsConfig} =    Evaluate    json.loads('''${filePath}''') 
    ${expectedFrontIdCardConfig}=    Get From Dictionary    ${verificationsConfig}    frontIdCardConfig  
    ${formattedExpectedFrontIdCardConfig}=    Evaluate    json.dumps($expectedFrontIdCardConfig)
    
    Should Be Equal As Strings     ${formattedExpectedFrontIdCardConfig}    ${formattedActualFrontIdCardConfig}

    ${backIdCardConfig}=    Get From Dictionary    ${responseDictCases["proprietors"][0]["verificationCache"]}    backIdCardConfig
    ${formattedActualBackIdCardConfig}=    Evaluate    json.dumps($backIdCardConfig)

    ${expectBackIdCardConfig}=    Get From Dictionary    ${verificationsConfig}    backIdCardConfig
    ${formattedExpectedBackIdCardConfig}=    Evaluate    json.dumps($expectBackIdCardConfig)

     Should Be Equal As Strings     ${formattedActualBackIdCardConfig}    ${formattedExpectedBackIdCardConfig}
    

Validate Invite Type As SMS
    [Arguments]    ${responseDictCases}
    ${inviteType}=    Get From Dictionary       ${responseDictCases["proprietors"][0]}    inviteType
    Should Be Equal As Strings    ${inviteType}      sms

Validate Invite Type As Email
    [Arguments]    ${responseDictCases}
    ${inviteType}=    Get From Dictionary       ${responseDictCases["proprietors"][0]}    inviteType
    Should Be Equal As Strings    ${inviteType}      email
    

    

