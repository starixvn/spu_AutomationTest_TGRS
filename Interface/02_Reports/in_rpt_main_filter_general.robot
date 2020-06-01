*** Settings ***
Resource          ../../Dataset/ds_rpt_main_filter.robot

*** Variables ***
${in_rp_mf_periodtype}    //*[@id='ddlPeriodType']/following-sibling::button
${in_rp_mf_periodtype_date}    //input[@name="multiselect_ddlPeriodType"]//following-sibling::span[normalize-space(text())='Date']
${in_rp_mf_periodtype_month}    //input[@name="multiselect_ddlPeriodType"]//following-sibling::span[normalize-space(text())='Month']
${in_rp_mf_dt_selectfromdate}    //*[@id='dpkFromDate']
${in_rp_mf_dt_selecttodate}    //*[@id='dpkToDate']
${in_rp_mf_mo_selectfrommonth}    //*[@id='divMonthFrom']
${in_rp_mf_mo_selecttomonth}    //*[@id='divMonthTo']
${in_rp_mf_btnSearch}    //*[@id='btnSearch']
${in_rp_mf_btngenerate}    //*[@id='btnGenerate']
${in_rp_mf_dt_fromyear}    //div[@id='ui-datepicker-div']//following-sibling::option[@value='[rp_mf_dt_fromyear]']
${in_rp_mf_dt_frommonth}    //div[@id='ui-datepicker-div']//following-sibling::option[text()='[rp_mf_dt_frommonth]']
${in_rp_mf_dt_fromday}    //div[@id='ui-datepicker-div']/table//td[@data-month='[rp_mf_dt_frommonth]']/a[text()='[rp_mf_dt_fromday]]
${in_rp_mf_dt_toyear}    //div[@id='ui-datepicker-div']//following-sibling::option[@value='[rp_mf_dt_toyear]]
${in_rp_mf_dt_tomonth}    //div[@id='ui-datepicker-div']//following-sibling::option[text()='[rp_mf_dt_tomonth]']
${in_rp_mf_dt_today}    //div[@id='ui-datepicker-div']/table//td[@data-month='[rp_mf_dt_tomonth]']/a[text()='[rp_mf_dt_today]']
${in_rp_mf_dt_cboYear}    //div[@id='ui-datepicker-div']//following-sibling::select[@data-handler='selectYear']
${in_rp_mf_dt_cboMonth}    //div[@id='ui-datepicker-div']//select[@data-handler='selectMonth']
${in_rp_mf_dt_tblDate}    //div[@id='ui-datepicker-div']/table
${in_rp_mf_mo_fromyear}    //*[@id='divMonthFrom']/following-sibling::*//a[normalize-space(text())='[rp_mf_mo_fromyear]']
${in_rp_mf_mo_frommonth}    //*[@id='divMonthFrom']/following-sibling::*//li[@year='[rp_mf_mo_fromyear]']//a[normalize-space(text())='[rp_mf_mo_frommonth]']
${in_rp_mf_mo_toyear}    //*[@id='divMonthTo']/following-sibling::*//a[normalize-space(text())='[rp_mf_mo_toyear]']
${in_rp_mf_mo_tomonth}    //*[@id='divMonthTo']/following-sibling::*//li[@year='[rp_mf_mo_toyear]']//a[normalize-space(text())='[rp_mf_mo_tomonth]']
