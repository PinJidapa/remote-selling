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

# [TS01] Step
# Emulate agent create ekyc case for insured and payer to do ekyc and sends link via email (post create case by valid access token)
# Then the agent resends link by email  (post resend link by insured's proprietor id)
# Next agent gets case to see the case detail (get case detail by case id)
# After that the agent fetch the ekyc result before insured and payer do ekyc (get ekyc result by insured's proprietor id and payer's proprietor id)
# Then simulate insured and payer do ekyc by patch front id, back id, and face compare (liveness's not passed) (patch and post ekyc data by insured's verification id and payer's verification id)
# Next the agent fetches the ekyc result after insured and payer have done the ekyc (get ekyc result by insured's proprietor id and payer's proprietors id)
# Then the agent submit case (patch submit case by case id)
# Lastly, the agent closes the cas to make the case expire (patch expire case by case id)

*** Test Cases ***
TS02 Create Case By Email And Two Proprietor Do Ekyc
    # Get access token 
    ${accessToken}=     Get Token
    ...    ${clientId}    
    ...    ${clientSecret}    
    ...    ${authUrl}

    # Create the case for insured and payer to do ekyc
    # which the status code should be 201
    ${responseDictCases}=    Create Case
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    TwoProprietorCaseByEmail
    ...    201
    ${insuredProprietorId} =    Get From Dictionary    ${responseDictCases["proprietors"][0]}    id
    ${payerProprietorId} =    Get From Dictionary    ${responseDictCases["proprietors"][1]}    id
    ${caseId} =    Get From Dictionary    ${responseDictCases}    id
    Log To Console  ccc:${caseId}

    ${insuredVerificationId} =    Get From Dictionary    ${responseDictCases["proprietors"][0]}    verificationRef
    ${payerVerificationId} =    Get From Dictionary    ${responseDictCases["proprietors"][1]}    verificationRef
    
    Sleep    2
    Validate Create Case Response
    ...    ${responseDictCases}
    ...    verificationResponseSchemaTS002

    Resend Link
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${insuredProprietorId}
    ...    ${emailInviteType}
    ...    204

    ${responseDictCases}=    Get Case By Id
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${caseId}
    ...    200

    Validate Case Detail Response
    ...    ${responseDictCases}
    ...    CaseResponseAfterCreateCaseTS002

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

    Sleep    2
    ${responseDictProprietor}=    Get Proprietors By ID
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${insuredProprietorId}
    ...    200

    Validate Proprietors Response
    ...    ${responseDictProprietor}
    ...    AfterInsuredDoEkycTS002

    Sleep    2
    ${responseDictProprietor}=    Get Proprietors By ID
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${payerProprietorId}
    ...    200

    Validate Proprietors Response
    ...    ${responseDictProprietor}
    ...    AfterPayerDoEkycTS002

    Patch Submit Case
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${caseId}
    ...    204   

    Sleep    2s

    ${responseDictCases}=    Get Case By Id
    ...    ${accessToken}
    ...    ${baseUrl}
    ...    ${caseId}
    ...    200

    Validate Case Detail Response
    ...    ${responseDictCases}
    ...    CaseResponseAfterSubmitCaseTS002