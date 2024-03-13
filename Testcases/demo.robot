*** Settings ***
Library           SeleniumLibrary

*** Test Cases ***
Open Browser
    Open Browser    https://www.google.com    chrome
    Maximize Browser Window
    Set Selenium Speed    0.5s
    Input Text    name=q    Hello World
    Click Button    name=btnK
    Capture Page Screenshot
    Close Browser
