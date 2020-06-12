*** Variables ***
${in_rp_pd_td_cbomarket}    //*[@id="ddlMarket"]
${in_rp_pd_td_cbobettype}    //*[@id='ddlBetType']/following-sibling::*//span[2]
${in_rp_pd_td_bettypedata}    //*[@name='multiselect_ddlBetType']
${in_rp_pd_td_cbobettype_checkall}    //div[contains(@style,'display: block')]//div[@class='ui-multiselect-filter']/following-sibling::*//span[contains(text(),'Check all')]
${in_rp_pd_td_cbobettype_uncheckall}    //div[contains(@style,'display: block')]//div[@class='ui-multiselect-filter']/following-sibling::*//span[contains(text(),'Uncheck all')]
${in_rp_pd_td_txtminimumturnover}    //*[label[normalize-space(text())='Minimum Turnover']]//following-sibling::*[1]//input
${in_rp_pd_td_txtminimumwinloss}    //*[label[normalize-space(text())='Minimum Win Loss']]//following-sibling::*[1]//input
${in_rp_pd_td_btnexporttoexcel}    //*[@class='filter-bar']/following-sibling::*[not(contains(@class,'display-none'))]//*[@class="btnExcel" and @title='Export to Excel']
${in_rp_pd_td_txtmarginfrom}    //*[label[normalize-space(text())='Margin %']]/following-sibling::*/div[1]/input
${in_rp_pd_td_txtmarginto}    //*[label[normalize-space(text())='Margin %']]/following-sibling::*/div[2]/input
${in_rp_pd_td_txttrader}    //*[label[normalize-space(text())='Trader']]//following-sibling::*[1]//input
${in_rp_pd_td_nodata}    //div[@class='content-container']//following-sibling::*//div[normalize-space(text())='There is no data']
${in_rp_pd_td_traderperf_live_lnknoofmatch}    //*[@id='divTraderPerformanceGrid']//tr[(preceding-sibling::*[td/div[text()='Live']]) and (following-sibling::*[td/div[text()='Non-Live']])][1]//span[contains(@class,'match-link link')]    # //*[@id='divTraderPerformanceGrid']//*[td/div[text()='Live']]//following-sibling::*[1]//span[contains(@class,'match-link link')]
${in_rp_pd_td_traderperf_nonlive_lnknoofmatch}    //*[@id='divTraderPerformanceGrid']//tr[(preceding-sibling::*[td/div[text()='Non-Live']])]//following-sibling::*[1]//span[contains(@class,'match-link link')]
${in_rp_pd_td_traderperf_matchperf_lnkmatch}    //*[@id='tblContent_divMatchPerformanceGrid']//tbody/tr[1]//following-sibling::*[1]//span[contains(@class,'bettype-detail-link link')]
${in_rp_pd_td_breakcrumb_traderperf}    //*[@class='filter-bar']/following-sibling::*[not(contains(@class,'display-none'))]//*[@id='reporttile']/span[1]
