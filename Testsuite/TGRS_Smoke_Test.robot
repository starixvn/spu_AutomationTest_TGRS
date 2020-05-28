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
Resource          ../Interface/02_Reports/in_rpt_trader-traderadminview.robot
Resource          ../Interface/02_Reports/in_rpt_bettypemontlyperf.robot
Resource          ../Interface/02_Reports/in_rpt_perfsummary.robot

*** Variables ***

*** Test Cases ***
TC_00_Login_System
    [Documentation]    Created by: 20200520@John.Ngo
    ...    Revisions:
    ...    - 20200520@John.Ngo: Create new [RedmineId: #134230]
    ...
    ...    Login TGRS System
    ${ff_profile_dir}    Set Variable    Auto_Reports\\
    build ff profile    ${ff_profile_dir}
    Set Selenium Speed    0
    #Open Browser    ${EMPTY}    ${ds_lg_browser}    ff_profile_dir=${ff_profile_dir}
    Open Browser In Chrome    about:blank    ${ff_profile_dir}    chrome    ${False}
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
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    click control    ${in_rp_td_btnday}
    # Test
    ${tmp_date}    Set Variable    12/24/2020
    split day month year    ${tmp_date}
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
    # Check element exist
    ${rp_td_noofmatches}    Get Text    ${in_rp_td_noofmatches}
    Should Be True    '${rp_td_noofmatches}'
    Run Keyword And Continue On Failure    Element Should Be Visible    ${in_rp_td_bettypeperf_grandtotal}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${in_rp_td_leagueperf_grandtotal}
    wait loading
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_bm_nodata}
    click control    ${in_rp_td_leagueperf_lnknoofmatch}
    wait loading
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_bm_nodata}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${in_rp_td_leagueperf_matchperf_grandtotal}
    wait loading
    click control    ${in_rp_td_leagueperf_matchperf_lnkmatch}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_bm_nodata}
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
    select combobox single selection    ${in_rp_bm_cboyear}    ${in_rp_mf_yeardata}    ${ds_rp_mf_bm_year}
    # Click uncheck all bettype
    click control    ${in_rp_bm_cbcbettype}
    click control    ${in_rp_bm_cbcbettype_uncheckall}
    select combobox checkbox selection    ${in_rp_bm_cbcbettype}    ${in_rp_mf_bettypedata}    ${ds_rp_mf_bm_bettype_1sthdp}
    select combobox checkbox selection    ${in_rp_bm_cbcbettype}    ${in_rp_mf_bettypedata}    ${ds_rp_mf_bm_bettype_hdp}
    select combobox checkbox selection    ${in_rp_bm_cbcbettype}    ${in_rp_mf_bettypedata}    ${ds_rp_mf_bm_bettype_1stou}
    select combobox checkbox selection    ${in_rp_bm_cbcbettype}    ${in_rp_mf_bettypedata}    ${ds_rp_mf_bm_bettype_ou}
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_mf_columnsdata}    ${ds_rp_mf_bm_columns_1sthalfyear}    0
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_mf_columnsdata}    ${ds_rp_mf_bm_columns_2ndhalfyear}    0
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_mf_columnsdata}    ${ds_rp_mf_bm_columns_fullyear}    0
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_mf_columnsdata}    ${ds_rp_mf_bm_columns_jan}    1
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_mf_columnsdata}    ${ds_rp_mf_bm_columns_dec}    1
    click control    ${in_rp_mf_btngenerate}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_bm_nodata}
    wait loading
    # Click check all bettype
    click control    ${in_rp_bm_cbcbettype}
    click control    ${in_rp_bm_cbcbettype_checkall}
    click control    ${in_rp_mf_btngenerate}
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_mf_columnsdata}    ${ds_rp_mf_bm_columns_1sthalfyear}    1
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_mf_columnsdata}    ${ds_rp_mf_bm_columns_2ndhalfyear}    1
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_mf_columnsdata}    ${ds_rp_mf_bm_columns_fullyear}    1
    wait loading
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_bm_nodata}
    check function export to excel file    ${in_rp_bm_btnexporttoexcel}    Bettype_Monthly_Performance

TC_03_Reports_PerformanceSummary
    [Documentation]    Created by: 20200526@John.Ngo
    ...    Revisions:
    ...    - 20200526@John.Ngo: Create new [RedmineId: #134230]
    ...
    ...    Performance Summary Report:
    ...    1. Navigate to report
    ...    2. Select date and click Generate button
    ...    3. Check title 'Team Performance', 'Top 5 winning leagues', 'Top 5 losing leagues' and 'Bet Type Performance'
    # Navigate to Report
    wait loading
    go to url    ${ds_lg_url}    ${ds_lg_env}    ${ds_rp_perfsummary}
    # Select Filter
    wait loading
    select date    ${in_rp_mf_dt_selectfromdate}    ${ds_rp_mf_dt_fromyear}    ${ds_rp_mf_dt_frommonth}    ${ds_rp_mf_dt_fromday}
    select date    ${in_rp_mf_dt_selecttodate}    ${ds_rp_mf_dt_toyear}    ${ds_rp_mf_dt_tomonth}    ${ds_rp_mf_dt_today}
    wait loading
    click control    ${in_rp_mf_btnSearch}
    # Check element exist
    ${rp_ps_noofmatches}    Get Text    ${in_rp_ps_noofmatches}
    Should Be True    '${rp_ps_noofmatches}'
    Run Keyword And Continue On Failure    Element Should Be Visible    ${in_rp_ps_lnktoptrader}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${in_rp_ps_lnkbottomtrader}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${in_rp_ps_titleteamperf}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${in_rp_ps_titletop5winningleagues}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${in_rp_ps_titletop5losingleagues}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${in_rp_ps_titlebettypeperf}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_bm_nodata}
    click control    ${in_rp_ps_lnktoptrader}
    ${windows}    Get Window Titles
    Select Window    ${windows[1]}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${in_rp_ps_titletoptrader}
    Close Window
    Select Window    ${windows[0]}
    click control    ${in_rp_ps_lnkbottomtrader}
    ${windows}    Get Window Titles
    Select Window    ${windows[1]}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${in_rp_ps_titlebottomtrader}
    Close Window
    Select Window    ${windows[0]}

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
