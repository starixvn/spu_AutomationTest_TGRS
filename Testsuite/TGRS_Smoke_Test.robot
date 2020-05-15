*** Settings ***
Suite Teardown    Close All Browsers
Test Teardown
Library           Selenium2Library
Resource          ../Interface/in_login.robot
Resource          ../Action/ac_main.robot
Resource          ../Dataset/ds_login_local.robot
Resource          ../Dataset/ds_hompage.robot
Resource          ../Interface/in_homepage.robot
Resource          ../Interface/02_Reports/in_rpt_main_filter.robot

*** Variables ***

*** Test Cases ***
TC_Login
    Open Browser    ${ds_lg_urllocal}    gc
    Comment    Maximize Browser Window
    # Login
    login    ${ds_lg_userlocal}    ${ds_lg_passlocal}

TC_Reports_SmokeTest
    # Click on Trader's Report
    select element    ${in_hp_classreports}
    # Click on Trader Report
    select element    ${in_hp_traderreport}
    # Select Month
    select element    ${in_rp_mf_periodtype}
    select element    ${in_rp_mf_periodtype_month}

TC_Reports_PerformanceDetail
    # Click on Report Menu
    select element    ${in_hp_classreports}
    # Click on Performance Detail Report
    select element    ${in_hp_perfdetail}
    select date    ${in_rp_mf_fromdate}    ${ds_rp_mf_fromyear}    ${ds_rp_mf_frommonth}    ${ds_rp_mf_fromday}
    select date    ${in_rp_mf_todate}    ${ds_rp_mf_toyear}    ${ds_rp_mf_tomonth}    ${ds_rp_mf_today}
    # Generate
    select element    ${in_rp_mf_btngenerate}

*** Keywords ***
