*** Settings ***
Library         SeleniumLibrary
Library         JSONLibrary
Resource        ../Page/GetToken.robot
Resource        ../Page/CreateCase.robot
Resource        ../Page/Resend.robot
Resource        ../Page/GetCaseById.robot
Resource        ../Page/Kyc.robot
Resource        ../Resourse/Env/${env}/Credential.robot
Resource        ../Resourse/Env/${env}/Url.robot

*** Variables ***
${smsInviteType}    invite?inviteType=sms&phoneNumber=0619926554
${emailInviteType}    invite?inviteType=email&email=pinpinnpinnn3@gmail.com

*** Test Cases ***
Post Create Case By Email
    ${accessToken}=     Get Token
    ...    ${clientId}    
    ...    ${clientSecret}    
    ...    ${authUrl}
    ${responseDictCases}=    Create Case
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    OneProprietorCaseBySms
    ...    201
    ${insuredProprietorId} =    Get From Dictionary    ${responseDictCases["proprietors"][0]}    id
    ${caseId} =    Get From Dictionary    ${responseDictCases}    id

    ${insuredVerificationId} =    Get From Dictionary    ${responseDictCases["proprietors"][0]}    verificationRef

    Validate Verification Response
    ...    ${responseDictCases}
    Resend Link
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${insuredProprietorId}
    ...    ${smsInviteType}
    ...    204
    Get Case By Id
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${caseId}
    ...    204
    Patch Consent
    ...    ${kycPrivateKey}    
    ...    ${baseKycUrl}  
    ...    ${insuredVerificationId}
    ...    200
    Post Front ID Card
    ...    ${kycPrivateKey} 
    ...    ${baseKycUrl}
    ...    ${insuredVerificationId}
    ...    /Resourse/TestData/IdCard/FrontIdCard.JPG
    ...    image/JPG
    Patch Front ID Card
    ...    ${kycPrivateKey} 
    ...    ${baseKycUrl}
    ...    ${insuredVerificationId}
    Post Back ID Card
    ...    ${kycPrivateKey} 
    ...    ${baseKycUrl}
    ...    ${insuredVerificationId}
    ...    /Resourse/TestData/IdCard/BackIdCard.jpeg
    ...    image/jpeg
    Patch Back ID Card
    ...    ${kycPrivateKey}
    ...    ${baseKycUrl}
    ...    ${insuredVerificationId}
    Get FaceTec Token Session  
    ...    ${kycPrivateKey}
    ...    ${baseKycUrl}
    ...    ${insuredVerificationId}
    Patch Remark
    ...    ${kycPrivateKey}    
    ...    ${baseKycUrl}    
    ...    ${insuredVerificationId}
    Patch Confirm Verification
    ...    ${kycPrivateKey}    
    ...    ${baseKycUrl}    
    ...    ${insuredVerificationId}


