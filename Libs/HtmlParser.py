import pandas
from bs4 import BeautifulSoup


class HtmlParser(object):
    """
    Class to support parse html content
	Install from cmd:
        pip install pandas
        pip install beautifulsoup4
    """

    # ----------------- Private methods -------------------
    def __init__(self):
        self.__raw__ = None

    # ----------------- Public methods -------------------
    @staticmethod
    def get_childs(htmlParser_, tagname):
        """
        Return a list of child element base on expected tagname
        @param htmlParser_: html parser to find
        @param tagname: tagname to get
        @return: list of childs
        """
        return htmlParser_.__raw__.findAll(tagname)

    @staticmethod
    def parse_table(htmlParser_):
        """
        Parse a table from htmlparser object
        @return: a list dict virtualize the parsed table
        """
        # Parse header
        tmp_header = []
        for elem in htmlParser_.__raw__.findAll('th'):
            head = ''.join([str(s) for s in elem.findAll(text=True)])
            head = head.replace('\n', '').replace('\t', '').strip()
            tmp_header.append(head)

        # Parse content
        tmp_table = []
        for row in htmlParser_.__raw__.findAll('tr'):
            tmp_row = []
            for cell in row.findAll('td'):
                tmp_cell_val = ''.join([str(s) for s in cell.findAll(text=True)])
                tmp_cell_val = tmp_cell_val.replace('\n', '').replace('\t', '')
                tmp_row.append(tmp_cell_val)
            if tmp_row:
                diff = len(tmp_header) - len(tmp_row)
                if diff > 0:
                    tmp_row.extend([None] * diff)
                tmp_table.append(tmp_row)
        if tmp_header:
            return pandas.DataFrame(tmp_table, columns=tmp_header).to_dict('records')
        return pandas.DataFrame(tmp_table).to_dict('records')

    @staticmethod
    def get_html_file_content(filepath):
        """
        Return a htmlParser object which holds html content from a html or text file
        @param filepath: path to html file
        @return: self
        """
        with open(filepath) as fp:
            return HtmlParser.get_html_content(fp)

    @staticmethod
    def get_html_content(text):
        """
        Return a htmlParser object from a block of html text
        @param text: block of html content to format
        @return: self
        """
        new_iParser = HtmlParser()
        new_iParser.__raw__ = BeautifulSoup(text, 'html.parser')
        return new_iParser
