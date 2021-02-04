*** Settings ***
Library           Selenium2Library
Resource          ../Interface/in_login.robot
Resource          ../Action/ac_main.robot
Resource          ../Dataset/ds_login.robot
Resource          ../Dataset/ds_hompage.robot
Resource          ../Dataset/ds_configuration.robot
Resource          ../Dataset/ds_reports.robot
Resource          ../Interface/in_homepage.robot
Resource          ../Interface/02_Reports/in_rpt_main_filter_general.robot
Resource          ../Interface/02_Reports/in_rpt_trader-traderadminview.robot
Resource          ../Interface/02_Reports/in_rpt_bettypemonthlyperf.robot
Resource          ../Interface/02_Reports/in_rpt_perfsummary.robot
Resource          ../Interface/02_Reports/in_rpt_tradermonthlyperf.robot
Resource          ../Interface/02_Reports/in_rpt_performancedetail_league.robot
Resource          ../Interface/02_Reports/in_rpt_performancedetail_trader.robot
Resource          ../Interface/02_Reports/in_rpt_performancedetail_grade.robot
Resource          ../Interface/02_Reports/in_rpt_performancedetail_team.robot
Resource          ../Interface/02_Reports/in_rpt_performancedetail_bettype.robot
Resource          ../Interface/02_Reports/in_rpt_multiplematchesperformance_trader.robot
Resource          ../Interface/02_Reports/in_rpt_automationtradingperformance_bettype.robot

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
    Maximize Browser Window
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
    select month    ${in_rp_mf_mo_selectfrommonth}    ${ds_rp_mf_mo_fromdate}
    select month    ${in_rp_mf_mo_selecttomonth}    ${ds_rp_mf_mo_todate}
    wait loading
    click control    ${in_rp_mf_btnSearch}
    wait loading
    # Check internal error
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    click control    ${in_rp_td_btnday}
    # Navigate to Report
    wait loading
    go to url    ${ds_lg_url}    ${ds_lg_env}    ${ds_rp_traderreportadminview}
    # Select Filter
    wait loading
    click control    ${in_rp_td_txttradername}
    Input Text    ${in_rp_td_txttradername}    ${ds_rp_mf_td_tradername}
    click control    ${in_rp_mf_periodtype}
    click control    ${in_rp_mf_periodtype_date}
    wait loading
    select date    ${in_rp_mf_dt_selectfromdate}    ${ds_rp_mf_dt_fromdate}
    select date    ${in_rp_mf_dt_selecttodate}    ${ds_rp_mf_dt_todate}
    wait loading
    click control    ${in_rp_mf_btnSearch}
    wait loading
    click control    ${in_rp_td_btnmonth}
    # Check internal error & exist data
    ${rp_td_noofmatches}    Get Text    ${in_rp_td_noofmatches}
    Should Be True    '${rp_td_noofmatches}'
    Run Keyword And Continue On Failure    Element Should Be Visible    ${in_rp_td_bettypeperf_grandtotal}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${in_rp_td_leagueperf_grandtotal}
    wait loading
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_bm_nodata}
    click control    ${in_rp_td_leagueperf_lnknoofmatch}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_bm_nodata}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${in_rp_td_leagueperf_matchperf_grandtotal}
    wait loading
    click control    ${in_rp_td_leagueperf_matchperf_lnkmatch}
    # Check internal error & exist data
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
    select combobox single selection    ${in_rp_bm_cboyear}    ${in_rp_bm_yeardata}    ${ds_rp_mf_year}
    # Click uncheck all bettype
    click control    ${in_rp_bm_cbcbettype}
    click control    ${in_rp_bm_cbcbettype_uncheckall}
    select combobox checkbox selection    ${in_rp_bm_cbcbettype}    ${in_rp_bm_bettypedata}    ${ds_rp_mf_bettype_1sthdp}
    select combobox checkbox selection    ${in_rp_bm_cbcbettype}    ${in_rp_bm_bettypedata}    ${ds_rp_mf_bettype_hdp}
    select combobox checkbox selection    ${in_rp_bm_cbcbettype}    ${in_rp_bm_bettypedata}    ${ds_rp_mf_bettype_1stou}
    select combobox checkbox selection    ${in_rp_bm_cbcbettype}    ${in_rp_bm_bettypedata}    ${ds_rp_mf_bettype_ou}
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_1sthalfyear}    0
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_2ndhalfyear}    0
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_fullyear}    0
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_jan}    1
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_feb}    1
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_mar}    1
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_apr}    1
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_may}    1
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_jun}    1
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_jul}    1
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_aug}    1
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_sep}    1
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_oct}    1
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_nov}    1
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_dec}    1    1
    click control    ${in_rp_mf_btngenerate}
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_bm_nodata}
    check export to excel filename_getdate    ${in_rp_bm_btnexporttoexcel}    Bettype_Monthly_Performance
    wait loading
    # Click check all bettype
    click control    ${in_rp_bm_cbcbettype}
    click control    ${in_rp_bm_cbcbettype_checkall}
    click control    ${in_rp_mf_btngenerate}
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_1sthalfyear}    1
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_2ndhalfyear}    1
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_fullyear}    1
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_jan}    0
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_feb}    0
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_mar}    0
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_apr}    0
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_may}    0
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_jun}    0
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_jul}    0
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_aug}    0
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_sep}    0
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_oct}    0
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_nov}    0
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_dec}    0    1
    click control    ${in_rp_mf_btngenerate}
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_bm_nodata}

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
    select date    ${in_rp_mf_dt_selectfromdate}    ${ds_rp_mf_dt_fromdate}
    select date    ${in_rp_mf_dt_selecttodate}    ${ds_rp_mf_dt_todate}
    wait loading
    click control    ${in_rp_mf_btnSearch}
    # Check internal error & exist data
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
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Be Visible    ${in_rp_ps_titletoptrader}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_bm_nodata}
    Close Window
    Select Window    ${windows[0]}
    click control    ${in_rp_ps_lnkbottomtrader}
    ${windows}    Get Window Titles
    Select Window    ${windows[1]}
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Be Visible    ${in_rp_ps_titlebottomtrader}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_bm_nodata}
    Close Window
    Select Window    ${windows[0]}

TC_04_Reports_TraderMonthlyPerformance
    [Documentation]    Created by: 20200529@John.Ngo
    ...    Revisions:
    ...    - 20200529@John.Ngo: Create new [RedmineId: #134230]
    ...
    ...    Smoke Test Trader Monthy Performance
    # Navigate to Report
    wait loading
    go to url    ${ds_lg_url}    ${ds_lg_env}    ${ds_rp_tradermonthlyperf}
    # Select Filter
    wait loading
    select combobox single selection    ${in_rp_tm_cboyear}    ${in_rp_tm_yeardata}    ${ds_rp_mf_year}
    select combobox single selection    ${in_rp_tm_cboproduct}    ${in_rp_tm_productdata}    ${ds_rp_mf_tm_product_hdp}
    click control    ${in_rp_tm_txtleague}
    Input Text    ${in_rp_tm_txtleague}    ${ds_rp_mf_tm_league}
    select combobox single selection    ${in_rp_tm_cboshift}    ${in_rp_tm_shiftdata}    ${ds_rp_mf_tm_shift_afternoonS2}
    select combobox single selection    ${in_rp_tm_cbograde}    ${in_rp_tm_gradedata}    ${ds_rp_mf_tm_grade_2}
    Input Text    ${in_rp_tm_txttrader}    ${ds_rp_mf_tm_trader}
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_fullyear}    0
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_previousyear}    0    1
    click control    ${in_rp_mf_btngenerate}
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_tm_nodata}
    check export to excel filename_getdate    ${in_rp_tm_btnexporttoexcel}    Trader_Monthly_Performance
    # Select Filter
    wait loading
    select combobox single selection    ${in_rp_tm_cboyear}    ${in_rp_tm_yeardata}    ${ds_rp_mf_year}
    select combobox single selection    ${in_rp_tm_cboproduct}    ${in_rp_tm_productdata}    ${ds_rp_mf_tm_product_all}
    click control    ${in_rp_tm_txtleague}
    Clear Element Text    ${in_rp_tm_txtleague}
    select combobox single selection    ${in_rp_tm_cboshift}    ${in_rp_tm_shiftdata}    ${ds_rp_mf_tm_shift_all}
    select combobox single selection    ${in_rp_tm_cbograde}    ${in_rp_tm_gradedata}    ${ds_rp_mf_tm_grade_all}
    Clear Element Text    ${in_rp_tm_txttrader}
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_fullyear}    1
    select combobox checkbox selection    ${in_rp_bm_cbccolumns}    ${in_rp_bm_columnsdata}    ${ds_rp_mf_columns_previousyear}    1    1
    click control    ${in_rp_mf_btngenerate}
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_tm_nodata}

TC_05_Reports_PerformanceDetail_League
    [Documentation]    Created by: 20200602@John.Ngo
    ...    Revisions:
    ...    - 20200602@John.Ngo: Create new [RedmineId: #134230]
    ...
    ...    Smoke Test Performance Detail - League
    # Navigate to Report
    go to url    ${ds_lg_url}    ${ds_lg_env}    ${ds_rp_perfdetailleague}
    # Select Filter
    wait loading
    select combobox single selection    ${in_rp_pd_lg_cbomarket}    ${in_rp_pd_lg_cbomarket}    ${ds_rp_mf_pd_market_live}
    wait loading
    click control    ${in_rp_mf_periodtype}
    click control    ${in_rp_mf_periodtype_month}
    wait loading
    select month    ${in_rp_mf_mo_selectfrommonth}    ${ds_rp_mf_mo_fromdate}
    select month    ${in_rp_mf_mo_selecttomonth}    ${ds_rp_mf_mo_todate}
    click control    ${in_rp_pd_lg_cbobettype}
    click control    ${in_rp_pd_lg_cbobettype_uncheckall}
    select combobox checkbox selection    ${in_rp_pd_lg_cbobettype}    ${in_rp_pd_lg_bettypedata}    ${ds_rp_mf_bettype_1sthdp}
    select combobox checkbox selection    ${in_rp_pd_lg_cbobettype}    ${in_rp_pd_lg_bettypedata}    ${ds_rp_mf_bettype_hdp}
    select combobox checkbox selection    ${in_rp_pd_lg_cbobettype}    ${in_rp_pd_lg_bettypedata}    ${ds_rp_mf_bettype_1stou}
    select combobox checkbox selection    ${in_rp_pd_lg_cbobettype}    ${in_rp_pd_lg_bettypedata}    ${ds_rp_mf_bettype_ou}    1    1
    click control    ${in_rp_pd_lg_txtminimumturnover}
    Input Text    ${in_rp_pd_lg_txtminimumturnover}    ${ds_rp_mf_pd_minimumturnover}
    click control    ${in_rp_pd_lg_txtminimumwinloss}
    Input Text    ${in_rp_pd_lg_txtminimumwinloss}    ${ds_rp_mf_pd_minimumwinloss}
    click control    ${in_rp_pd_lg_txtmarginfrom}
    Input Text    ${in_rp_pd_lg_txtmarginfrom}    ${ds_rp_mf_pd_marginfrom}
    click control    ${in_rp_pd_lg_txtmarginto}
    Input Text    ${in_rp_pd_lg_txtmarginto}    ${ds_rp_mf_pd_marginto}
    click control    ${in_rp_pd_lg_txtleague}
    Input Text    ${in_rp_pd_lg_txtleague}    ${ds_rp_mf_pd_league}
    wait loading
    click control    ${in_rp_mf_btngenerate}
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_lg_nodata}
    check export to excel filename_fromdate_todate    ${in_rp_pd_lg_btnexporttoexcel}    Performance_Detail_League    ${ds_rp_mf_mo_fromdate}    ${ds_rp_mf_mo_todate}
    # Select Filter
    wait loading
    select combobox single selection    ${in_rp_pd_lg_cbomarket}    ${in_rp_pd_lg_cbomarket}    ${ds_rp_mf_pd_market_all}
    wait loading
    click control    ${in_rp_mf_periodtype}
    click control    ${in_rp_mf_periodtype_date}
    wait loading
    select date    ${in_rp_mf_dt_selectfromdate}    ${ds_rp_mf_dt_fromdate}
    select date    ${in_rp_mf_dt_selecttodate}    ${ds_rp_mf_dt_todate}
    click control    ${in_rp_pd_lg_cbobettype}
    click control    ${in_rp_pd_lg_cbobettype_checkall}
    select combobox checkbox selection    ${in_rp_pd_lg_cbobettype}    ${in_rp_pd_lg_bettypedata}    ${ds_rp_mf_bettype_1sthdp}
    select combobox checkbox selection    ${in_rp_pd_lg_cbobettype}    ${in_rp_pd_lg_bettypedata}    ${ds_rp_mf_bettype_hdp}
    select combobox checkbox selection    ${in_rp_pd_lg_cbobettype}    ${in_rp_pd_lg_bettypedata}    ${ds_rp_mf_bettype_1stou}
    select combobox checkbox selection    ${in_rp_pd_lg_cbobettype}    ${in_rp_pd_lg_bettypedata}    ${ds_rp_mf_bettype_ou}    1    1
    click control    ${in_rp_pd_lg_txtminimumturnover}
    Clear Element Text    ${in_rp_pd_lg_txtminimumturnover}
    click control    ${in_rp_pd_lg_txtminimumwinloss}
    Clear Element Text    ${in_rp_pd_lg_txtminimumwinloss}
    click control    ${in_rp_pd_lg_txtmarginfrom}
    Clear Element Text    ${in_rp_pd_lg_txtmarginfrom}
    click control    ${in_rp_pd_lg_txtmarginto}
    Clear Element Text    ${in_rp_pd_lg_txtmarginto}
    click control    ${in_rp_pd_lg_txtleague}
    Clear Element Text    ${in_rp_pd_lg_txtleague}
    wait loading
    click control    ${in_rp_mf_btngenerate}
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_lg_nodata}
    click control    ${in_rp_pd_lg_leagueperf_lnknooftrader}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_lg_nodata}
    click control    ${in_rp_pd_lg_leagueperf_traderperf_lnknoofmatches}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_lg_nodata}
    click control    ${in_rp_pd_lg_leagueperf_traderperf_matchperf_lnkmatch}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_lg_nodata}
    click control    ${in_rp_pd_lg_breakcrumb_leagueperf}
    click control    ${in_rp_pd_lg_leagueperf_lnknoofmatch}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_lg_nodata}
    click control    ${in_rp_pd_lg_leagueperf_matchperf_lnkmatch}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_lg_nodata}

TC_06_Reports_PerformanceDetail_Trader
    [Documentation]    Created by: 20200603@John.Ngo
    ...    Revisions:
    ...    - 20200603@John.Ngo: Create new [RedmineId: #134230]
    ...
    ...    Smoke Test Performance Detail - Trader
    # Navigate to Report
    go to url    ${ds_lg_url}    ${ds_lg_env}    ${ds_rp_perfdetailtrader}
    # Select Filter
    wait loading
    select combobox single selection    ${in_rp_pd_td_cbomarket}    ${in_rp_pd_td_cbomarket}    ${ds_rp_mf_pd_market_live}
    wait loading
    click control    ${in_rp_mf_periodtype}
    click control    ${in_rp_mf_periodtype_month}
    wait loading
    select month    ${in_rp_mf_mo_selectfrommonth}    ${ds_rp_mf_mo_fromdate}
    select month    ${in_rp_mf_mo_selecttomonth}    ${ds_rp_mf_mo_todate}
    click control    ${in_rp_pd_td_cbobettype}
    click control    ${in_rp_pd_td_cbobettype_uncheckall}
    select combobox checkbox selection    ${in_rp_pd_td_cbobettype}    ${in_rp_pd_td_bettypedata}    ${ds_rp_mf_bettype_1sthdp}
    select combobox checkbox selection    ${in_rp_pd_td_cbobettype}    ${in_rp_pd_td_bettypedata}    ${ds_rp_mf_bettype_hdp}
    select combobox checkbox selection    ${in_rp_pd_td_cbobettype}    ${in_rp_pd_td_bettypedata}    ${ds_rp_mf_bettype_1stou}
    select combobox checkbox selection    ${in_rp_pd_td_cbobettype}    ${in_rp_pd_td_bettypedata}    ${ds_rp_mf_bettype_ou}    1    1
    click control    ${in_rp_pd_td_txtminimumturnover}
    Input Text    ${in_rp_pd_td_txtminimumturnover}    ${ds_rp_mf_pd_minimumturnover}
    click control    ${in_rp_pd_td_txtminimumwinloss}
    Input Text    ${in_rp_pd_td_txtminimumwinloss}    ${ds_rp_mf_pd_minimumwinloss}
    click control    ${in_rp_pd_td_txtmarginfrom}
    Input Text    ${in_rp_pd_td_txtmarginfrom}    ${ds_rp_mf_pd_marginfrom}
    click control    ${in_rp_pd_td_txtmarginto}
    Input Text    ${in_rp_pd_td_txtmarginto}    ${ds_rp_mf_pd_marginto}
    click control    ${in_rp_pd_td_txttrader}
    Input Text    ${in_rp_pd_td_txttrader}    ${ds_rp_mf_pd_trader}
    wait loading
    click control    ${in_rp_mf_btngenerate}
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_td_nodata}
    check export to excel filename_fromdate_todate    ${in_rp_pd_td_btnexporttoexcel}    Performance_Detail_Trader    ${ds_rp_mf_mo_fromdate}    ${ds_rp_mf_mo_todate}
    # Select Filter
    wait loading
    select combobox single selection    ${in_rp_pd_td_cbomarket}    ${in_rp_pd_td_cbomarket}    ${ds_rp_mf_pd_market_all}
    wait loading
    click control    ${in_rp_mf_periodtype}
    click control    ${in_rp_mf_periodtype_date}
    wait loading
    select date    ${in_rp_mf_dt_selectfromdate}    ${ds_rp_mf_dt_fromdate}
    select date    ${in_rp_mf_dt_selecttodate}    ${ds_rp_mf_dt_todate}
    click control    ${in_rp_pd_td_cbobettype}
    click control    ${in_rp_pd_td_cbobettype_checkall}
    select combobox checkbox selection    ${in_rp_pd_td_cbobettype}    ${in_rp_pd_td_bettypedata}    ${ds_rp_mf_bettype_1sthdp}
    select combobox checkbox selection    ${in_rp_pd_td_cbobettype}    ${in_rp_pd_td_bettypedata}    ${ds_rp_mf_bettype_hdp}
    select combobox checkbox selection    ${in_rp_pd_td_cbobettype}    ${in_rp_pd_td_bettypedata}    ${ds_rp_mf_bettype_1stou}
    select combobox checkbox selection    ${in_rp_pd_td_cbobettype}    ${in_rp_pd_td_bettypedata}    ${ds_rp_mf_bettype_ou}    1    1
    click control    ${in_rp_pd_td_txtminimumturnover}
    Clear Element Text    ${in_rp_pd_td_txtminimumturnover}
    click control    ${in_rp_pd_td_txtminimumwinloss}
    Clear Element Text    ${in_rp_pd_td_txtminimumwinloss}
    click control    ${in_rp_pd_td_txtmarginfrom}
    Clear Element Text    ${in_rp_pd_td_txtmarginfrom}
    click control    ${in_rp_pd_td_txtmarginto}
    Clear Element Text    ${in_rp_pd_td_txtmarginto}
    click control    ${in_rp_pd_td_txttrader}
    Clear Element Text    ${in_rp_pd_td_txttrader}
    wait loading
    click control    ${in_rp_mf_btngenerate}
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_td_nodata}
    click control    ${in_rp_pd_td_traderperf_live_lnknoofmatch}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_lg_nodata}
    click control    ${in_rp_pd_td_traderperf_matchperf_lnkmatch}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_lg_nodata}

TC_07_Reports_PerformanceDetail_Grade
    [Documentation]    Created by: 20200605@John.Ngo
    ...    Revisions:
    ...    - 20200605@John.Ngo: Create new [RedmineId: #134230]
    ...
    ...    Smoke Test Performance Detail - Grade
    # Navigate to Report
    go to url    ${ds_lg_url}    ${ds_lg_env}    ${ds_rp_perfdetailgrade}
    # Select Filter
    wait loading
    select combobox single selection    ${in_rp_pd_gr_cbomarket}    ${in_rp_pd_gr_cbomarket}    ${ds_rp_mf_pd_market_live}
    wait loading
    click control    ${in_rp_mf_periodtype}
    click control    ${in_rp_mf_periodtype_month}
    wait loading
    select month    ${in_rp_mf_mo_selectfrommonth}    ${ds_rp_mf_mo_fromdate}
    select month    ${in_rp_mf_mo_selecttomonth}    ${ds_rp_mf_mo_todate}
    click control    ${in_rp_pd_gr_cbobettype}
    click control    ${in_rp_pd_gr_cbobettype_uncheckall}
    select combobox checkbox selection    ${in_rp_pd_gr_cbobettype}    ${in_rp_pd_gr_bettypedata}    ${ds_rp_mf_bettype_1sthdp}
    select combobox checkbox selection    ${in_rp_pd_gr_cbobettype}    ${in_rp_pd_gr_bettypedata}    ${ds_rp_mf_bettype_hdp}
    select combobox checkbox selection    ${in_rp_pd_gr_cbobettype}    ${in_rp_pd_gr_bettypedata}    ${ds_rp_mf_bettype_1stou}
    select combobox checkbox selection    ${in_rp_pd_gr_cbobettype}    ${in_rp_pd_gr_bettypedata}    ${ds_rp_mf_bettype_ou}    1    1
    click control    ${in_rp_pd_gr_txtminimumturnover}
    Input Text    ${in_rp_pd_gr_txtminimumturnover}    ${ds_rp_mf_pd_minimumturnover}
    click control    ${in_rp_pd_gr_txtminimumwinloss}
    Input Text    ${in_rp_pd_gr_txtminimumwinloss}    ${ds_rp_mf_pd_minimumwinloss}
    click control    ${in_rp_pd_gr_txtmarginfrom}
    Input Text    ${in_rp_pd_gr_txtmarginfrom}    ${ds_rp_mf_pd_marginfrom}
    click control    ${in_rp_pd_gr_txtmarginto}
    Input Text    ${in_rp_pd_gr_txtmarginto}    ${ds_rp_mf_pd_marginto}
    wait loading
    click control    ${in_rp_mf_btngenerate}
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_gr_nodata}
    check export to excel filename_fromdate_todate    ${in_rp_pd_gr_btnexporttoexcel}    Performance_Detail_Grade    ${ds_rp_mf_mo_fromdate}    ${ds_rp_mf_mo_todate}
    # Select Filter
    wait loading
    select combobox single selection    ${in_rp_pd_gr_cbomarket}    ${in_rp_pd_gr_cbomarket}    ${ds_rp_mf_pd_market_all}
    wait loading
    click control    ${in_rp_mf_periodtype}
    click control    ${in_rp_mf_periodtype_date}
    wait loading
    select date    ${in_rp_mf_dt_selectfromdate}    ${ds_rp_mf_dt_fromdate}
    select date    ${in_rp_mf_dt_selecttodate}    ${ds_rp_mf_dt_todate}
    click control    ${in_rp_pd_gr_cbobettype}
    click control    ${in_rp_pd_gr_cbobettype_checkall}
    select combobox checkbox selection    ${in_rp_pd_gr_cbobettype}    ${in_rp_pd_gr_bettypedata}    ${ds_rp_mf_bettype_1sthdp}
    select combobox checkbox selection    ${in_rp_pd_gr_cbobettype}    ${in_rp_pd_gr_bettypedata}    ${ds_rp_mf_bettype_hdp}
    select combobox checkbox selection    ${in_rp_pd_gr_cbobettype}    ${in_rp_pd_gr_bettypedata}    ${ds_rp_mf_bettype_1stou}
    select combobox checkbox selection    ${in_rp_pd_gr_cbobettype}    ${in_rp_pd_gr_bettypedata}    ${ds_rp_mf_bettype_ou}    1    1
    click control    ${in_rp_pd_gr_txtminimumturnover}
    Clear Element Text    ${in_rp_pd_gr_txtminimumturnover}
    click control    ${in_rp_pd_gr_txtminimumwinloss}
    Clear Element Text    ${in_rp_pd_gr_txtminimumwinloss}
    click control    ${in_rp_pd_gr_txtmarginfrom}
    Clear Element Text    ${in_rp_pd_gr_txtmarginfrom}
    click control    ${in_rp_pd_gr_txtmarginto}
    Clear Element Text    ${in_rp_pd_gr_txtmarginto}
    wait loading
    click control    ${in_rp_mf_btngenerate}
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_gr_nodata}
    click control    ${in_rp_pd_gr_gradeperf_live_lnknooftraders}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_gr_nodata}
    click control    ${in_rp_pd_gr_gradeperf_traderperf_lnknoofmatches}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_gr_nodata}
    click control    ${in_rp_pd_gr_gradeperf_traderperf_matchperf_lnkmatch}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_gr_nodata}
    click control    ${in_rp_pd_gr_breakcrumb_gradeperf}
    click control    ${in_rp_pd_gr_gradeperf_live_lnknoofleagues}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_gr_nodata}
    click control    ${in_rp_pd_gr_gradeperf_leagueperf_lnknooftraders}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_gr_nodata}
    click control    ${in_rp_pd_gr_gradeperf_leagueperf_traderperf_lnknoofmatches}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_gr_nodata}
    click control    ${in_rp_pd_gr_gradeperf_leagueperf_traderperf_matchperf_lnkmatch}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_gr_nodata}

TC_08_Reports_PerformanceDetail_Team
    [Documentation]    Created by: 20200605@John.Ngo
    ...    Revisions:
    ...    - 20200605@John.Ngo: Create new [RedmineId: #134230]
    ...
    ...    Smoke Test Performance Detail - Team
    # Navigate to Report
    go to url    ${ds_lg_url}    ${ds_lg_env}    ${ds_rp_perfdetailteam}
    # Select Filter
    wait loading
    select combobox single selection    ${in_rp_pd_te_cbomarket}    ${in_rp_pd_te_cbomarket}    ${ds_rp_mf_pd_market_live}
    wait loading
    click control    ${in_rp_mf_periodtype}
    click control    ${in_rp_mf_periodtype_month}
    wait loading
    select month    ${in_rp_mf_mo_selectfrommonth}    ${ds_rp_mf_mo_fromdate}
    select month    ${in_rp_mf_mo_selecttomonth}    ${ds_rp_mf_mo_todate}
    click control    ${in_rp_pd_te_cbobettype}
    click control    ${in_rp_pd_te_cbobettype_uncheckall}
    select combobox checkbox selection    ${in_rp_pd_te_cbobettype}    ${in_rp_pd_te_bettypedata}    ${ds_rp_mf_bettype_1sthdp}
    select combobox checkbox selection    ${in_rp_pd_te_cbobettype}    ${in_rp_pd_te_bettypedata}    ${ds_rp_mf_bettype_hdp}
    select combobox checkbox selection    ${in_rp_pd_te_cbobettype}    ${in_rp_pd_te_bettypedata}    ${ds_rp_mf_bettype_1stou}
    select combobox checkbox selection    ${in_rp_pd_te_cbobettype}    ${in_rp_pd_te_bettypedata}    ${ds_rp_mf_bettype_ou}    1    1
    click control    ${in_rp_pd_te_txtminimumturnover}
    Input Text    ${in_rp_pd_te_txtminimumturnover}    ${ds_rp_mf_pd_minimumturnover}
    click control    ${in_rp_pd_te_txtminimumwinloss}
    Input Text    ${in_rp_pd_te_txtminimumwinloss}    ${ds_rp_mf_pd_minimumwinloss}
    click control    ${in_rp_pd_te_txtmarginfrom}
    Input Text    ${in_rp_pd_te_txtmarginfrom}    ${ds_rp_mf_pd_marginfrom}
    click control    ${in_rp_pd_te_txtmarginto}
    Input Text    ${in_rp_pd_te_txtmarginto}    ${ds_rp_mf_pd_marginto}
    click control    ${in_rp_pd_te_cboteam}
    click control    ${in_rp_pd_te_cboteam_uncheckall}
    select combobox checkbox selection    ${in_rp_pd_te_cboteam}    ${in_rp_pd_te_teamdata}    ${ds_rp_mf_pd_team_clg}
    select combobox checkbox selection    ${in_rp_pd_te_cboteam}    ${in_rp_pd_te_teamdata}    ${ds_rp_mf_pd_team_supportteam}
    select combobox checkbox selection    ${in_rp_pd_te_cboteam}    ${in_rp_pd_te_teamdata}    ${ds_rp_mf_pd_team_nonliveteam}    1    1
    wait loading
    click control    ${in_rp_mf_btngenerate}
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_te_nodata}
    check export to excel filename_fromdate_todate    ${in_rp_pd_te_btnexporttoexcel}    Performance_Detail_Team    ${ds_rp_mf_mo_fromdate}    ${ds_rp_mf_mo_todate}
    # Select Filter
    wait loading
    select combobox single selection    ${in_rp_pd_te_cbomarket}    ${in_rp_pd_te_cbomarket}    ${ds_rp_mf_pd_market_all}
    wait loading
    click control    ${in_rp_mf_periodtype}
    click control    ${in_rp_mf_periodtype_date}
    wait loading
    select date    ${in_rp_mf_dt_selectfromdate}    ${ds_rp_mf_dt_fromdate}
    select date    ${in_rp_mf_dt_selecttodate}    ${ds_rp_mf_dt_todate}
    click control    ${in_rp_pd_te_cbobettype}
    click control    ${in_rp_pd_te_cbobettype_checkall}
    select combobox checkbox selection    ${in_rp_pd_te_cbobettype}    ${in_rp_pd_te_bettypedata}    ${ds_rp_mf_bettype_1sthdp}
    select combobox checkbox selection    ${in_rp_pd_te_cbobettype}    ${in_rp_pd_te_bettypedata}    ${ds_rp_mf_bettype_hdp}
    select combobox checkbox selection    ${in_rp_pd_te_cbobettype}    ${in_rp_pd_te_bettypedata}    ${ds_rp_mf_bettype_1stou}
    select combobox checkbox selection    ${in_rp_pd_te_cbobettype}    ${in_rp_pd_te_bettypedata}    ${ds_rp_mf_bettype_ou}    1    1
    click control    ${in_rp_pd_te_txtminimumturnover}
    Clear Element Text    ${in_rp_pd_te_txtminimumturnover}
    click control    ${in_rp_pd_te_txtminimumwinloss}
    Clear Element Text    ${in_rp_pd_te_txtminimumwinloss}
    click control    ${in_rp_pd_te_txtmarginfrom}
    Clear Element Text    ${in_rp_pd_te_txtmarginfrom}
    click control    ${in_rp_pd_te_txtmarginto}
    Clear Element Text    ${in_rp_pd_te_txtmarginto}
    click control    ${in_rp_pd_te_cboteam}
    click control    ${in_rp_pd_te_cboteam_checkall}
    select combobox checkbox selection    ${in_rp_pd_te_cboteam}    ${in_rp_pd_te_teamdata}    ${ds_rp_mf_pd_team_clg}
    select combobox checkbox selection    ${in_rp_pd_te_cboteam}    ${in_rp_pd_te_teamdata}    ${ds_rp_mf_pd_team_supportteam}
    select combobox checkbox selection    ${in_rp_pd_te_cboteam}    ${in_rp_pd_te_teamdata}    ${ds_rp_mf_pd_team_nonliveteam}    1    1
    wait loading
    click control    ${in_rp_mf_btngenerate}
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_te_nodata}
    click control    ${in_rp_pd_te_teamperf_live_lnknooftraders}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_te_nodata}
    click control    ${in_rp_pd_te_teamperf_traderperf_lnknoofmatches}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_te_nodata}
    click control    ${in_rp_pd_te_teamperf_traderperf_matchperf_lnkmatch}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_te_nodata}
    click control    ${in_rp_pd_te_breakcrumb_teamperf}
    click control    ${in_rp_pd_te_teamperf_live_lnknoofleagues}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_te_nodata}
    click control    ${in_rp_pd_te_teamperf_leagueperf_lnknooftraders}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_te_nodata}
    click control    ${in_rp_pd_te_teamperf_leagueperf_traderperf_lnknoofmatches}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_te_nodata}
    click control    ${in_rp_pd_te_teamperf_leagueperf_traderperf_matchperf_lnkmatch}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_te_nodata}

TC_09_Reports_PerformanceDetail_Bettype
    [Documentation]    Created by: 20200605@John.Ngo
    ...    Revisions:
    ...    - 20200605@John.Ngo: Create new [RedmineId: #134230]
    ...
    ...    Smoke Test Performance Detail - BetType
    # Navigate to Report
    go to url    ${ds_lg_url}    ${ds_lg_env}    ${ds_rp_perfdetailbettype}
    # Select Filter
    wait loading
    select combobox single selection    ${in_rp_pd_bt_cbomarket}    ${in_rp_pd_bt_cbomarket}    ${ds_rp_mf_pd_market_live}
    wait loading
    click control    ${in_rp_mf_periodtype}
    click control    ${in_rp_mf_periodtype_month}
    wait loading
    select month    ${in_rp_mf_mo_selectfrommonth}    ${ds_rp_mf_mo_fromdate}
    select month    ${in_rp_mf_mo_selecttomonth}    ${ds_rp_mf_mo_todate}
    click control    ${in_rp_pd_bt_cbobettype}
    click control    ${in_rp_pd_bt_cbobettype_uncheckall}
    select combobox checkbox selection    ${in_rp_pd_bt_cbobettype}    ${in_rp_pd_bt_bettypedata}    ${ds_rp_mf_bettype_1sthdp}
    select combobox checkbox selection    ${in_rp_pd_bt_cbobettype}    ${in_rp_pd_bt_bettypedata}    ${ds_rp_mf_bettype_hdp}
    select combobox checkbox selection    ${in_rp_pd_bt_cbobettype}    ${in_rp_pd_bt_bettypedata}    ${ds_rp_mf_bettype_1stou}
    select combobox checkbox selection    ${in_rp_pd_bt_cbobettype}    ${in_rp_pd_bt_bettypedata}    ${ds_rp_mf_bettype_ou}    1    1
    click control    ${in_rp_pd_bt_txtminimumturnover}
    Input Text    ${in_rp_pd_bt_txtminimumturnover}    ${ds_rp_mf_pd_minimumturnover}
    click control    ${in_rp_pd_bt_txtminimumwinloss}
    Input Text    ${in_rp_pd_bt_txtminimumwinloss}    ${ds_rp_mf_pd_minimumwinloss}
    click control    ${in_rp_pd_bt_txtmarginfrom}
    Input Text    ${in_rp_pd_bt_txtmarginfrom}    ${ds_rp_mf_pd_marginfrom}
    click control    ${in_rp_pd_bt_txtmarginto}
    Input Text    ${in_rp_pd_bt_txtmarginto}    ${ds_rp_mf_pd_marginto}
    click control    ${in_rp_mf_btngenerate}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_bt_nodata}
    check export to excel filename_fromdate_todate    ${in_rp_pd_bt_btnexporttoexcel}    Performance_Detail_BetType    ${ds_rp_mf_mo_fromdate}    ${ds_rp_mf_mo_todate}
    # Select Filter
    wait loading
    select combobox single selection    ${in_rp_pd_bt_cbomarket}    ${in_rp_pd_bt_cbomarket}    ${ds_rp_mf_pd_market_all}
    wait loading
    click control    ${in_rp_mf_periodtype}
    click control    ${in_rp_mf_periodtype_date}
    wait loading
    select date    ${in_rp_mf_dt_selectfromdate}    ${ds_rp_mf_dt_fromdate}
    select date    ${in_rp_mf_dt_selecttodate}    ${ds_rp_mf_dt_todate}
    click control    ${in_rp_pd_bt_cbobettype}
    click control    ${in_rp_pd_bt_cbobettype_checkall}
    select combobox checkbox selection    ${in_rp_pd_bt_cbobettype}    ${in_rp_pd_bt_bettypedata}    ${ds_rp_mf_bettype_1sthdp}
    select combobox checkbox selection    ${in_rp_pd_bt_cbobettype}    ${in_rp_pd_bt_bettypedata}    ${ds_rp_mf_bettype_hdp}
    select combobox checkbox selection    ${in_rp_pd_bt_cbobettype}    ${in_rp_pd_bt_bettypedata}    ${ds_rp_mf_bettype_1stou}
    select combobox checkbox selection    ${in_rp_pd_bt_cbobettype}    ${in_rp_pd_bt_bettypedata}    ${ds_rp_mf_bettype_ou}    1    1
    click control    ${in_rp_pd_bt_txtminimumturnover}
    Clear Element Text    ${in_rp_pd_bt_txtminimumturnover}
    click control    ${in_rp_pd_bt_txtminimumwinloss}
    Clear Element Text    ${in_rp_pd_bt_txtminimumwinloss}
    click control    ${in_rp_pd_bt_txtmarginfrom}
    Clear Element Text    ${in_rp_pd_bt_txtmarginfrom}
    click control    ${in_rp_pd_bt_txtmarginto}
    Clear Element Text    ${in_rp_pd_bt_txtmarginto}
    click control    ${in_rp_mf_btngenerate}
    wait loading
    click control    ${in_rp_pd_bt_bettypeperf_live_lnkmarket}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_bt_nodata}
    click control    ${in_rp_pd_bt_breakcrumb_bettypeperf}
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_bt_nodata}
    click control    ${in_rp_pd_bt_bettypeperf_lnknooftraders}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_bt_nodata}
    click control    ${in_rp_pd_bt_bettypeperf_traderperf_lnknoofmatches}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_bt_nodata}
    click control    ${in_rp_pd_bt_breakcrumb_bettypeperf}
    click control    ${in_rp_pd_bt_bettypeperf_lnknoofleagues}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_bt_nodata}
    click control    ${in_rp_pd_bt_bettypeperf_leagueperf_lnknooftraders}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_bt_nodata}
    click control    ${in_rp_pd_bt_bettypeperf_leagueperf_traderperf_lnknoofmatches}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_pd_bt_nodata}

TC_10_Reports_MultipleMatchesPerformance_Trader
    [Documentation]    Created by: 20200605@John.Ngo
    ...    Revisions:
    ...    - 20200605@John.Ngo: Create new [RedmineId: #134230]
    ...
    ...    Smoke Test Performance Detail - BetType
    # Navigate to Report
    go to url    ${ds_lg_url}    ${ds_lg_env}    ${ds_rp_multiplematchesperftrader}
    # Select Filter
    wait loading
    click control    ${in_rp_mf_periodtype}
    click control    ${in_rp_mf_periodtype_month}
    wait loading
    select month    ${in_rp_mf_mo_selectfrommonth}    ${ds_rp_mf_mo_fromdate}
    select month    ${in_rp_mf_mo_selecttomonth}    ${ds_rp_mf_mo_todate}
    click control    ${in_rp_mmp_td_cbograde}
    click control    ${in_rp_mmp_td_cbograde_uncheckall}
    select combobox checkbox selection    ${in_rp_mmp_td_cbograde}    ${in_rp_mmp_td_gradedata}    ${ds_rp_mf_mmp_grade_1}
    select combobox checkbox selection    ${in_rp_mmp_td_cbograde}    ${in_rp_mmp_td_gradedata}    ${ds_rp_mf_mmp_grade_3}
    select combobox checkbox selection    ${in_rp_mmp_td_cbograde}    ${in_rp_mmp_td_gradedata}    ${ds_rp_mf_mmp_grade_5}
    select combobox checkbox selection    ${in_rp_mmp_td_cbograde}    ${in_rp_mmp_td_gradedata}    ${ds_rp_mf_mmp_grade_7}
    select combobox checkbox selection    ${in_rp_mmp_td_cbograde}    ${in_rp_mmp_td_gradedata}    ${ds_rp_mf_mmp_grade_9}
    select combobox checkbox selection    ${in_rp_mmp_td_cbograde}    ${in_rp_mmp_td_gradedata}    ${ds_rp_mf_mmp_grade_200}
    select combobox checkbox selection    ${in_rp_mmp_td_cbograde}    ${in_rp_mmp_td_gradedata}    ${ds_rp_mf_mmp_grade_255}    1    1
    click control    ${in_rp_mmp_td_cboteam}
    click control    ${in_rp_mmp_td_cboteam_uncheckall}
    select combobox checkbox selection    ${in_rp_mmp_td_cboteam}    ${in_rp_mmp_td_teamdata}    ${ds_rp_mf_mmp_team_clg}
    select combobox checkbox selection    ${in_rp_mmp_td_cboteam}    ${in_rp_mmp_td_teamdata}    ${ds_rp_mf_mmp_team_slg}
    select combobox checkbox selection    ${in_rp_mmp_td_cboteam}    ${in_rp_mmp_td_teamdata}    ${ds_rp_mf_mmp_team_nonliveteam}
    select combobox checkbox selection    ${in_rp_mmp_td_cboteam}    ${in_rp_mmp_td_teamdata}    ${ds_rp_mf_mmp_team_supportteam}
    select combobox checkbox selection    ${in_rp_mmp_td_cboteam}    ${in_rp_mmp_td_teamdata}    ${ds_rp_mf_mmp_team_unassignedteam}    1    1
    click control    ${in_rp_mmp_td_cbobettype}
    click control    ${in_rp_mmp_td_cbobettype_uncheckall}
    select combobox checkbox selection    ${in_rp_mmp_td_cbobettype}    ${in_rp_mmp_td_bettypedata}    ${ds_rp_mf_bettype_1sthdp}    0
    select combobox checkbox selection    ${in_rp_mmp_td_cbobettype}    ${in_rp_mmp_td_bettypedata}    ${ds_rp_mf_bettype_hdp}
    select combobox checkbox selection    ${in_rp_mmp_td_cbobettype}    ${in_rp_mmp_td_bettypedata}    ${ds_rp_mf_bettype_1stou}    0
    select combobox checkbox selection    ${in_rp_mmp_td_cbobettype}    ${in_rp_mmp_td_bettypedata}    ${ds_rp_mf_bettype_ou}    1    1
    click control    ${in_rp_mmp_td_cbomultiplematches}
    click control    ${in_rp_mmp_td_cbomultiplematches_uncheckall}
    select combobox checkbox selection    ${in_rp_mmp_td_cbomultiplematches}    ${in_rp_mmp_td_multiplematchesdata}    ${ds_rp_mf_mmp_multiplematches_1}    0
    select combobox checkbox selection    ${in_rp_mmp_td_cbomultiplematches}    ${in_rp_mmp_td_multiplematchesdata}    ${ds_rp_mf_mmp_multiplematches_2}    0
    select combobox checkbox selection    ${in_rp_mmp_td_cbomultiplematches}    ${in_rp_mmp_td_multiplematchesdata}    ${ds_rp_mf_mmp_multiplematches_3}
    select combobox checkbox selection    ${in_rp_mmp_td_cbomultiplematches}    ${in_rp_mmp_td_multiplematchesdata}    ${ds_rp_mf_mmp_multiplematches_4}
    select combobox checkbox selection    ${in_rp_mmp_td_cbomultiplematches}    ${in_rp_mmp_td_multiplematchesdata}    ${ds_rp_mf_mmp_multiplematches_5}    1    1
    click control    ${in_rp_mf_btngenerate}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_mmp_td_nodata}
    check export to excel filename_fromdate_todate    ${in_rp_mmp_td_btnexporttoexcel}    Multiple_Matches_Performance_Trader    ${ds_rp_mf_mo_fromdate}    ${ds_rp_mf_mo_todate}
    # Select Filter
    wait loading
    click control    ${in_rp_mf_periodtype}
    click control    ${in_rp_mf_periodtype_date}
    wait loading
    select date    ${in_rp_mf_dt_selectfromdate}    ${ds_rp_mf_dt_fromdate}
    select date    ${in_rp_mf_dt_selecttodate}    ${ds_rp_mf_dt_todate}
    click control    ${in_rp_mmp_td_cbograde}
    click control    ${in_rp_mmp_td_cbograde_checkall}
    select combobox checkbox selection    ${in_rp_mmp_td_cbograde}    ${in_rp_mmp_td_gradedata}    ${ds_rp_mf_mmp_grade_255}    1    1
    click control    ${in_rp_mmp_td_cboteam}
    click control    ${in_rp_mmp_td_cboteam_checkall}
    select combobox checkbox selection    ${in_rp_mmp_td_cboteam}    ${in_rp_mmp_td_teamdata}    ${ds_rp_mf_mmp_team_unassignedteam}    1    1
    click control    ${in_rp_mmp_td_cbobettype}
    click control    ${in_rp_mmp_td_cbobettype_checkall}
    select combobox checkbox selection    ${in_rp_mmp_td_cbobettype}    ${in_rp_mmp_td_bettypedata}    ${ds_rp_mf_bettype_ou}    1    1
    click control    ${in_rp_mmp_td_cbomultiplematches}
    click control    ${in_rp_mmp_td_cbomultiplematches_checkall}
    select combobox checkbox selection    ${in_rp_mmp_td_cbomultiplematches}    ${in_rp_mmp_td_multiplematchesdata}    ${ds_rp_mf_mmp_multiplematches_2}    0
    select combobox checkbox selection    ${in_rp_mmp_td_cbomultiplematches}    ${in_rp_mmp_td_multiplematchesdata}    ${ds_rp_mf_mmp_multiplematches_5}    1    1
    click control    ${in_rp_mf_btngenerate}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_mmp_td_nodata}
    click control    ${in_rp_mmp_td_multiplematchesperf_lnkmultiplematches}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_mmp_td_nodata}
    click control    ${in_rp_mmp_td_multiplematchesperf_matchperf_lnkmatch}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_mmp_td_nodata}

TC_11_Reports_AutomationTradingPerformance_Bettype
    [Documentation]    Created by: 20200605@John.Ngo
    ...    Revisions:
    ...    - 20200605@John.Ngo: Create new [RedmineId: #134230]
    ...
    ...    Smoke Test Performance Detail - BetType
    # Navigate to Report
    go to url    ${ds_lg_url}    ${ds_lg_env}    ${ds_rp_automationtradingperfbettype}
    # Select Filter
    wait loading
    click control    ${in_rp_mf_periodtype}
    click control    ${in_rp_mf_periodtype_month}
    wait loading
    select month    ${in_rp_mf_mo_selectfrommonth}    ${ds_rp_mf_mo_fromdate}
    select month    ${in_rp_mf_mo_selecttomonth}    ${ds_rp_mf_mo_todate}
    select combobox single selection    ${in_rp_atp_bt_cbomodel}    ${in_rp_atp_bt_modeldata}    ${ds_rp_mf_atp_model_rt3}
    click control    ${in_rp_atp_bt_cboleaguegroup}
    click control    ${in_rp_atp_bt_cboleaguegroup_uncheckall}
    select combobox checkbox selection    ${in_rp_atp_bt_cboleaguegroup}    ${in_rp_atp_bt_leaguegroupdata}    ${ds_rp_mf_atp_leaguegroup_mj}
    select combobox checkbox selection    ${in_rp_atp_bt_cboleaguegroup}    ${in_rp_atp_bt_leaguegroupdata}    ${ds_rp_mf_atp_leaguegroup_m2}
    select combobox checkbox selection    ${in_rp_atp_bt_cboleaguegroup}    ${in_rp_atp_bt_leaguegroupdata}    ${ds_rp_mf_atp_leaguegroup_m4}
    select combobox checkbox selection    ${in_rp_atp_bt_cboleaguegroup}    ${in_rp_atp_bt_leaguegroupdata}    ${ds_rp_mf_atp_leaguegroup_others1}
    select combobox checkbox selection    ${in_rp_atp_bt_cboleaguegroup}    ${in_rp_atp_bt_leaguegroupdata}    ${ds_rp_mf_atp_leaguegroup_others3}
    select combobox checkbox selection    ${in_rp_atp_bt_cboleaguegroup}    ${in_rp_atp_bt_leaguegroupdata}    ${ds_rp_mf_atp_leaguegroup_others5}    1    1
    click control    ${in_rp_atp_bt_cbosite}
    click control    ${in_rp_atp_bt_cbosite_uncheckall}
    select combobox checkbox selection    ${in_rp_atp_bt_cbosite}    ${in_rp_atp_bt_sitedata}    ${ds_rp_mf_atp_site_nova}
    select combobox checkbox selection    ${in_rp_atp_bt_cbosite}    ${in_rp_atp_bt_sitedata}    ${ds_rp_mf_atp_site_cash}    1    1
    click control    ${in_rp_atp_bt_cbomeasurement}
    click control    ${in_rp_atp_bt_cbomeasurement_uncheckall}
    select combobox checkbox selection    ${in_rp_atp_bt_cbomeasurement}    ${in_rp_atp_bt_measurementdata}    ${ds_rp_mf_atp_measurement_virtualturnover}
    select combobox checkbox selection    ${in_rp_atp_bt_cbomeasurement}    ${in_rp_atp_bt_measurementdata}    ${ds_rp_mf_atp_measurement_virtualwinloss}
    select combobox checkbox selection    ${in_rp_atp_bt_cbomeasurement}    ${in_rp_atp_bt_measurementdata}    ${ds_rp_mf_atp_measurement_varianceturnover}
    select combobox checkbox selection    ${in_rp_atp_bt_cbomeasurement}    ${in_rp_atp_bt_measurementdata}    ${ds_rp_mf_atp_measurement_variancewinloss}
    select combobox checkbox selection    ${in_rp_atp_bt_cbomeasurement}    ${in_rp_atp_bt_measurementdata}    ${ds_rp_mf_atp_measurement_realturnover}
    select combobox checkbox selection    ${in_rp_atp_bt_cbomeasurement}    ${in_rp_atp_bt_measurementdata}    ${ds_rp_mf_atp_measurement_realwinloss}
    select combobox checkbox selection    ${in_rp_atp_bt_cbomeasurement}    ${in_rp_atp_bt_measurementdata}    ${ds_rp_mf_atp_measurement_8rmturnover}
    select combobox checkbox selection    ${in_rp_atp_bt_cbomeasurement}    ${in_rp_atp_bt_measurementdata}    ${ds_rp_mf_atp_measurement_8rmwinloss}
    select combobox checkbox selection    ${in_rp_atp_bt_cbomeasurement}    ${in_rp_atp_bt_measurementdata}    ${ds_rp_mf_atp_measurement_realex8rmturnover}
    select combobox checkbox selection    ${in_rp_atp_bt_cbomeasurement}    ${in_rp_atp_bt_measurementdata}    ${ds_rp_mf_atp_measurement_realex8rmwinloss}    1    1
    click control    ${in_rp_mf_btngenerate}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_atp_bt_nodata}
    # Select Filter
    wait loading
    click control    ${in_rp_mf_periodtype}
    click control    ${in_rp_mf_periodtype_date}
    wait loading
    select date    ${in_rp_mf_dt_selectfromdate}    ${ds_rp_mf_dt_fromdate}
    select date    ${in_rp_mf_dt_selecttodate}    ${ds_rp_mf_dt_todate}
    select combobox single selection    ${in_rp_atp_bt_cbomodel}    ${in_rp_atp_bt_modeldata}    ${ds_rp_mf_atp_model_ta}
    click control    ${in_rp_atp_bt_cboleaguegroup}
    click control    ${in_rp_atp_bt_cboleaguegroup_checkall}
    select combobox checkbox selection    ${in_rp_atp_bt_cboleaguegroup}    ${in_rp_atp_bt_leaguegroupdata}    ${ds_rp_mf_atp_leaguegroup_others5}    1    1
    click control    ${in_rp_atp_bt_cbosite}
    click control    ${in_rp_atp_bt_cbosite_checkall}
    select combobox checkbox selection    ${in_rp_atp_bt_cbosite}    ${in_rp_atp_bt_sitedata}    ${ds_rp_mf_atp_site_cash}    1    1
    click control    ${in_rp_atp_bt_cbomeasurement}
    click control    ${in_rp_atp_bt_cbomeasurement_checkall}
    select combobox checkbox selection    ${in_rp_atp_bt_cbomeasurement}    ${in_rp_atp_bt_measurementdata}    ${ds_rp_mf_atp_measurement_realex8rmwinloss}    1    1
    click control    ${in_rp_mf_btngenerate}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_atp_bt_nodata}
    check export to excel filename_fromdate_todate    ${in_rp_atp_bt_btnexporttoexcel}    Automation_Trading_Performance_BetType    ${ds_rp_mf_dt_fromdate}    ${ds_rp_mf_dt_todate}
    click control    ${in_rp_atp_bt_bettypeperf_lnkleague}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_atp_bt_nodata}
    check export to excel filename_fromdate_todate    ${in_rp_atp_bt_btnexporttoexcel}    Automation_Trading_Performance_League    ${ds_rp_mf_dt_fromdate}    ${ds_rp_mf_dt_todate}
    click control    ${in_rp_atp_bt_bettypeperf_leagueperf_lnkmatch}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_atp_bt_nodata}
    check export to excel filename_fromdate_todate    ${in_rp_atp_bt_btnexporttoexcel}    Automation_Trading_Performance_Match    ${ds_rp_mf_dt_fromdate}    ${ds_rp_mf_dt_todate}
    click control    ${in_rp_atp_bt_breakcrumb_bettypeperf}

TC_12_Reports_AutomationTradingPerformance_Period
    [Documentation]    Created by: 20200605@John.Ngo
    ...    Revisions:
    ...    - 20200605@John.Ngo: Create new [RedmineId: #134230]
    ...
    ...    Smoke Test Performance Detail - BetType
    # Navigate to Report
    go to url    ${ds_lg_url}    ${ds_lg_env}    ${ds_rp_automationtradingperfperiod}
    # Select Filter
    wait loading
    click control    ${in_rp_mf_periodtype}
    click control    ${in_rp_mf_periodtype_month}
    wait loading
    select month    ${in_rp_mf_mo_selectfrommonth}    ${ds_rp_mf_mo_fromdate}
    select month    ${in_rp_mf_mo_selecttomonth}    ${ds_rp_mf_mo_todate}
    select combobox single selection    ${in_rp_atp_bt_cbomodel}    ${in_rp_atp_bt_modeldata}    ${ds_rp_mf_atp_model_rt3}
    click control    ${in_rp_atp_bt_cboleaguegroup}
    click control    ${in_rp_atp_bt_cboleaguegroup_uncheckall}
    select combobox checkbox selection    ${in_rp_atp_bt_cboleaguegroup}    ${in_rp_atp_bt_leaguegroupdata}    ${ds_rp_mf_atp_leaguegroup_mj}
    select combobox checkbox selection    ${in_rp_atp_bt_cboleaguegroup}    ${in_rp_atp_bt_leaguegroupdata}    ${ds_rp_mf_atp_leaguegroup_m2}
    select combobox checkbox selection    ${in_rp_atp_bt_cboleaguegroup}    ${in_rp_atp_bt_leaguegroupdata}    ${ds_rp_mf_atp_leaguegroup_m4}
    select combobox checkbox selection    ${in_rp_atp_bt_cboleaguegroup}    ${in_rp_atp_bt_leaguegroupdata}    ${ds_rp_mf_atp_leaguegroup_others1}
    select combobox checkbox selection    ${in_rp_atp_bt_cboleaguegroup}    ${in_rp_atp_bt_leaguegroupdata}    ${ds_rp_mf_atp_leaguegroup_others3}
    select combobox checkbox selection    ${in_rp_atp_bt_cboleaguegroup}    ${in_rp_atp_bt_leaguegroupdata}    ${ds_rp_mf_atp_leaguegroup_others5}    1    1
    click control    ${in_rp_atp_bt_cbosite}
    click control    ${in_rp_atp_bt_cbosite_uncheckall}
    select combobox checkbox selection    ${in_rp_atp_bt_cbosite}    ${in_rp_atp_bt_sitedata}    ${ds_rp_mf_atp_site_nova}
    select combobox checkbox selection    ${in_rp_atp_bt_cbosite}    ${in_rp_atp_bt_sitedata}    ${ds_rp_mf_atp_site_cash}    1    1
    click control    ${in_rp_atp_bt_cbomeasurement}
    click control    ${in_rp_atp_bt_cbomeasurement_uncheckall}
    select combobox checkbox selection    ${in_rp_atp_bt_cbomeasurement}    ${in_rp_atp_bt_measurementdata}    ${ds_rp_mf_atp_measurement_virtualturnover}
    select combobox checkbox selection    ${in_rp_atp_bt_cbomeasurement}    ${in_rp_atp_bt_measurementdata}    ${ds_rp_mf_atp_measurement_virtualwinloss}
    select combobox checkbox selection    ${in_rp_atp_bt_cbomeasurement}    ${in_rp_atp_bt_measurementdata}    ${ds_rp_mf_atp_measurement_varianceturnover}
    select combobox checkbox selection    ${in_rp_atp_bt_cbomeasurement}    ${in_rp_atp_bt_measurementdata}    ${ds_rp_mf_atp_measurement_variancewinloss}
    select combobox checkbox selection    ${in_rp_atp_bt_cbomeasurement}    ${in_rp_atp_bt_measurementdata}    ${ds_rp_mf_atp_measurement_realturnover}
    select combobox checkbox selection    ${in_rp_atp_bt_cbomeasurement}    ${in_rp_atp_bt_measurementdata}    ${ds_rp_mf_atp_measurement_realwinloss}
    select combobox checkbox selection    ${in_rp_atp_bt_cbomeasurement}    ${in_rp_atp_bt_measurementdata}    ${ds_rp_mf_atp_measurement_8rmturnover}
    select combobox checkbox selection    ${in_rp_atp_bt_cbomeasurement}    ${in_rp_atp_bt_measurementdata}    ${ds_rp_mf_atp_measurement_8rmwinloss}
    select combobox checkbox selection    ${in_rp_atp_bt_cbomeasurement}    ${in_rp_atp_bt_measurementdata}    ${ds_rp_mf_atp_measurement_realex8rmturnover}
    select combobox checkbox selection    ${in_rp_atp_bt_cbomeasurement}    ${in_rp_atp_bt_measurementdata}    ${ds_rp_mf_atp_measurement_realex8rmwinloss}    1    1
    click control    ${in_rp_mf_btngenerate}
    wait loading
    # Check internal error & exist data
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_hp_msginternalerror}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${in_rp_atp_bt_nodata}

*** Keywords ***
