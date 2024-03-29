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
${emailInviteType}    invite?inviteType=email&email=jidapa.o@appman.co.th
${invalidId}    12345678-1234-1234-1234-123456789012

# [TS01] Step
# Emulate there is no token to create the case (post create case by valid access token)
# Then, agent is unable to resend the link because an invalid insured proprietor id was provided  (post resend link by insured's proprietor id)
# Next, agent is unable to see the case detail because of an invalid case id (get case detail by case id)
# After, that the agent can't get the ekyc result due to an invalid proprietor id (get ekyc result by proprietor id)
# Then, simulate insured can't do the ekyc due to an invalid verification id (patch and post ekyc data by insured's verification id and payer's verification id)
# Next, the agent fetches the ekyc result after insured and payer have done the ekyc (get ekyc result by insured's proprietor id and payer's proprietors id)
# Then, the agent can't submit case becasue of an invalid case id (patch submit case by case id)
# Lastly, the agent isn't able to close the case for making the case expire because of an invalid case id (patch expire case by case id)

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

    Get Proprietors By ID
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${invalidId} 
    ...    404

    Patch Submit Case
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${invalidId} 
    ...    404

    Patch Expired Case
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${invalidId} 
    ...    404


