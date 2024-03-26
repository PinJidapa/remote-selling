*** Settings ***
Library         RequestsLibrary
Library         Collections


*** Keywords *** 


Get Token
    [Arguments]    ${clientId}    ${clientSecret}    ${authUrl} 
    ${data} =    Create Dictionary
    ...    client_id=${clientId}
    ...    client_secret=${clientSecret}
    ...    grant_type=client_credentials
    ${response} =    POST    ${authUrl}    data=${data}
    ${responseBody} =    Set Variable    ${response.text}
    ${responseDict} =    Evaluate    json.loads($responseBody)
    ${accessToken} =    Get From Dictionary    ${responseDict}    access_token
    Return From Keyword    ${accessToken}