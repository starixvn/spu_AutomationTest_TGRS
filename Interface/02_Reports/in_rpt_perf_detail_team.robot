*** Variables ***
${in_rp_pfdt_turnovertotal}    //*[@id='divTeamPerformanceGrid']//table[contains(@class,'col_footer_content grid-fixed-table')]//following-sibling::th[contains(@class,'free-grid-td-5')]
${in_rp_pfdt_betcounttotal}    //*[@id='divTeamPerformanceGrid']//table[contains(@class,'col_footer_content grid-fixed-table')]//following-sibling::th[contains(@class,'free-grid-td-8')]
${in_rp_pfdt_grandtotal}    //*[@id='divTeamPerformanceGrid']//tr/th[contains(@class,'free-grid-td-0')]/div[text()='Grand Total']
