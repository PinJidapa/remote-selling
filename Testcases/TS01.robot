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

# [TS01] Step
# Emulate agent create ekyc case for one insured to do ekyc and sends link via sms  (post create case by valid access token)
# Then the agent resends link by sms (post resend link by insured's proprietor id)
# Next agent get case to see the case detail (get case detail by case id)
# After that the agent fetch the ekyc result before insured does ekyc (get ekyc result by proprietor id)
# Then simulate insured does ekyc by patch front id, back id, and face compare (liveness's not passed) (patch and post ekyc data by insured's verification id)
# Next the agent fetches the ekyc result after insured has done the ekyc (get ekyc result by insured's proprietor id)
# Then the agent submit case (patch submit case by case id)
# Lastly, the agent closes the cas to make the case expire (patch expire case by case id)

*** Test Cases ***
TS01 Create Case By Mobile Phone Number And Only One Proprietor Does Ekyc
    # Get access token 
    ${accessToken}=     Get Token
    ...    ${clientId}    
    ...    ${clientSecret}    
    ...    ${authUrl}

    # Create the case and retrieve the response body to validate the response
    ${responseDictCreateCases}=    Create Case
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    OneProprietorCaseBySms
    ...    201

    # Get proprietor id from create case response to use in next request
    ${insuredProprietorId} =    Get From Dictionary    ${responseDictCreateCases["proprietors"][0]}    id

    # Get case id from create case response to use in next request
    ${caseId} =    Get From Dictionary    ${responseDictCreateCases}    id
    Log To Console    ${insuredProprietorId}

    # Get verification id from create case response to use in next request
    ${insuredVerificationId} =    Get From Dictionary    ${responseDictCreateCases["proprietors"][0]}    verificationRef
    
    # validate the verification response after create the case
    Validate Create Case Response
    ...    ${responseDictCreateCases}
    ...    verificationResponseSchemaTS001

    # retrieve the access token from get token api, proprietor id from create case api 
    # and select the invite type as sms to resend the link
    # which the status code should be 200
    Resend Link
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${insuredProprietorId}
    ...    ${smsInviteType}
    ...    204

    # retrieve the access token from get token api, case id from create case api 
    # which the status code should be 200\
    # the response body after get case by id should be the same as expected result
    # we mainly focus on firstname, lastname, status, citizenId, inviteType, verificationCache
    ${responseDictCases}=    Get Case By Id
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${caseId}
    ...    200

    Validate Case Detail Response
    ...    ${responseDictCases}
    ...    getcaseResponseTS001

    ${responseDictProprietor}=    Get Proprietors By ID
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${insuredProprietorId}
    ...    200

    Validate Proprietors Response
    ...    ${responseDictProprietor}
    ...    getProprietorResponseBeforeEkycTS001

    # Client Pass Front ID Card, Back ID Card, Not Pass Face Recognition
    # ...    ${kycPrivateKey}
    # ...    ${baseKycUrl}
    # ...    ${insuredVerificationId}
    # ...    /Resourse/TestData/IdCard/FrontIdCard01.jpeg 
    # ...    /Resourse/TestData/IdCard/BackIdCard01.jpeg
    # ...    image/jpeg
    # ...    200

    # ${responseDictProprietor}=  Get Proprietors By ID
    # ...    ${accessToken}
    # ...    ${baseUrl}
    # ...    ${insuredProprietorId}
    # ...    200

    # Validate Proprietors Response
    # ...    ${responseDictProprietor}
    # ...    getProprietorResponseBeforeEkycTS001

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


