*** Settings ***
Library         SeleniumLibrary
Library         JSONLibrary
Resource        ../Page/GetTokenPage.robot
Resource        ../Page/CreateCasePage.robot
Resource        ../Page/ResendPage.robot
Resource        ../Page/GetCaseByIdPage.robot
Resource        ../Keywords/KycKeyword.robot
Resource        ../Page/GetProprietorByIdPage.robot
Resource        ../Page/PatchExpiredCasePage.robot
Resource        ../Page/PatchSubmitCasePage.robot
Resource        ../Resourse/Env/${env}/Credential.robot
Resource        ../Resourse/Env/${env}/Url.robot

*** Variables ***
${smsInviteType}    invite?inviteType=sms&phoneNumber=0619926554
${emailInviteType}    invite?inviteType=email&email=pinpinnpinnn3@gmail.com

*** Test Cases ***
TS02 Create Case By Email And Two Proprietor Do Ekyc
    ${accessToken}=     Get Token
    ...    ${clientId}    
    ...    ${clientSecret}    
    ...    ${authUrl}
    ${responseDictCases}=    Create Case
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    TwoProprietorCaseByEmail
    ...    201
    ${insuredProprietorId} =    Get From Dictionary    ${responseDictCases["proprietors"][0]}    id
    ${payerProprietorId} =    Get From Dictionary    ${responseDictCases["proprietors"][1]}    id
    ${caseId} =    Get From Dictionary    ${responseDictCases}    id

    ${insuredVerificationId} =    Get From Dictionary    ${responseDictCases["proprietors"][0]}    verificationRef
    ${payerVerificationId} =    Get From Dictionary    ${responseDictCases["proprietors"][1]}    verificationRef


    # Validate Verification Response
    # ...    ${responseDictCases}
    # ...    verificationResponseSchemaTS002
    # Resend Link
    # ...    ${accessToken}
    # ...    ${baseUrl}
    # ...    ${insuredProprietorId}
    # ...    ${emailInviteType}
    # ...    204
    Get Case By Id
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${caseId}
    ...    200
    ...    getcaseResponseTS002copy

    Client Pass Front ID Card, Back ID Card, Not Pass Face Recognition
    ...    ${kycPrivateKey}
    ...    ${baseKycUrl}
    ...    ${insuredVerificationId}
    ...    /Resourse/TestData/IdCard/FrontIdCard01.jpeg 
    ...    /Resourse/TestData/IdCard/BackIdCard01.jpeg
    ...    image/jpeg
    ...    200

    Client Pass Front ID Card, Back ID Card, Not Pass Face Recognition
    ...    ${kycPrivateKey}
    ...    ${baseKycUrl}
    ...    ${payerVerificationId}
    ...    /Resourse/TestData/IdCard/FrontIdCard02.jpeg 
    ...    /Resourse/TestData/IdCard/BackIdCard02.jpeg
    ...    image/jpeg
    ...    200

    # Get Proprietors By ID
    # ...    ${accessToken}
    # ...    ${baseUrl}
    # ...    ${insuredProprietorId}
    # ...    200

    # Get Proprietors By ID
    # ...    ${accessToken}
    # ...    ${baseUrl}
    # ...    ${payerProprietorId}
    # ...    200

    # Patch Submit Case
    # ...    ${accessToken}
    # ...    ${baseUrl}
    # ...    ${caseId}
    # ...    204   
    
    # Patch Expired Case
    # ...    ${accessToken}
    # ...    ${baseUrl}
    # ...    ${caseId}
    # ...    204
    # Sleep    5s
    # Patch Expired Case
    # ...    ${accessToken}
    # ...    ${baseUrl}
    # ...    ${caseId}
    # ...    404