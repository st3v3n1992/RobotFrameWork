*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${OPTIONS}    --disable-blink-features=AutomationControlled --disable-infobars --disable-notifications --disable-save-password-bubble
${URL}     https://www.saucedemo.com/
${BROWSER}    chrome
${USERNAME}   standard_user
${PASSWORD}   secret_sauce
${FILTER}    //*[@data-test="product-sort-container"]

*** Keywords ***
Wait For And Click
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    timeout=10s
    Click Element    ${locator}
*** Keywords ***
*** Keywords ***
Open Browser In Incognito With Options
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --incognito
    Call Method    ${options}    add_argument    --disable-infobars
    Call Method    ${options}    add_argument    --disable-notifications
    Call Method    ${options}    add_argument    --disable-save-password-bubble
    Open Browser    ${URL}    chrome    options=${options}
    Maximize Browser Window

Log In To SauceDemo
    Open Browser In Incognito With Options
    Title Should Be    Swag Labs
    Input Text    id=user-name    ${USERNAME}
    Input Text    id=password     ${PASSWORD}
    Click Button  id=login-button
    Wait Until Page Contains Element    ${FILTER}

Add Items To Cart
    Wait for and Click    //*[@id="add-to-cart-sauce-labs-backpack"]
    sleep    2s
    Wait for and Click    //*[@id="add-to-cart-sauce-labs-bike-light"]
    Sleep    2s
    Wait for and Click    //*[@id="add-to-cart-sauce-labs-bolt-t-shirt"]
    Wait for and Click    //*[@id="add-to-cart-sauce-labs-fleece-jacket"]
    Sleep    5s
    Wait Until Page Contains Element    //*[@data-test="shopping-cart-badge" and text()="4"]

Remove Items From Cart
    FOR    ${index}    IN RANGE    100
        ${buttons}=    Get WebElements    xpath=//button[text()="Remove"]
        Run Keyword Unless    ${buttons}    Exit For Loop
        Click Element    xpath=//button[text()="Remove"]
        Sleep    0.5s
    END

Check Cart Is Empty
    ${exists}=    Run Keyword And Return Status    Page Should Contain Element    //*[@data-test="shopping-cart-badge"]
    Run Keyword If    ${exists}    Element Text Should Be    //*[@data-test="shopping-cart-badge"]    0
    Run Keyword If    not ${exists}    No Operation
run key

*** Test Cases ***
Filter Products By Price
    Log In To SauceDemo
    Wait Until Element Is Enabled    ${FILTER} 
    Click Element    ${FILTER}
    Select From List By Value   ${FILTER}   lohi
    Wait Until Element Is Visible    //*[@data-test="inventory-item"][1]//*[text()="Sauce Labs Onesie"]
    Close Browser

Add Items And Delete From Cart
    Log In To SauceDemo
    Add Items To Cart
    Remove Items From Cart
    Check Cart Is Empty
    Close Browser 
