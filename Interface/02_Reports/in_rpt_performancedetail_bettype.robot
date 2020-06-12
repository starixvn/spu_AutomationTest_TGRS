*** Variables ***
${in_rp_pd_bt_cbomarket}    //*[@id="ddlMarket"]
${in_rp_pd_bt_cbobettype}    //*[@id='ddlBetType']/following-sibling::*//span[2]
${in_rp_pd_bt_bettypedata}    //*[@name='multiselect_ddlBetType']
${in_rp_pd_bt_cbobettype_checkall}    //div[contains(@style,'display: block')]//div[@class='ui-multiselect-filter']/following-sibling::*//span[contains(text(),'Check all')]
${in_rp_pd_bt_cbobettype_uncheckall}    //div[contains(@style,'display: block')]//div[@class='ui-multiselect-filter']/following-sibling::*//span[contains(text(),'Uncheck all')]
${in_rp_pd_bt_txtminimumturnover}    //*[label[normalize-space(text())='Minimum Turnover']]//following-sibling::*[1]//input
${in_rp_pd_bt_txtminimumwinloss}    //*[label[normalize-space(text())='Minimum Win Loss']]//following-sibling::*[1]//input
${in_rp_pd_bt_btnexporttoexcel}    //*[@class='filter-bar']/following-sibling::*[not(contains(@class,'display-none'))]//*[@class="btnExcel" and @title='Export to Excel']
${in_rp_pd_bt_txtmarginfrom}    //*[label[normalize-space(text())='Margin %']]/following-sibling::*/div[1]/input
${in_rp_pd_bt_txtmarginto}    //*[label[normalize-space(text())='Margin %']]/following-sibling::*/div[2]/input
${in_rp_pd_bt_nodata}    //div[@class='content-container']//following-sibling::*//div[normalize-space(text())='There is no data']
${in_rp_pd_bt_bettypeperf_lnknooftraders}    //*[@id='tblContent_divBetTypePerformanceGrid']//tbody/tr[1]//span[contains(@class,'trader-link link')]
${in_rp_pd_bt_bettypeperf_traderperf_lnknoofmatches}    //*[@id='tblContent_divTraderPerformanceGrid']//tbody/tr[1]//span[contains(@class,'match-link link')]
${in_rp_pd_bt_breakcrumb_bettypeperf}    //*[@class='filter-bar']/following-sibling::*[not(contains(@class,'display-none'))]//*[@id='reporttile']/span[1]
${in_rp_pd_bt_bettypeperf_lnknoofleagues}    //*[@id='tblContent_divBetTypePerformanceGrid']//tbody/tr[1]//span[contains(@class,'league-link link')]
${in_rp_pd_bt_bettypeperf_leagueperf_lnknooftraders}    //*[@id='tblContent_divLeaguePerformanceGrid']//tbody/tr[1]//span[contains(@class,'trader-link link')]
${in_rp_pd_bt_bettypeperf_leagueperf_traderperf_lnknoofmatches}    //*[@id='tblContent_divTraderPerformanceGrid']/tbody/tr[1]//span[contains(@class,'match-link link')]
${in_rp_pd_bt_bettypeperf_live_lnkmarket}    //*[@id='tblContent_divBetTypePerformanceGrid']//tbody/tr[1]//span[contains(@class,'bettype link bettype-link')]
