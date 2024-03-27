*** Settings ***
Library         SeleniumLibrary
Library         JSONLibrary
Resource        ../Page/GetTokenPage.robot
Resource        ../Page/CreateCasePage.robot
Resource        ../Page/ResendPage.robot
Resource        ../Page/GetCaseByIdPage.robot
Resource        ../Keywords/KycKeyword.robot
Resource        ../Resourse/Env/${env}/Credential.robot
Resource        ../Resourse/Env/${env}/Url.robot

*** Variables ***
${smsInviteType}    invite?inviteType=sms&phoneNumber=0619926554
${emailInviteType}    invite?inviteType=email&email=pinpinnpinnn3@gmail.com
${invalidId}    12345678-1234-1234-1234-123456789012

*** Test Cases ***
TS03 Negative Case
    ${accessToken}=     Get Token
    ...    ${clientId}    
    ...    ${clientSecret}    
    ...    ${authUrl}
    ${responseDictCases}=    Create Case
    ...    
    ...    ${baseUrl}
    ...    TwoProprietorCaseByEmail
    ...    403
    Resend Link
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${invalidId}
    ...    ${emailInviteType}
    ...    404
    Get Case By Id
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${invalidId}
    ...    404
    Client Pass Front ID Card, Back ID Card, Not Pass Face Recognition
    ...    ${kycPrivateKey}
    ...    ${baseKycUrl}
    ...    ${invalidId} 
    ...    /Resourse/TestData/IdCard/FrontIdCard01.jpeg 
    ...    /Resourse/TestData/IdCard/BackIdCard01.jpeg
    ...    image/jpeg
    ...    404
