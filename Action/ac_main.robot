*** Settings ***
Library           Selenium2Library
Library           String
Library           Collections
Library           ../Libs/Selenium2Extend.py
Library           ../Libs/ExcelExtendLibrary.py
Resource          ../Dataset/ds_login.robot
Resource          ../Dataset/ds_hompage.robot
Resource          ../Interface/in_login.robot
Resource          ../Interface/02_Reports/in_rpt_main_filter.robot
Resource          ../Interface/in_homepage.robot
Library           OperatingSystem

*** Keywords ***
build ff profile
    [Arguments]    ${target_path}
    [Documentation]    *Specification:* Change the firefox download location into a new path
    Log    BUILD FIREFOX PROFILE...
    Comment    === Declare variables ===
    ${ac_ff_profile_path}    Set Variable    Libs\\robot_ff_profile\\
    ${ac_ff_profile_template_file_name}    Set Variable    prefs.txt
    ${ac_ff_profile_mime_cf_file_name}    Set Variable    mimeTypes.rdf
    ${ac_template_download_path_str}    Set Variable    ReplaceDownloadDirPathHere
    ${ac_ff_profile_file_name}    Set Variable    prefs.js
    ${ac_ff_profile_rdf_file}    Set Variable    localstore.rdf
    Comment    === Action steps ===
    ${ac_new_ff_path_str}    Normalize Path    ${target_path}
    ${ac_new_ff_path_str}    Replace String    ${ac_new_ff_path_str}    \\    \\\\\
    Remove File    ${target_path}${ac_ff_profile_rdf_file}
    Remove File    ${target_path}${ac_ff_profile_file_name}
    Remove File    ${target_path}${ac_ff_profile_mime_cf_file_name}
    Wait Until Removed    ${target_path}${ac_ff_profile_rdf_file}
    Wait Until Removed    ${target_path}${ac_ff_profile_file_name}
    Wait Until Removed    ${target_path}${ac_ff_profile_mime_cf_file_name}
    ${ac_ff_prefs_content}    Get File    ${ac_ff_profile_path}${ac_ff_profile_template_file_name}    ## Logic flow: Load the firefox profile setting content from a template file .txt then build a new firefox profile setting file with expected target download location
    ${ac_ff_prefs_content}    Replace String    ${ac_ff_prefs_content}    ${ac_template_download_path_str}    ${ac_new_ff_path_str}
    Append To File    ${target_path}${ac_ff_profile_file_name}    ${ac_ff_prefs_content}
    Wait Until Created    ${target_path}${ac_ff_profile_file_name}    10
    Copy File    ${ac_ff_profile_path}${ac_ff_profile_rdf_file}    ${target_path}${ac_ff_profile_rdf_file}
    Copy File    ${ac_ff_profile_path}${ac_ff_profile_mime_cf_file_name}    ${target_path}${ac_ff_profile_mime_cf_file_name}
    Wait Until Created    ${target_path}${ac_ff_profile_rdf_file}    10

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
    Wait Until Element Is Visible    ${in_hp_divwelcome}    30
    ${divwelcome}    Get text    ${in_hp_divwelcome}
    Should Be Equal As Strings    ${ds_hp_divwelcome}    ${divwelcome}
    Comment    Compare text "Welcome ${username}"
    wait loading

logout
    [Documentation]    Click on Sign Out link to logout TGRS
    # Logout
    wait loading
    Click Element    ${in_hp_divwelcome}
    Click Element    ${in_hp_divsignout}
    # Logout success
    Wait Until Element Is Visible    ${in_lg_btnlogin}

select date
    [Arguments]    ${dtpDate}    ${year}    ${month}    ${day}
    wait loading
    Wait Until Element Is Visible    ${dtpDate}    30
    Click Element    ${dtpDate}
    Wait Until Element Is Visible    ${in_rp_mf_dt_cboYear}/option[@value=${year}]    5
    wait loading
    Click Element    ${in_rp_mf_dt_cboYear}/option[@value=${year}]
    Wait Until Element Is Visible    ${in_rp_mf_dt_cboMonth}/option[text()="${month}"]    5
    Click Element    ${in_rp_mf_dt_cboMonth}/option[text()="${month}"]
    wait loading
    ${mon}    Get Value    ${in_rp_mf_dt_cboMonth}/option[text()="${month}"]
    # Select day
    Wait Until Element Is Visible    ${in_rp_mf_dt_tblDate}//td[@data-month=${mon}]/a[text()=${day}]    5
    Click Element    ${in_rp_mf_dt_tblDate}//td[@data-month=${mon}]/a[text()=${day}]
    Wait Until Element Is Not Visible    ${in_rp_mf_dt_tblDate}    5
    wait loading

select month
    [Arguments]    ${dtpMonth}    ${year}    ${month}
    wait loading
    Wait Until Element Is Visible    ${dtpMonth}    30
    Click Element    ${dtpMonth}
    wait loading
    ${tmp_in_rp_mf_mo_fromyear}    Replace String    ${in_rp_mf_mo_fromyear}    [rp_mf_mo_fromyear]    ${year}    -1
    ${tmp_in_rp_mf_mo_toyear}    Replace String    ${in_rp_mf_mo_toyear}    [rp_mf_mo_toyear]    ${year}    -1
    Run Keyword If    "${dtpMonth}"=="${in_rp_mf_mo_selectfrommonth}"    Wait Until Element Is Visible    ${tmp_in_rp_mf_mo_fromyear}
    Run Keyword If    "${dtpMonth}"=="${in_rp_mf_mo_selecttomonth}"    Wait Until Element Is Visible    ${tmp_in_rp_mf_mo_toyear}
    ${fromyear_selected}    Selenium2Library.Get Element Attribute    ${tmp_in_rp_mf_mo_fromyear}    attribute=class
    Run Keyword If    "${dtpMonth}"=="${in_rp_mf_mo_selectfrommonth}" and "${fromyear_selected}"!="selected"    Click Element    ${tmp_in_rp_mf_mo_fromyear}
    ${toyear_selected}    Selenium2Library.Get Element Attribute    ${tmp_in_rp_mf_mo_toyear}    attribute=class
    Run Keyword If    "${dtpMonth}"=="${in_rp_mf_mo_selecttomonth}" and "${toyear_selected}"!="selected"    Click Element    ${tmp_in_rp_mf_mo_toyear}
    wait loading
    # Convert month from abbrev into full text
    ${month}    Set Variable If    "${month}"=="Jan"    January    "${month}"=="Feb"    February    "${month}"=="Mar"    March    "${month}"=="Apr"    April    "${month}"=="May"    May    "${month}"=="Jun"    June    "${month}"=="Jul"    July    "${month}"=="Aug"
    ...    August    "${month}"=="Sep"    September    "${month}"=="Oct"    October    "${month}"=="Nov"    November    "${month}"=="Dec"    December
    Comment    ${tmp_in_rp_mf_mo_frommonth}    Replace String    ${in_rp_mf_mo_frommonth}    [rp_mf_mo_fromyear]    ${year}    -1
    Comment    ${tmp_in_rp_mf_mo_tomonth}    Replace String    ${in_rp_mf_mo_tomonth}    [rp_mf_mo_toyear]    ${year}    -1
    Comment    ${tmp_in_rp_mf_mo_frommonth}    Replace String    ${tmp_in_rp_mf_mo_frommonth}    [rp_mf_mo_frommonth]    ${month}    -1
    Comment    ${tmp_in_rp_mf_mo_tomonth}    Replace String    ${tmp_in_rp_mf_mo_tomonth}    [rp_mf_mo_tomonth]    ${month}    -1
    ${tmp_in_rp_mf_mo_frommonth}    Evaluate    "${in_rp_mf_mo_frommonth}".replace("[rp_mf_mo_fromyear]", "${year}").replace("[rp_mf_mo_frommonth]", "${month}")    #python
    ${tmp_in_rp_mf_mo_tomonth}    Evaluate    "${in_rp_mf_mo_tomonth}".replace("[rp_mf_mo_toyear]", "${year}").replace("[rp_mf_mo_tomonth]", "${month}")    #python
    Run Keyword If    "${dtpMonth}"=="${in_rp_mf_mo_selectfrommonth}"    Wait Until Element Is Visible    ${tmp_in_rp_mf_mo_frommonth}
    Run Keyword If    "${dtpMonth}"=="${in_rp_mf_mo_selecttomonth}"    Wait Until Element Is Visible    ${tmp_in_rp_mf_mo_tomonth}
    Run Keyword If    "${dtpMonth}"=="${in_rp_mf_mo_selectfrommonth}"    Click Element    ${tmp_in_rp_mf_mo_frommonth}
    Run Keyword If    "${dtpMonth}"=="${in_rp_mf_mo_selecttomonth}"    Click Element    ${tmp_in_rp_mf_mo_tomonth}
    wait loading

click control
    [Arguments]    ${control}    ${waitcontrol}=30
    [Documentation]    This action is used to click element after waiting element visible
    wait loading
    Run Keyword And Continue On Failure    Wait Until Element Is Visible    ${control}    ${waitcontrol}
    Run Keyword And Continue On Failure    Click Element    ${control}
    wait loading

wait loading
    [Arguments]    ${timeout}=45
    ${visible_block_ui}    Is Element Visible    ${in_hp_block_ui}    0
    Run Keyword If    ${visible_block_ui}    Wait Until Element Is Not Visible    ${in_hp_block_ui}    ${timeout}
    ${visible_loading_ui}    Is Element Visible    ${in_hp_loading_ui}    0
    Run Keyword If    ${visible_loading_ui}    Wait Until Element Is Not Visible    ${in_hp_loading_ui}    ${timeout}

go to url
    [Arguments]    ${domain}    ${env_path}    ${menu_path}
    sleep    1
    ${domain}    Set Variable    ${ds_lg_url}
    ${env_path}    Set Variable If    "${ds_lg_env}" == "pro"    NAPTGR    Main
    ${menu_path}    Set Variable    ${menu_path}
    Go To    ${domain}/${env_path}/${menu_path}
    sleep    1

convert string to number
    [Arguments]    ${locator}
    [Documentation]    Convert and remove the comma from string to number
    ${number}    Get Text    ${locator}
    ${number}    Remove String    ${number}    ,
    ${number}    Convert To Number    ${number}
    [Return]    ${number}

compare two number
    [Arguments]    ${number1}    ${number2}
    [Documentation]    This action is used to compare two number {$number 1}|{$number 2}. It will show a message if they are not equal.
    ${result}    Run Keyword And Return Status    Should Be Equal As Numbers    ${number1}    ${number2}
    [Return]    ${result}

split day month year
    [Arguments]    ${input}
    ${array}    Evaluate    '${input}'.split('/')
    ${month}    Get From List    ${array}    0
    ${day}    Get From List    ${array}    1
    ${year}    Get From List    ${array}    2
    [Return]    ${month}    ${day}    ${year}

select combobox single selection
    [Arguments]    ${cboselection}    ${cboselectiondata}    ${sglselection}
    [Documentation]    ${cboselection}: combox selection
    ...    ${selectiondata}: naming data of the combox selection
    ...    ${selection}: data set selection
    Wait Until Element Is Visible    ${cboselection}    30
    Click Element    ${cboselection}
    wait loading
    Wait Until Element Is Visible    ${cboselectiondata}/following-sibling::span[normalize-space(text())="${sglselection}"]
    ${tmp_attribute_cboselectiondata}    Does Attribute Exist    ${cboselectiondata}/following-sibling::span[normalize-space(text())="${sglselection}"]/preceding-sibling::input    aria-selected
    Run Keyword Unless    ${tmp_attribute_cboselectiondata}    Click Element    ${cbcselectiondata}/following-sibling::span[normalize-space(text())="${sglselection}"]
    wait loading

select combobox checkbox selection
    [Arguments]    ${cbcselection}    ${cbcselectiondata}    ${chkselection}
    [Documentation]    ${cboselection}: combox selection
    ...    ${selectiondata}: naming data of the combox selection
    ...    ${selection}: data set selection
    Wait Until Element Is Visible    ${cbcselection}    30
    ${tmp_cbcselection}    Replace String    ${cbcselection}    *//span[2]    button    -1
    ${tmp_cbcselection_att}    Selenium2Library.Get Element Attribute    ${tmp_cbcselection}    attribute=class
    Run Keyword Unless    "${tmp_cbcselection_att}"=="ui-multiselect ui-widget ui-state-default ui-state-hover ui-state-active"    Click Element    ${cbcselection}
    wait loading
    Wait Until Element Is Visible    ${cbcselectiondata}/following-sibling::span[normalize-space(text())="${chkselection}"]
    ${tmp_attribute_cbcselectiondata}    Does Attribute Exist    ${cbcselectiondata}/following-sibling::span[normalize-space(text())="${chkselection}"]/preceding-sibling::input    aria-selected
    Run Keyword Unless    ${tmp_attribute_cbcselectiondata}    Click Element    ${cbcselectiondata}/following-sibling::span[normalize-space(text())="${chkselection}"]
    wait loading

wait for export to excel file
    [Arguments]    ${filepath}
    FOR    ${ac_index}    IN RANGE    0    90
    ${ac_existfile}    Run Keyword And Return Status    File Should Exist    ${filepath}
    ${ac_saving_ff}    Run Keyword And Return Status    File Should Exist    ${filepath}.part
    ${ac_saving_gc}    Run Keyword And Return Status    File Should Exist    ${filepath}.crdownload
    Run Keyword If    "${ac_existfile}"!="True" or "${ac_saving_ff}"=='True" or "${ac_saving_gc}"=='True"    sleep    2s
    Exit For Loop If    "${ac_index}"==90 or ("${ac_existfile}"=="True" and "${ac_saving_ff}"!="True") or ("${ac_existfile}"=="True" and "${ac_saving_gc}"!="True")
