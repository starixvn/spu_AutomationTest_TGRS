*** Variables ***
${in_rp_pd_gr_cbomarket}    //*[@id="ddlMarket"]
${in_rp_pd_gr_cbobettype}    //*[@id='ddlBetType']/following-sibling::*//span[2]
${in_rp_pd_gr_bettypedata}    //*[@name='multiselect_ddlBetType']
${in_rp_pd_gr_cbobettype_checkall}    //div[contains(@style,'display: block')]//div[@class='ui-multiselect-filter']/following-sibling::*//span[contains(text(),'Check all')]
${in_rp_pd_gr_cbobettype_uncheckall}    //div[contains(@style,'display: block')]//div[@class='ui-multiselect-filter']/following-sibling::*//span[contains(text(),'Uncheck all')]
${in_rp_pd_gr_txtminimumturnover}    //*[label[normalize-space(text())='Minimum Turnover']]//following-sibling::*[1]//input
${in_rp_pd_gr_txtminimumwinloss}    //*[label[normalize-space(text())='Minimum Win Loss']]//following-sibling::*[1]//input
${in_rp_pd_gr_btnexporttoexcel}    //*[@class='filter-bar']/following-sibling::*[not(contains(@class,'display-none'))]//*[@class="btnExcel" and @title='Export to Excel']
${in_rp_pd_gr_txtmarginfrom}    //*[label[normalize-space(text())='Margin %']]/following-sibling::*/div[1]/input
${in_rp_pd_gr_txtmarginto}    //*[label[normalize-space(text())='Margin %']]/following-sibling::*/div[2]/input
${in_rp_pd_gr_nodata}    //div[@class='content-container']//following-sibling::*//div[normalize-space(text())='There is no data']
${in_rp_pd_gr_gradeperf_live_lnknooftraders}    //*[@id='tblContent_divGradePerformanceGrid']//tr[(preceding-sibling::*[td/div[text()='Live']]) and (following-sibling::*[td/div[text()='Non-Live']])][1]//span[contains(@class,'trader-link link')]
${in_rp_pd_gr_gradeperf_nonlive_lnknooftraders}    //*[@id='tblContent_divGradePerformanceGrid']//tr[(preceding-sibling::*[td/div[text()='Non-Live']])]//following-sibling::*[1]//span[contains(@class,'trader-link link')]
${in_rp_pd_gr_gradeperf_traderperf_lnknoofmatches}    //*[@id='tblContent_divTraderPerformanceGrid']//tbody/tr[1]//span[contains(@class,'match-link link')]
${in_rp_pd_gr_gradeperf_traderperf_matchperf_lnkmatch}    //*[@id='tblContent_divMatchPerformanceGrid']//tbody/tr[1]//following-sibling::*[1]//span[contains(@class,'bettype-detail-link link')]
${in_rp_pd_gr_breakcrumb_gradeperf}    //*[@class='filter-bar']/following-sibling::*[not(contains(@class,'display-none'))]//*[@id='reporttile']/span[1]
${in_rp_pd_gr_gradeperf_live_lnknoofleagues}    //*[@id='tblContent_divGradePerformanceGrid']//tr[(preceding-sibling::*[td/div[text()='Live']]) and (following-sibling::*[td/div[text()='Non-Live']])][1]//span[contains(@class,'league-link link')]
${in_rp_pd_gr_gradeperf_nonlive_lnknoofleagues}    //*[@id='tblContent_divGradePerformanceGrid']//tr[(preceding-sibling::*[td/div[text()='Non-Live']])]//following-sibling::*[1]//span[contains(@class,'league-link link')]
${in_rp_pd_gr_gradeperf_leagueperf_lnknooftraders}    //*[@id='tblContent_divLeaguePerformanceGrid']//tbody/tr[1]//span[contains(@class,'trader-link link')]
${in_rp_pd_gr_gradeperf_leagueperf_traderperf_lnknoofmatches}    //*[@id='tblContent_divTraderPerformanceByLeagueGrid']/tbody/tr[1]//span[contains(@class,'match-link link')]
${in_rp_pd_gr_gradeperf_leagueperf_traderperf_matchperf_lnkmatch}    //*[@id='tblContent_divMatchPerformanceGrid']/tbody/tr[1]//span[contains(@class,'bettype-detail-link link')]
