*** Settings ***
Library         SeleniumLibrary
Library         JSONLibrary
Resource        ../Page/GetToken.robot
Resource        ../Page/CreateCase.robot
Resource        ../Page/Resend.robot
Resource        ../Resourse/Env/${env}/Credential.robot
Resource        ../Resourse/Env/${env}/Url.robot

*** Variables ***
${smsInviteType}    invite?inviteType=sms&phoneNumber=0619926554
${emailInviteType}    invite?inviteType=email&email=pinpinnpinnn3@gmail.com
${invalidPropritorId}    12345678-1234-1234-1234-123456789012

*** Test Cases ***
Post Create Case By Email
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
    ...    ${invalidPropritorId}
    ...    ${emailInviteType}
    ...    404
