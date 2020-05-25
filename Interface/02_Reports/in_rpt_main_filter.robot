*** Settings ***
Resource          ../../Dataset/ds_rpt_main_filter.robot

*** Variables ***
${in_rp_mf_periodtype}    //*[@id='ddlPeriodType']/following-sibling::button[@class='ui-multiselect ui-widget ui-state-default']
${in_rp_mf_periodtype_date}    //ul[@class = 'ui-multiselect-checkboxes ui-helper-reset']/li/label[contains(@class,'ui-corner-all')]/span[contains(text(),'Date')]
${in_rp_mf_periodtype_month}    //ul[@class = 'ui-multiselect-checkboxes ui-helper-reset']/li/label[contains(@class,'ui-corner-all')]/span[contains(text(),'Month')]
${in_rp_mf_dt_selectfromdate}    //*[@id='dpkFromDate']
${in_rp_mf_dt_selecttodate}    //*[@id='dpkToDate']
${in_rp_mf_mo_selectfrommonth}    //*[@id='divMonthFrom']
${in_rp_mf_mo_selecttomonth}    //*[@id='divMonthTo']
${in_rp_mf_btnSearch}    //*[@id='btnSearch']
${in_rp_mf_btngenerate}    //*[@id='btnGenerate']
${in_rp_mf_dt_fromyear}    //div[@id='ui-datepicker-div']/div/div/select[2]/option[text()='[rp_mf_dt_fromyear]']
${in_rp_mf_dt_frommonth}    //*[@id='ui-datepicker-div']/div/div/select[1]/option[text()='[rp_mf_dt_frommonth]']
${in_rp_mf_dt_fromday}    //div[@id='ui-datepicker-div']/table//td[@data-month='[rp_mf_dt_frommonth]']/a[text()='[rp_mf_dt_fromday]]
${in_rp_mf_dt_toyear}    //div[@id='ui-datepicker-div']/div/div/select[2]/option[text()='[rp_mf_dt_toyear]]
${in_rp_mf_dt_tomonth}    //*[@id='ui-datepicker-div']/div/div/select[1]/option[text()='[rp_mf_dt_tomonth]']
${in_rp_mf_dt_today}    //div[@id='ui-datepicker-div']/table//td[@data-month='[rp_mf_dt_tomonth]']/a[text()='[rp_mf_dt_today]']
${in_rp_mf_dt_cboYear}    //div[@id='ui-datepicker-div']/div/div/select[@data-handler='selectYear']
${in_rp_mf_dt_cboMonth}    //*[@id='ui-datepicker-div']/div/div//select[@data-handler='selectMonth']
${in_rp_mf_dt_tblDate}    //div[@id='ui-datepicker-div']/table
${in_rp_mf_mo_fromyear}    //*[@id='divMonthFrom']/following-sibling::*//a[normalize-space(text())='[rp_mf_mo_fromyear]']    # //div[@class='ui-month-picker']//li/a[@year='${ds_rp_mf_mo_fromyear}']
${in_rp_mf_mo_frommonth}    //*[@id='divMonthFrom']/following-sibling::*//li[@year='[rp_mf_mo_fromyear]']//a[normalize-space(text())='[rp_mf_mo_frommonth]']    # //div[@class='ui-month-picker']//li[@year='${ds_rp_mf_mo_fromyear}']/ul/li/a[text()='${ds_rp_mf_mo_tomonth}']
${in_rp_mf_mo_toyear}    //*[@id='divMonthTo']/following-sibling::*//a[normalize-space(text())='[rp_mf_mo_toyear]']    # //div[@class='ui-month-picker second-month']//li/a[@year='${ds_rp_mf_mo_toyear}']
${in_rp_mf_mo_tomonth}    //*[@id='divMonthTo']/following-sibling::*//li[@year='[rp_mf_mo_toyear]']//a[normalize-space(text())='[rp_mf_mo_tomonth]']    # //div[@class='ui-month-picker second-month']//li[@year='${ds_rp_mf_mo_toyear}']/ul/li/a[text()='${ds_rp_mf_mo_tomonth}']
${in_rp_mf_yeardata}    //*[@name='multiselect_yearSelector']
${in_rp_mf_bettypedata}    //*[@name='multiselect_bettypeSelector']
${in_rp_mf_columnsdata}    //*[@name='multiselect_idColumns']
