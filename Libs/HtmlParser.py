#!/usr/bin/python
# encoding: utf-8

import BeautifulSoup as bs
import types
import re
from numpy import *

class HtmlParser(object):
    '''
    Class to support parse html content
    '''
    def __init__(self):
        self._content = None

    def _parse_eval(self, val):
        if type(val) == types.UnicodeType:
            string = val.replace('''\n''',' ').strip()
            return re.sub(' +',' ', string)
        if type(val) == types.StringType: return re.sub(' +',' ', val.replace('''\n''',' ').strip())
        if type(val) == types.LongType: return str(val)
        if type(val) == types.IntType: return int(val)
        if type(val) == types.FloatType: return float(val)
        if type(val) == types.BooleanType: return bool(val)
        if type(val) == types.NoneType: return ''
        else: return val

    def _fillna(self, data):
        '''
        Fill missing cell in table
        '''
        lens = array([len(i) for i in data])
        for r in array(data):
            if len(r) < lens.max():
                r.extend(full(lens.max()-len(r), ''))
        return data

################## Public methods #####################

    @staticmethod
    def parse_table(htmlParser_):
        '''
        Parse a table content from a table list. Need the htmlParser source and index of table to parse
        '''
        tmpData = []
        for row in htmlParser_._content.findAll('tr'):
            tmpRow = []
            for cell in row.findAll('td'):
                tmpCellVal = ''.join([unicode(s) for s in cell.findAll(text=True)])
                tmpRow.append(htmlParser_._parse_eval(tmpCellVal))
            tmpData.append(tmpRow)
        return htmlParser_._fillna(tmpData)

    @staticmethod
    def parse_table_header(htmlParser_):
        '''
        Parse a table header list from a table list. Need the htmlParser source and index of table to parse
        '''
        tmpheader = []
        for elem in htmlParser_._content.findAll('th'):
            tmpheader.append(htmlParser_._parse_eval(''.join([unicode(s) for s in elem.findAll(text=True)])))
        return tmpheader

    @staticmethod
    def get_html_file_content(filepath):
        '''
        Return a htmlParser object which holds html content from a html or text file
        '''
        with open(filepath) as fp:
            return HtmlParser.get_html_content(fp)

    @staticmethod
    def get_html_content(text):
        '''
        Return a htmlParser object from a block of html text
        '''
        new_iParser = HtmlParser()
        new_iParser._content = bs.BeautifulSoup(text)
        return new_iParser
