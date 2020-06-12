*** Variables ***
${in_rp_pd_te_cbomarket}    //*[@id="ddlMarket"]
${in_rp_pd_te_cbobettype}    //*[@id='ddlBetType']/following-sibling::*//span[2]
${in_rp_pd_te_bettypedata}    //*[@name='multiselect_ddlBetType']
${in_rp_pd_te_cbobettype_checkall}    //div[contains(@style,'display: block')]//div[@class='ui-multiselect-filter']/following-sibling::*//span[contains(text(),'Check all')]
${in_rp_pd_te_cbobettype_uncheckall}    //div[contains(@style,'display: block')]//div[@class='ui-multiselect-filter']/following-sibling::*//span[contains(text(),'Uncheck all')]
${in_rp_pd_te_txtminimumturnover}    //*[label[normalize-space(text())='Minimum Turnover']]//following-sibling::*[1]//input
${in_rp_pd_te_txtminimumwinloss}    //*[label[normalize-space(text())='Minimum Win Loss']]//following-sibling::*[1]//input
${in_rp_pd_te_btnexporttoexcel}    //*[@class='filter-bar']/following-sibling::*[not(contains(@class,'display-none'))]//*[@class="btnExcel" and @title='Export to Excel']
${in_rp_pd_te_txtmarginfrom}    //*[label[normalize-space(text())='Margin %']]/following-sibling::*/div[1]/input
${in_rp_pd_te_txtmarginto}    //*[label[normalize-space(text())='Margin %']]/following-sibling::*/div[2]/input
${in_rp_pd_te_cboteam}    //*[@id='ddlTeam']/following-sibling::*//span[2]
${in_rp_pd_te_teamdata}    //*[@name='multiselect_ddlTeam']
${in_rp_pd_te_cboteam_checkall}    //div[contains(@style,'display: block')]//div[@class='ui-multiselect-filter']/following-sibling::*//span[contains(text(),'Check all')]
${in_rp_pd_te_cboteam_uncheckall}    //div[contains(@style,'display: block')]//div[@class='ui-multiselect-filter']/following-sibling::*//span[contains(text(),'Uncheck all')]
${in_rp_pd_te_nodata}    //div[@class='content-container']//following-sibling::*//div[normalize-space(text())='There is no data']
${in_rp_pd_te_teamperf_live_lnknooftraders}    //*[@id='tblContent_divTeamPerformanceGrid']//tr[(preceding-sibling::*[td/div[text()='Live']])][1]//span[contains(@class,'trader-link link')]    # //*[@id='tblContent_divTeamPerformanceGrid']//tr[(preceding-sibling::*[td/div[text()='Live']]) and (following-sibling::*[td/div[text()='Non-Live']])][1]//span[contains(@class,'trader-link link')]
${in_rp_pd_te_teamperf_nonlive_lnknooftraders}    //*[@id='tblContent_divTeamPerformanceGrid']//tr[(preceding-sibling::*[td/div[text()='Non-Live']])]//following-sibling::*[1]//span[contains(@class,'trader-link link')]
${in_rp_pd_te_teamperf_traderperf_lnknoofmatches}    //*[@id='tblContent_divTraderPerformanceGrid']//tbody/tr[1]//span[contains(@class,'match-link link')]
${in_rp_pd_te_teamperf_traderperf_matchperf_lnkmatch}    //*[@id='tblContent_divMatchPerformanceGrid']//tbody/tr[2]//following-sibling::*[1]//span[contains(@class,'bettype-detail-link link')]
${in_rp_pd_te_breakcrumb_teamperf}    //*[@class='filter-bar']/following-sibling::*[not(contains(@class,'display-none'))]//*[@id='reporttile']/span[1]
${in_rp_pd_te_teamperf_live_lnknoofleagues}    //*[@id='tblContent_divTeamPerformanceGrid']//tr[(preceding-sibling::*[td/div[text()='Live']])][1]//span[contains(@class,'league-link link')]    # //*[@id='tblContent_divTeamPerformanceGrid']//tr[(preceding-sibling::*[td/div[text()='Live']]) and (following-sibling::*[td/div[text()='Non-Live']])][1]//span[contains(@class,'league-link link')]
${in_rp_pd_te_teamperf_nonlive_lnknoofleagues}    //*[@id='tblContent_divTeamPerformanceGrid']//tr[(preceding-sibling::*[td/div[text()='Non-Live']])]//following-sibling::*[1]//span[contains(@class,'league-link link')]
${in_rp_pd_te_teamperf_leagueperf_lnknooftraders}    //*[@id='tblContent_divLeagueDetailGrid']//tbody/tr[1]//span[contains(@class,'trader-link link')]
${in_rp_pd_te_teamperf_leagueperf_traderperf_lnknoofmatches}    //*[@id='tblContent_divTraderPerformanceGrid']/tbody/tr[1]//span[contains(@class,'match-link link')]
${in_rp_pd_te_teamperf_leagueperf_traderperf_matchperf_lnkmatch}    //*[@id='tblContent_divMatchPerformanceGrid']/tbody/tr[1]//span[contains(@class,'bettype-detail-link link')]
