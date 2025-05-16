*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}     https://www.saucedemo.com/
${BROWSER}    chrome
${USERNAME}   standard_user
${PASSWORD}   secret_sauce

*** Test Cases ***
Open Saucedemo And Check Title
    Open Browser    https://www.saucedemo.com    chrome
    Title Should Be    Swag Labs
    Close Browser
    [Documentation]    This test case opens the Saucedemo website and checks if the title is correct.

Log In To SauceDemo
    Open Browser    ${URL}    ${BROWSER}
    Input Text    id=user-name    ${USERNAME}
    Input Text    id=password     ${PASSWORD}
    Click Button  id=login-button
    Sleep    4s
    Page Should Contain Element    css:.inventory_list
    Close Browser