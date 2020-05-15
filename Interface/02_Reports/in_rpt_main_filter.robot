*** Settings ***
Resource          ../../Dataset/ds_rpt_main_filter.robot

*** Variables ***
${in_rp_mf_periodtype}    //*[@id='ddlPeriodType']/following-sibling::button[@class='ui-multiselect ui-widget ui-state-default']
${in_rp_mf_periodtype_date}    //ul[@class = 'ui-multiselect-checkboxes ui-helper-reset']/li/label[contains(@class,'ui-corner-all')]/span[contains(text(),'Date')]
${in_rp_mf_periodtype_month}    //ul[@class = 'ui-multiselect-checkboxes ui-helper-reset']/li/label[contains(@class,'ui-corner-all')]/span[contains(text(),'Month')]
${in_rp_mf_fromdate}    //*[@id='dpkFromDate']
${in_rp_mf_todate}    //*[@id='dpkToDate']
${in_rp_mf_frommonth}    //*[@id="divMonthFrom"]
${in_rp_mf_tomonth}    //*[@id="divMonthTo"]
${in_rp_mf_btngenerate}    //*[@id='btnGenerate']
${in_rp_mf_selectfromyear}    //div[@id='ui-datepicker-div']/div/div/select[2]/option[text()=${ds_rp_mf_fromyear}]
${in_rp_mf_selectfrommonth}    //*[@id='ui-datepicker-div']/div/div/select[1]/option[text()='${ds_rp_mf_frommonth}']
${in_rp_mf_selectfromday}    //div[@id='ui-datepicker-div']/table//td[@data-month='${ds_rp_mf_frommonth}']/a[text()=${ds_rp_mf_fromday}]
${in_rp_mf_selecttoyear}    //div[@id='ui-datepicker-div']/div/div/select[2]/option[text()=${ds_rp_mf_toyear}]
${in_rp_mf_selecttomonth}    //*[@id='ui-datepicker-div']/div/div/select[1]/option[text()='${ds_rp_mf_tomonth}']
${in_rp_mf_selecttoday}    //div[@id='ui-datepicker-div']/table//td[@data-month='${ds_rp_mf_tomonth}']/a[text()=${ds_rp_mf_today}]
${in_rp_mf_cboYear}    //div[@id='ui-datepicker-div']/div/div/select[2]
${in_rp_mf_cboMonth}    //*[@id='ui-datepicker-div']/div/div/select[1]
${in_rp_mf_tblDate}    //div[@id='ui-datepicker-div']/table
