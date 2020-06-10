*** Settings ***
Library           Selenium2Library
Library           String
Library           Collections
Library           ../Libs/Selenium2Extend.py
Library           ../Libs/ExcelExtendLibrary.py
Resource          ../Dataset/ds_login.robot
Resource          ../Dataset/ds_hompage.robot
Resource          ../Interface/in_login.robot
Resource          ../Interface/02_Reports/in_rpt_main_filter_general.robot
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
    [Arguments]    ${dtpDate}    ${date}
    [Documentation]    ${dtpDate}: locator
    ...    ${date}: mm-dd-yyyy
    ...    Ex: select date ${in_rp_mf_dt_selectfromdate} 02/03/2019
    wait loading
    # Spit & return ${month} ${day} ${year}
    ${month}    ${day}    ${year}    split month day year    ${date}
    Wait Until Element Is Visible    ${dtpDate}    30
    Click Element    ${dtpDate}
    Wait Until Element Is Visible    ${in_rp_mf_dt_cboYear}/option[@value="${year}"]    5
    wait loading
    Click Element    ${in_rp_mf_dt_cboYear}/option[@value="${year}"]
    Wait Until Element Is Visible    ${in_rp_mf_dt_cboMonth}/option[text()="${month}"]    5
    Click Element    ${in_rp_mf_dt_cboMonth}/option[text()="${month}"]
    wait loading
    ${mon}    Get Value    ${in_rp_mf_dt_cboMonth}/option[text()="${month}"]
    # Select day
    Wait Until Element Is Visible    ${in_rp_mf_dt_tblDate}//td[@data-month="${mon}"]/a[text()="${day}"]    5
    Click Element    ${in_rp_mf_dt_tblDate}//td[@data-month="${mon}"]/a[text()="${day}"]
    Wait Until Element Is Not Visible    ${in_rp_mf_dt_tblDate}    5
    wait loading

select month
    [Arguments]    ${dtpMonth}    ${date}
    [Documentation]    ${dtpMonth}: locator
    ...    ${date}: mm/dd/yyyy (from: mm/01/yyyy - to: mm/31/yyyy)
    ...    Ex: select month ${in_rp_mf_mo_selectfromdate} 02/01/2019
    wait loading
    # Spit & return ${month} ${day} ${year}
    ${month}    ${day}    ${year}    split month day year    ${date}
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
    [Arguments]    ${string}
    [Documentation]    Convert and remove the comma from string to number
    ${number}    Set Variable    ${string}
    ${number}    Remove String    ${number}    ,
    ${number}    Convert To Number    ${number}
    [Return]    ${number}

convert string to number with locator
    [Arguments]    ${locator}
    [Documentation]    Convert and remove the comma from string to number
    ${number}    Get Text    ${locator}
    ${number}    Remove String    ${number}    ,
    ${number}    Convert To Number    ${number}
    [Return]    ${number}

split month day year
    [Arguments]    ${input}
    Comment    Log    'action split day month year'
    Comment    Set Log Level    NONE
    ${array}    Evaluate    '${input}'.split('/')
    ${month}    Get From List    ${array}    0
    ${month}    Set Variable If    "${month}"=="01" or "${month}"=="1"    Jan    "${month}"=="02" or "${month}"=="2"    Feb    "${month}"=="03" or "${month}"=="3"    Mar    "${month}"=="04" or "${month}"=="4"    Apr    "${month}"=="05" or "${month}"=="5"    May    "${month}"=="06" or "${month}"=="6"    Jun    "${month}"=="07" or "${month}"=="7"    Jul    "${month}"=="08" or "${month}"=="8"
    ...    Aug    "${month}"=="09" or "${month}"=="9"    Sep    "${month}"=="10"    Oct    "${month}"=="11"    Nov    "${month}"=="12"    Dec
    Comment    ${month}    Set Variable If    "${month}"=="01" or "${month}"=="1"    January    "${month}"=="02" or "${month}"=="2"    February    "${month}"=="03" or "${month}"=="3"    March    "${month}"=="04" or "${month}"=="4"    April    "${month}"=="05" or "${month}"=="5"    May    "${month}"=="06" or "${month}"=="6"    June    "${month}"=="07" or "${month}"=="7"    July
    ...    "${month}"=="08" or "${month}"=="8"    August    "${month}"=="09" or "${month}"=="9"    September    "${month}"=="10"    October    "${month}"=="11"    November    "${month}"=="12"    December
    ${tmp_day}    Get From List    ${array}    1
    ${day}    Evaluate    str(int('${tmp_day}'))
    ${year}    Get From List    ${array}    2
    Comment    Set Log Level    INFO
    [Return]    ${month}    ${day}    ${year}

select combobox single selection
    [Arguments]    ${cboselection}    ${cboselectiondata}    ${sglselection}
    [Documentation]    ${cboselection}: combox selection
    ...    ${selectiondata}: naming data of the combox selection
    ...    ${selection}: data set selection
    wait loading
    Wait Until Element Is Visible    ${cboselection}    30
    Click Element    ${cboselection}
    wait loading
    Wait Until Element Is Visible    ${cboselectiondata}//following-sibling::*[normalize-space(text())="${sglselection}"]
    ${att_cboselectiondata_aria-selected}    Does Attribute Exist    ${cboselectiondata}//following-sibling::*[normalize-space(text())="${sglselection}"]/..    aria-selected
    ${att_cbcselectiondata_class}    Selenium2Library.Get Element Attribute    ${cboselectiondata}//following-sibling::*[normalize-space(text())="${sglselection}"]/..    attribute=class
    Run Keyword Unless    ${att_cboselectiondata_aria-selected} and "${att_cbcselectiondata_class}"=="ui-corner-all ui-state-active ui-state-hover"    Click Element    ${cboselectiondata}//following-sibling::*[normalize-space(text())="${sglselection}"]
    wait loading

select combobox checkbox selection
    [Arguments]    ${cbcselection}    ${cbcselectiondata}    ${chkselection}    ${ischeck}=1    ${isclose}=0
    [Documentation]    ${cboselection}: combox selection
    ...    ${selectiondata}: naming data of the combox selection
    ...    ${selection}: data set selection
    ...    ${ischeck}: 0 - uncheck checkbox, 1 - check checkbox
    ...    ${isclose}: 0 - don't close data dropdown list, 1 - close data dropdown list
    wait loading
    Wait Until Element Is Visible    ${cbcselection}    30
    ${tmp_cbcselection}    Replace String    ${cbcselection}    *//span[2]    button    -1
    ${att_cbcselection_class}    Selenium2Library.Get Element Attribute    ${tmp_cbcselection}    attribute=class
    Run Keyword Unless    "${att_cbcselection_class}"=="ui-multiselect ui-widget ui-state-default ui-state-hover ui-state-active" or "${att_cbcselection_class}"=="ui-multiselect ui-widget ui-state-default ui-state-active"    Click Element    ${cbcselection}
    wait loading
    ${ischeck}    Set Variable If    "${ischeck}"=="1"    true    false
    Wait Until Element Is Visible    ${cbcselectiondata}/following-sibling::span[normalize-space(text())="${chkselection}"]
    ${att_cbcselectiondata_aria-selected}    Selenium2Library.Get Element Attribute    ${cbcselectiondata}/following-sibling::span[normalize-space(text())="${chkselection}"]/preceding-sibling::input    aria-selected
    ${att_cbcselectiondata_aria-selected}    Set Variable If    "${att_cbcselectiondata_aria-selected}"=="${null}"    false    ${att_cbcselectiondata_aria-selected}
    Run Keyword Unless    "${att_cbcselectiondata_aria-selected}"=="${ischeck}"    Click Element    ${cbcselectiondata}/following-sibling::span[normalize-space(text())="${chkselection}"]
    Log    Check/Uncheck="${ischeck}" for "${chkselection}"
    Run Keyword If    "${isclose}"=="1"    Click Element    ${cbcselection}
    wait loading

check export to excel filename_getdate
    [Arguments]    ${locator}    ${filename}
    [Documentation]    ${locator}: location of export to excel icon
    ...    ${filename} : filename of excel (Bettype_Monthly_Performance)
    ...    ex: Bettype_Monthly_Performance_[year,month,day].xlsx
    ...    1. Click export to excel file
    ...    2. Check exist excel file
    # Click export to excel
    wait loading
    ${tmp_btnexporttoexcel}    Is Element Visible    ${locator}    0
    Run Keyword If    ${tmp_btnexporttoexcel}    click control    ${locator}
    # Check exist excel file
    wait loading
    ${datefile}    Get Time    year,month,day    UTC - 4 hour
    ${datefile}    Evaluate    "".join(${datefile})
    ${fullfilename}    Set Variable    ${filename}_${datefile}.xlsx
    Remove Files    Auto_Reports\\${fullfilename}
    Wait Until Keyword Succeeds    2min    3s    File Should Exist    Auto_Reports\\${fullfilename}

check export to excel filename_fromdate_todate
    [Arguments]    ${locator}    ${filename}    ${fromdate}    ${todate}
    [Documentation]    ${locator}: location of export to excel icon
    ...    ${filename} : filename of excel (Bettype_Monthly_Performance)
    ...    ex: Bettype_Monthly_Performance_[year,month,day].xlsx
    ...    1. Click export to excel file
    ...    2. Check exist excel file
    # Click export to excel
    wait loading
    ${tmp_btnexporttoexcel}    Is Element Visible    ${locator}    0
    Run Keyword If    ${tmp_btnexporttoexcel}    click control    ${locator}
    # Check exist excel file
    wait loading
    ${fromdate}    Evaluate    '${fromdate}'.split('/')
    ${year}    Get From List    ${fromdate}    2
    ${month}    Get From List    ${fromdate}    0
    ${day}    Get From List    ${fromdate}    1
    ${fromdate}    Evaluate    ${year}${month}${day}
    ${todate}    Evaluate    '${todate}'.split('/')
    ${year}    Get From List    ${todate}    2
    ${month}    Get From List    ${todate}    0
    ${day}    Get From List    ${todate}    1
    ${todate}    Evaluate    ${year}${month}${day}
    ${fullfilename}    Set Variable    ${filename}_${fromdate}_${todate}.xls
    Remove Files    Auto_Reports\\${fullfilename}
    Wait Until Keyword Succeeds    2min    3s    File Should Exist    Auto_Reports\\${fullfilename}
