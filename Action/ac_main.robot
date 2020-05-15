*** Settings ***
Library           Selenium2Library
Resource          ../Dataset/ds_login_local.robot
Resource          ../Interface/in_login.robot
Resource          ../Interface/02_Reports/in_rpt_main_filter.robot
Resource          ../Interface/in_homepage.robot

*** Keywords ***
login
    [Arguments]    ${username}    ${password}
    [Documentation]    Type 'username' and 'password' into the textboxes then click Login button
    # Wait to check exist element
    Wait Until Element Is Visible    ${in_lg_txtusername}
    Wait Until Element Is Visible    ${in_lg_txtpassword}
    Wait Until Page Contains Element    ${in_lg_btnlogin}
    # Login
    Input Text    ${in_lg_txtusername}    ${username}
    Input Text    ${in_lg_txtpassword}    ${password}
    Click Element    ${in_lg_btnlogin}
    # Login success
    Wait Until Element Is Visible    ${in_hp_divwelcome}
    ${divwelcome}    Get text    ${in_hp_divwelcome}
    Should Be Equal As Strings    ${ds_hp_divwelcome}    ${divwelcome}
    Comment    Compare text 'Welcome ${username}'
    Wait Until Element Is Visible    ${in_hp_block_ui}    5
    Wait Until Element Is Not Visible    ${in_hp_block_ui}    30

logout
    [Documentation]    Click on Sign Out link to logout TGRS
    # Logout
    Wait Until Element Is Not Visible    ${in_hp_block_ui}    30
    Click Element    ${in_hp_divwelcome}
    Click Element    ${in_hp_divsignout}
    # Logout success
    Wait Until Element Is Visible    ${in_lg_btnlogin}

select date
    [Arguments]    ${dtpDate}    ${year}    ${month}    ${day}
    Wait Until Element Is Not Visible    ${in_hp_block_ui}    30
    Wait Until Element Is Visible    ${dtpDate}    10
    Click Element    ${dtpDate}
    Wait Until Element Is Visible    ${in_rp_mf_cboYear}/option[@value=${year}]    5
    Click Element    ${in_rp_mf_cboYear}/option[@value=${year}]
    Wait Until Element Is Visible    ${in_rp_mf_cboMonth}/option[text()='${month}']    5
    Click Element    ${in_rp_mf_cboMonth}/option[text()='${month}']
    ${mon}    Get Value    ${in_rp_mf_cboMonth}/option[text()='${month}']
    # Select day
    Wait Until Element Is Visible    ${in_rp_mf_tblDate}//td[@data-month=${mon}]/a[text()=${day}]    5
    Click Element    ${in_rp_mf_tblDate}//td[@data-month=${mon}]/a[text()=${day}]
    Wait Until Element Is Not Visible    ${in_rp_mf_tblDate}    5

select element
    [Arguments]    ${element}
    [Documentation]    This action is used to click element after waiting element visible
    Wait Until Element Is Not Visible    ${in_hp_block_ui}    30
    Wait Until Element Is Visible    ${element}    30
    Click Element    ${element}
