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
Resource        ../Resourse/Env/${env}/Credential.robot
Resource        ../Resourse/Env/${env}/Url.robot

*** Variables ***
${smsInviteType}    invite?inviteType=sms&phoneNumber=0619926554
${emailInviteType}    invite?inviteType=email&email=pinpinnpinnn3@gmail.com

*** Test Cases ***
# [TS01] Step
# create case for one proprietor to do ekyc and send the link by sms
# resend link by sms
# get case (exsiting case)
# get proprietor by id before insured will do ekyc
# patch front id, back id, and face compare (liveness's not passed) by valid proprietor id for insured
# get proprietor by id after patch the ekyc result
# patch submit case (valid case)
# patch expired case (valid case)

TS01 Create Case By Mobile Phone Number And Only One Proprietor Does Ekyc
    # Get access token 
    ${accessToken}=     Get Token
    ...    ${clientId}    
    ...    ${clientSecret}    
    ...    ${authUrl}
    # Create the case and retrieve the response body to validate the response
    ${responseDictCases}=    Create Case
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    OneProprietorCaseBySms
    ...    201
    # Get proprietor id from create case response to use in next request
    ${insuredProprietorId} =    Get From Dictionary    ${responseDictCases["proprietors"][0]}    id
    # Get case id from create case response to use in next request
    ${caseId} =    Get From Dictionary    ${responseDictCases}    id
    # Get verification id from create case response to use in next request
    ${insuredVerificationId} =    Get From Dictionary    ${responseDictCases["proprietors"][0]}    verificationRef
    
    # validate the verification response after create the case
    Validate Verification Response
    ...    ${responseDictCases}

    # retrieve the access token from get token api, proprietor id from create case api 
    # and select the invite type as sms to resend the link
    # which the status code should be 200
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
    ...    200
    Get Proprietors By ID
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${insuredProprietorId}
    ...    200
    Client Pass Front ID Card, Back ID Card, Not Pass Face Recognition
    ...    ${kycPrivateKey}
    ...    ${baseKycUrl}
    ...    ${insuredVerificationId}
    ...    /Resourse/TestData/IdCard/FrontIdCard01.jpeg 
    ...    /Resourse/TestData/IdCard/BackIdCard01.jpeg
    ...    image/jpeg
    ...    200
    Get Proprietors By ID
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${insuredProprietorId}
    ...    200
    Patch Expired Case
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${caseId}
    ...    204
    Patch Expired Case
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${caseId}
    ...    404

