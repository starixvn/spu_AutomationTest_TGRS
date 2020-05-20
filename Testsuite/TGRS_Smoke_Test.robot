*** Settings ***
Library           Selenium2Library
Resource          ../Interface/in_login.robot
Resource          ../Action/ac_main.robot
Resource          ../Dataset/ds_login.robot
Resource          ../Dataset/ds_hompage.robot
Resource          ../Dataset/ds_configuration.robot
Resource          ../Dataset/ds_reports.robot
Resource          ../Interface/in_homepage.robot
Resource          ../Interface/02_Reports/in_rpt_main_filter.robot
Resource          ../Interface/02_Reports/in_rpt_traderreport.robot

*** Variables ***

*** Test Cases ***
TC_00_Login_System
    [Documentation]    Created by: 20200520@John.Ngo
    ...    Revisions:
    ...    - 20200520@John.Ngo: Create new [RedmineId: #134230]
    ...
    ...    Login TGRS System
    Set Selenium Speed    0
    Open Browser    ${EMPTY}    ${ds_lg_browser}
    go to url    ${ds_lg_url}    ${ds_lg_env}    ${EMPTY}
    Comment    Maximize Browser Window
    # Login
    login    ${ds_lg_username}    ${ds_lg_password}

TC_01_Reports_Trader-TraderAdminView
    [Documentation]    Created by: 20200520@John.Ngo
    ...    Revisions:
    ...    - 20200520@John.Ngo: Create new [RedmineId: #134230]
    ...
    ...    Trader's Report:
    ...    1. Navigate to Trader Report
    ...    2. Select Period Type: Month -> Select month with dataset and click Search button
    ...    3. Select Day
    ...    4. Check title Bet Type Performance & League Performance
    ...    Trader's Report Admin View:
    ...    1. Navigate to Trader Admin View Report
    ...    2. Input Trader Name
    ...    3. Select Period Type: Date -> Select date with dataset and click Search button
    ...    4. Select Month
    ...    5. Check title 'Bet Type Performance', 'League Performance' and 'Grand Total'
    ...    6. Click Drill-down 'No. Of Matches' and check title 'Grand Total'
    ...    7. Click Drill-down 'Match' and check title 'Grand Total'
    # Navigate to Report
    wait loading
    go to url    ${ds_lg_url}    ${ds_lg_env}    ${ds_rp_traderreport}
    # Select Filter
    wait loading
    click control    ${in_rp_mf_periodtype}
    click control    ${in_rp_mf_periodtype_month}
    wait loading
    select month    ${in_rp_mf_mo_selectfrommonth}    ${ds_rp_mf_mo_fromyear}    ${ds_rp_mf_mo_frommonth}
    select month    ${in_rp_mf_mo_selecttomonth}    ${ds_rp_mf_mo_toyear}    ${ds_rp_mf_mo_tomonth}
    wait loading
    click control    ${in_rp_mf_btnSearch}
    wait loading
    click control    ${in_rp_td_btnday}
    # Test
    ${aa}    Set Variable    12/24/2020
    split day month year    ${aa}
    # Test
    # Navigate to Report
    wait loading
    go to url    ${ds_lg_url}    ${ds_lg_env}    ${ds_rp_traderreportadminview}
    # Select Filter
    wait loading
    Input Text    ${in_rp_td_txttradername}    ${ds_rp_mf_td_tradername}
    click control    ${in_rp_mf_periodtype}
    click control    ${in_rp_mf_periodtype_date}
    wait loading
    select date    ${in_rp_mf_dt_selectfromdate}    ${ds_rp_mf_dt_fromyear}    ${ds_rp_mf_dt_frommonth}    ${ds_rp_mf_dt_fromday}
    select date    ${in_rp_mf_dt_selecttodate}    ${ds_rp_mf_dt_toyear}    ${ds_rp_mf_dt_tomonth}    ${ds_rp_mf_dt_today}
    wait loading
    click control    ${in_rp_mf_btnSearch}
    wait loading
    click control    ${in_rp_td_btnmonth}
    # Check Data
    ${rp_td_noofmatches}    Get Text    ${in_rp_td_noofmatches}
    Should Be True    ${rp_td_noofmatches}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${in_rp_td_bettypeperf_grandtotal}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${in_rp_td_leagueperf_grandtotal}
    wait loading
    click control    ${in_rp_td_leagueperf_lnknoofmatch}
    wait loading
    Run Keyword And Continue On Failure    Element Should Be Visible    ${in_rp_td_leagueperf_matchperf_grandtotal}
    wait loading
    click control    ${in_rp_td_leagueperf_matchperf_lnkmatch}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${in_rp_td_leagueperf_matchperf_bettypeperf_grandtotal}

TC_02_Reports_BetTypeMonthlyPerformance
    [Documentation]    Created by: 20200522@John.Ngo
    ...    Revisions:
    ...    - 20200522@John.Ngo: Create new [RedmineId: #134230]
    ...
    ...    BetType Monthly Performance Report:
    ...    1. Navigate to report
    ...    2. Select year, bettype, columns and click Generate button
    ...    3. Check title 'Bet Type Performance', 'League Performance' and 'Grand Total'
    ...    4. Click Drill-down 'No. Of Matches' and check title 'Grand Total'
    ...    5. Click Drill-down 'Match' and check title 'Grand Total'
    # Navigate to Report
    wait loading
    go to url    ${ds_lg_url}    ${ds_lg_env}    ${ds_rp_bettypemonthlyperf}
    # Select Filter
    wait loading

TC_05_Reports_PerformanceDetail
    [Documentation]    Created by: 20200520@John.Ngo
    ...    Revisions:
    ...    - 20200520@John.Ngo: Create new [RedmineId: #134230]
    ...
    ...    Smoke Test Performance Detail - League
    # Navigate to Report
    go to url    ${ds_lg_url}    ${ds_lg_env}    ${ds_rp_perfdetailbettype}
    # Select Filter
    wait loading
    select date    ${in_rp_mf_dt_selectfromdate}    ${ds_rp_mf_dt_fromyear}    ${ds_rp_mf_dt_frommonth}    ${ds_rp_mf_dt_fromday}
    select date    ${in_rp_mf_dt_selecttodate}    ${ds_rp_mf_dt_toyear}    ${ds_rp_mf_dt_tomonth}    ${ds_rp_mf_dt_today}
    wait loading
    click control    ${in_rp_mf_btngenerate}
    # Check Data

*** Keywords ***
