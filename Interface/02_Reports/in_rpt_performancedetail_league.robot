*** Variables ***
${in_rp_pd_lg_cbomarket}    //*[@id="ddlMarket"]
${in_rp_pd_lg_cbobettype}    //*[@id='ddlBetType']/following-sibling::*//span[2]
${in_rp_pd_lg_bettypedata}    //*[@name='multiselect_ddlBetType']
${in_rp_pd_lg_cbobettype_checkall}    //div[contains(@style,'display: block')]//div[@class='ui-multiselect-filter']/following-sibling::*//span[contains(text(),'Check all')]
${in_rp_pd_lg_cbobettype_uncheckall}    //div[contains(@style,'display: block')]//div[@class='ui-multiselect-filter']/following-sibling::*//span[contains(text(),'Uncheck all')]
${in_rp_pd_lg_txtminimumturnover}    //*[label[normalize-space(text())='Minimum Turnover']]//following-sibling::*[1]//input
${in_rp_pd_lg_txtminimumwinloss}    //*[label[normalize-space(text())='Minimum Win Loss']]//following-sibling::*[1]//input
${in_rp_pd_lg_btnexporttoexcel}    //*[@class="btnExcel" and @title='Export to Excel']
${in_rp_pd_lg_txtmarginfrom}    //*[label[normalize-space(text())='Margin %']]/following-sibling::*/div[1]/input
${in_rp_pd_lg_txtmarginto}    //*[label[normalize-space(text())='Margin %']]/following-sibling::*/div[2]/input
${in_rp_pd_lg_txtleague}    //*[label[normalize-space(text())='League']]//following-sibling::*[1]//input
${in_rp_pd_lg_nodata}    //div[@class='content-container']//following-sibling::*//div[normalize-space(text())='There is no data']
${in_rp_pd_lg_leagueperf_lnknooftrader}    //*[@id='divLeaguePerformanceGrid']//tbody/tr[1]//span[contains(@class,'trader-link link')]
${in_rp_pd_lg_leagueperf_traderperf_lnknoofmatches}    //*[@id='divTraderPerformanceGrid']//tbody/tr[1]//span[contains(@class,'match-link link')]
${in_rp_pd_lg_leagueperf_traderperf_matchperf_lnkmatch}    //*[@id='divMatchPerformanceGrid']//tbody/tr[1]//span[contains(@class,'bettype-detail-link link')]
${in_rp_pd_lg_leagueperf_lnknoofmatch}    //*[@id='divLeaguePerformanceGrid']//tbody/tr[1]//span[contains(@class,'match-link link')]
${in_rp_pd_lg_leagueperf_matchperf_lnkmatch}    //*[@id='divMatchPerformanceOfLeagueGrid']//tbody/tr[1]//span[contains(@class,'bettype-detail-link link')]
${in_rp_pd_lg_breakcrumb_leagueperf}    //*[@class='filter-bar']/following-sibling::*[not(contains(@class,'display-none'))]//*[@id='reporttile']/span[1]
