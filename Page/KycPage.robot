*** Settings ***
Library         RequestsLibrary
Library         ../Scripts/validate.py
Library         Collections
Library         OperatingSystem
Library         ../Scripts/api.py
Resource        ./GetTokenPage.robot

*** Keywords *** 
Patch Consent
    [Arguments]    ${kycPrivateKey}    ${baseKycUrl}    ${verificationId}    ${expectedStatus}
    ${headers} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${kycPrivateKey}
    ${file_path} =    Get File    ${EXECDIR}/Data/patchConsentBody.json
    ${json_data} =    Evaluate    json.loads('''${file_path}''')
    ${patchConsent} =    PATCH    ${baseKycUrl}/verifications/${verificationId}
    ...    expected_status=${expectedStatus}
    ...    json=${json_data}
    ...    headers=${headers}

Post Front ID Card
    [Arguments]    ${kycPrivateKey}    ${baseKycUrl}    ${verificationId}    ${frontIdCard}    ${extensionName}
    ${headers} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${kycPrivateKey}
    ${response} =    Upload File
    ...    ${baseKycUrl}/verifications/${verificationId}/frontIdCards
    ...    ${EXECDIR}${frontIdCard}
    ...    ${extensionName}
    ...    ${headers}

Patch Front ID Card
    [Arguments]    ${kycPrivateKey}    ${baseKycUrl}    ${verificationId}    ${expectedStatus}
    ${headers} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${kycPrivateKey}
    ${file_path} =    Get File    ${EXECDIR}/Data/patchIdCard.json
    ${json_data} =    Evaluate    json.loads('''${file_path}''')
    ${response} =    PATCH    ${baseKycUrl}/verifications/${verificationId}/frontIdCards
    ...    json=${json_data}
    ...    headers=${headers}
    ...    expected_status=${expectedStatus}

Post Back ID Card
    [Arguments]    ${kycPrivateKey}    ${baseKycUrl}    ${verificationId}    ${backIdCard}    ${extensionName}
    ${headers} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${kycPrivateKey}
    ${response} =    Upload File
    ...    ${baseKycUrl}/verifications/${verificationId}/backIdCards
    ...    ${EXECDIR}${backIdCard}
    ...    ${extensionName}
    ...    ${headers}

Patch Back ID Card
    [Arguments]    ${kycPrivateKey}    ${baseKycUrl}    ${verificationId}    ${expectedStatus}
    ${headers} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${kycPrivateKey}
    ${file_path} =    Get File    ${EXECDIR}/data/patchIdCard.json
    ${json_data} =    Evaluate    json.loads('''${file_path}''')
    ${response} =    PATCH    ${baseKycUrl}/verifications/${verificationId}/backIdCards
    ...    json=${json_data}
    ...    headers=${headers}
    ...    expected_status=${expectedStatus}

Get FaceTec Token Session  
    [Arguments]    ${kycPrivateKey}    ${baseKycUrl}    ${verificationId}    ${expectedStatus}
    ${headers} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${kycPrivateKey}
    Set To Dictionary    ${headers}    X-Device-Key    dZKMPkqUqEBn370Rz8uq3nn0zdUAeqpE
    ${tokenResponse} =    GET    ${baseKycUrl}/verifications/${verificationId}/liveness/facetec/session-token
    ...    headers=${headers}

    ${tokenResponseSessionToken} =    Set Variable    ${tokenResponse.text}
    ${tokenResponseDictSessionToken} =    Evaluate    json.loads($tokenResponseSessionToken)
    ${sessionToken} =    Get From Dictionary    ${tokenResponseDictSessionToken}    sessionToken
    Set Test Variable    ${sessionToken}

    ${file_path} =    Get File    ${EXECDIR}/data/livenessFail.json
    ${json_data} =    Evaluate    json.loads('''${file_path}''')
    Set To Dictionary    ${json_data}    sessionId    ${sessionToken}
    ${response} =    POST     ${baseKycUrl}/verifications/${verificationId}/liveness/facetec/liveness-3d    json=${json_data}
    ...    headers=${headers}
    ...    expected_status=${expectedStatus}

Patch Remark
    [Arguments]    ${kycPrivateKey}    ${baseKycUrl}    ${verificationId}    ${expectedStatus}
    ${headers} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${kycPrivateKey}
    ${file_path} =    Get File    ${EXECDIR}/data/patchRemark.json
    ${json_data} =    Evaluate    json.loads('''${file_path}''')
    ${response} =    PATCH    ${baseKycUrl}/verifications/${verificationId}
    ...    json=${json_data}
    ...    headers=${headers}
    ...    expected_status=${expectedStatus}

Patch Confirm Verification
    [Arguments]    ${kycPrivateKey}    ${baseKycUrl}    ${verificationId}    ${expectedStatus}
    ${headers} =    Create Dictionary
    Set To Dictionary    ${headers}    Authorization    Bearer ${kycPrivateKey}
    ${file_path} =    Get File    ${EXECDIR}/data/patchConfirm.json
    ${json_data} =    Evaluate    json.loads('''${file_path}''')
    ${response} =    PATCH    ${baseKycUrl}/verifications/${verificationId}/idFaceRecognitions
    ...    json=${json_data}
    ...    headers=${headers}
    ...    expected_status=${expectedStatus}