*** Variables ***
${in_rp_tm_yeardata}    //*[@name='multiselect_yearSelector']
${in_rp_tm_cboyear}    //*[@id='yearSelector']/following-sibling::*//span[2]
${in_rp_tm_cboproduct}    //*[@id='bettypeSelector']/following-sibling::*//span[2]
${in_rp_tm_productdata}    //*[@name='multiselect_bettypeSelector']
${in_rp_tm_cboshift}    //*[@id='shiftSelector']/following-sibling::*//span[2]
${in_rp_tm_shiftdata}    //*[@name='multiselect_shiftSelector']
${in_rp_tm_txtleague}    //*[label[normalize-space(text())='League']]//following-sibling::*//input
${in_rp_tm_cbograde}    //*[@id='gradeSelector']/following-sibling::*//span[2]
${in_rp_tm_gradedata}    //*[@name='multiselect_gradeSelector']
${in_rp_tm_txttrader}    //*[label[normalize-space(text())='Trader']]//following-sibling::*//input
${in_rp_tm_columnsdata}    //*[@name='multiselect_idColumns']
${in_rp_tm_cbccolumns}    //*[@id='idColumns']/following-sibling::*//span[2]
${in_rp_tm_btnexporttoexcel}    //*[@class="btnExcel" and @title='Export to Excel']
${in_rp_tm_nodata}    //div[@class='content-container']//following-sibling::*//div[normalize-space(text())='There is no data']
