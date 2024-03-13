*** Settings ***
Library         RequestsLibrary
Library         Collections
Resource        ./GetToken.robot
Library         OperatingSystem

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
    ${responseDictCases} =    Evaluate    json.loads($responseBodyCases)
    Set Test Variable    ${responseDictCases}

Validate Create Case Response
    ${meetingRoom}=    Get From Dictionary    ${responseDictCases}    meetingRoomId
    Should Not Be Empty   ${meetingRoom}

    ${frontIdCardAttempt}=    Get From Dictionary    ${responseDictCases["proprietors"][0]["verificationCache"]["frontIdCardConfig"]}    attempts
    Should Be Equal As Integers    ${frontIdCardAttempt}    3

    ${frontIdCardRequired}=    Get From Dictionary    ${responseDictCases["proprietors"][0]["verificationCache"]["frontIdCardConfig"]}    required
    Should Be True   ${frontIdCardRequired}
    
    ${backIdCardAttempt}=    Get From Dictionary    ${responseDictCases["proprietors"][0]["verificationCache"]["backIdCardConfig"]}    attempts
    Should Be Equal As Integers    ${backIdCardAttempt}    3

    ${backIdCardRequired}=    Get From Dictionary    ${responseDictCases["proprietors"][0]["verificationCache"]["backIdCardConfig"]}    required
    Should Be True   ${backIdCardAttempt}

    ${idFaceRecognitionAttempt}=    Get From Dictionary    ${responseDictCases["proprietors"][0]["verificationCache"]["idFaceRecognition"]}    attempts
    Should Be Equal As Integers    ${idFaceRecognitionAttempt}    3

    ${idFaceRecognitionRequired}=    Get From Dictionary    ${responseDictCases["proprietors"][0]["verificationCache"]["idFaceRecognition"]}    required
    Should Be True   ${idFaceRecognitionAttempt}




    # Should Be True   ${frontIdCardRequiredConfig}
    # Should Not Be True

    # ["verificationCache"][0]["frontIdCardConfig"][0]
