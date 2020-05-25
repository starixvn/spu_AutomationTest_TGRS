import selenium, time, robot, os
from robot.libraries.BuiltIn import BuiltIn
from robot.api import logger
from Selenium2Library import __version__ as ver
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import WebDriverException

'''
        Extend the Selenium2Library with customized methods for checking element state (it is check, not assert)
        Require:
                - Selenium2Library (pip install robotframework-selenium2library)
        How to use:
                - Import as custom library
                - Call method on current focused WebDriver (browser) of Selenium2Library

        Version: 1.0
'''

def _version(strict=True): return float(ver[:ver.find('.', ver.find('.') + 1)]) if strict else ver
def _driver(): return BuiltIn().get_library_instance('Selenium2Library').driver
def _cache(): return BuiltIn().get_library_instance('Selenium2Library')._cache
def _action(): return ActionChains(_driver())
def _timeOut(s): return 0 if int(s) < 0 else int(s)
def _wait(s): return WebDriverWait(_driver(), _timeOut(s))

def _findElem(locator, firstOnly, required):
        return BuiltIn().get_library_instance('Selenium2Library').find_element(locator=locator)

def _wait_until_no_error(timeout, wait_func, *args):
        timeout = robot.utils.timestr_to_secs(timeout) if timeout is not None else 0
        maxtime = time.time() + timeout
        while True:
                timeout_error = wait_func(*args)
                print(timeout_error)
                if not timeout_error: return
                if time.time() > maxtime: raise AssertionError('Timeout waiting for element status with error: ' + timeout_error)
                time.sleep(0.2)
                
def _wait_until_true(timeout, wait_func, *args):
        timeout = robot.utils.timestr_to_secs(timeout) if timeout is not None else 0
        maxtime = time.time() + timeout
        while wait_func(*args) == False:
                if time.time() > maxtime: return False
                time.sleep(0.2)
        return True

##################### Check element conditions ##################       
def _check_exists(locator):
        try:
                element = _findElem(locator, True, False)
                if element is None: return False
                else: return True
        except WebDriverException as error: return False

def _check_visible(locator):
        try:
                element = _findElem(locator, True, False)
                if element is None: return False
                else: return element.is_displayed()
        except WebDriverException as error: return False
        except Exception as error: return False
                
def _check_invisible(locator):
        try:
                element = _findElem(locator, True, False)
                if element is None:
                        return True
                if not element.is_displayed():
                        return True
                return False
        except WebDriverException as error: return False

def _check_enable(locator):
        try:
                element = _findElem(locator, True, False)
                if element is None:
                        return False
                if not element.is_enabled():
                        return False
                read_only = element.get_attribute('readonly')
                if read_only == 'readonly' or read_only == 'true':
                        return False
                return True
        except WebDriverException as error: return False

def _check_alert_exists():
        try:
                alert = _driver().switch_to_alert()
                text = ' '.join(alert.text.splitlines()) # collapse new lines chars
                return True
        except WebDriverException: return False
        
##################### Verify element conditions ##################
##################################################################

def open_browser_in_chrome(url, download_location, alias=None, isHeadless=False):
        '''
                Run the browser (google chrome) possible headless mode (no UI)     
        '''
        if isinstance(isHeadless, basestring):
                isHeadless = True if isHeadless.lower() in ("yes", "true", "t", "1") else False
        wd = BuiltIn().get_library_instance('Selenium2Library')

        prefs = {'download.default_directory': os.path.abspath(download_location),
                 'download.directory_upgrade': True,
                 'download.prompt_for_download': False,
                 'safebrowsing.disable_download_protection': True,}
        options = webdriver.ChromeOptions()
        options.add_experimental_option('w3c', False)
        options.add_experimental_option('prefs', prefs)
        options.add_argument('--no-sandbox')
        options.add_argument('--disable-plugins')
        options.add_argument('--incognito')
        options.add_argument('--window-size=1920,1280')
        options.add_argument("--start-maximized")
        options.add_argument("--disable-background-networking")
        options.add_argument("--disable-default-apps")
        options.add_argument("--disable-extensions")
        options.add_argument("--disable-sync")
        options.add_argument("--disable-translate")
        options.add_argument("--hide-scrollbars")
        options.add_argument("--metrics-recording-only")
        options.add_argument("--mute-audio")
        options.add_argument("--no-first-run")
        #options.add_argument("--safebrowsing-disable-auto-update")
        options.add_argument("--ignore-certificate-errors")
        options.add_argument("--ignore-ssl-errors")
        options.add_argument("--ignore-certificate-errors-spki-list")
        if isHeadless:
                options.add_argument('--headless')
        rs = wd.create_webdriver(driver_name = 'Chrome',
                                 alias = alias,
                                 chrome_options = options)
        if isHeadless:
                enable_download_in_headless_chrome(download_location)
        wd.go_to(url)
        _driver().execute_script('window.confirm = function(){return true;}')
        return rs

def is_launched():
        '''
                Return whether any windows opened by webdriver or not
        '''
        return True if get_opened_browsers() else False
        
def download_page_source(filepath):
        '''
                Return the current page source html into filepath
        '''
        source = _driver().get_page_source()
        with open(os.path.normpath(filepath), 'w') as f:
                f.write(source.encode('ascii', 'ignore').decode('ascii'))

def get_webdriver_reference():
        '''
                Return the webdriver reference of current focused browser instance
        '''
        return _driver()

def get_selenium_version(strict=True):
        '''
                Return the current selenium version. Set param = False for full string or True for float number
        '''
        return _version(strict)

def is_alert_present(timeOut=0):
        '''
                Return true or false if an alert pop from browser (don't care the content).\n
        '''
        return _wait_until_true(timeOut, _check_alert_exists)

        
def does_element_exists(locator, timeOut=0):
        '''
                Checking that an element is present on the DOM of a page.\n
                This does not necessarily mean that the element is visible.\n
                Locator - used to find the element returns True once it is located
        '''
        return _wait_until_true(timeOut, _check_exists, locator)


def is_element_visible(locator, timeOut=0):
        '''
                Checking that an element is present on the DOM of a page and visible.\n
                Visibility means that the element is not only displayed but also has a height and width that is greater than 0.\n
                Locator - used to find the element returns True once it is located and visible
        '''
        return _wait_until_true(timeOut, _check_visible, locator)


def is_element_invisible(locator, timeOut=0):
        '''
                Checking that an element is either invisible or not present on the DOM.\n
                Locator used to find the element
        '''
        return _wait_until_true(timeOut, _check_invisible, locator)


def is_element_clickable(locator, timeOut=0):
        '''
                Checking an element is visible and enabled such that you can click it.
        '''
        return _wait_until_true(timeOut, _check_enable, locator)


def is_element_selected(locator, timeOut=0):
        '''
                Check whether the element to be located is selected
        '''
        try: return _wait(timeOut).until(EC.element_located_to_be_selected(Element(locator)._get()))
        except WebDriverException: return False


def does_attribute_exist(locator, attribute):
        '''
                Check whether the attribute exists in element or not
        '''

        element = _findElem(locator, True, False)
        jsScript = "return arguments[0].hasAttribute('" + attribute + "');"
        return _driver().execute_script(jsScript, element)

def is_text_present_in_element(locator, text, timeOut=0):
        '''
                Checking if the given text is present in the specified element\n
        '''
        try: _wait(timeOut).until(EC.text_to_be_present_in_element_value(Element(locator)._get(), text))
        except WebDriverException: return False
        return True


def is_frame_available(locator, timeOut=0):
        '''
                Checking whether the given frame is available to switch to.\n
                If the frame is available it switches the given driver to the specified frame
        '''
        try: _wait(timeOut).until(EC.frame_to_be_available_and_switch_to_it(Element(locator)._get()))
        except WebDriverException: return False
        return True


def is_title_equals(text, timeOut=0):
        '''
                An expectation for checking that the title contains a case-sensitive substring. \n
                Title is the fragment of title expected returns True when the title matches, False otherwise
        '''
        return _wait(timeOut).until(EC.title_is(text))


def is_title_contains(text, timeOut=0):
        '''
                Checking the title of a page.\n
                Title is the expected title, which must be an exact match returns True if the title matches, false otherwise.
        '''
        return _wait(timeOut).until(EC.title_contains(text))

def wait_for_alert(timeOut=0, msg=None):
        '''
                Wait until an alert pop from browser (don't care the content).\n
                Assert fail with msg content if could not pass the condition
        '''
        if not _wait_until_true(timeOut, _check_alert_exists):
                if msg is not None:
                        raise Exception(msg)


def wait_until_visible(locator, timeOut=0, msg=None):
        '''
                Wait until an element is visible and present on the DOM.\n
                Locator used to find the element. Assert fail with msg content if could not pass the condition
        '''
        if not _wait_until_true(timeOut, _check_visible, locator):
                if msg is not None:
                        raise Exception(msg)
        else: print('Element %s is now appear on UI' % locator)


def wait_until_invisible(locator, timeOut=0, msg=None):
        '''
                Wait until an element is invisible or not present on the DOM.\n
                Locator used to find the element. Assert fail with msg content if could not pass the condition
        '''
        if not _wait_until_true(timeOut, _check_invisible, locator):
             if msg is not None:
                     raise Exception(msg)
        else: print('Element %s is now disappear from UI' % locator)


def get_browser_capabilities():
        '''
                Return all information about browser instance in a dictionary
        '''
        return _driver().capabilities


def get_opened_browsers():
        '''
                Return all opened browser instances in a list
        '''
        return _cache().get_open_browsers()


def get_closed_browsers():
        '''
                Return all closed browser instances in a list
        '''
        return _cache()._closed


def get_focused_browser():
        '''
                Return the current focused browser instance
        '''
        return _cache().current


def get_focused_browser_alias():
        '''
                Return the current focused browser alias. If no browsers or focused browser does not has alias return None
        '''
        cur = get_focused_browser()
        for i, b in enumerate(get_opened_browsers()):
                if cur == b:
                        try: return _cache()._aliases._data.keys()[_cache()._aliases._data.values().index(i + 1)]
                        except Exception: return None


def is_browser_opened(alias_or_index=None):
        '''
                Check whether the browser exists or not by non-casesensitive registered alias or index\n
                If no index or alias is used, if at least 1 instance of WebDriver is opened will return true
        '''
        if alias_or_index == None:
                return True if len(get_opened_browsers()) > 0 else False

        try: browser = _cache().get_connection(alias_or_index.lower())
        except RuntimeError: return False

        for i, b in enumerate(get_opened_browsers()):
                if browser == b: return True
        return False


def close_browser_by_alias(alias_or_index):
        '''
                Switch then close an opening browser with the expected alias or index. Do nothing if no browsers are found with the expected alias\n
                Return True/False for successfully/fail close action
        '''
        if is_browser_opened(alias_or_index):
                try:
                        _cache().switch(alias_or_index.lower())
                        _cache().close()
                        return True
                except Exception: raise Exception('Failed to close browser instance by runtime error.')
        else:
                print('Skip due to found no browsers with the alias: \'' + str(alias_or_index) + '\' to close')
                return False

def enable_download_in_headless_chrome(download_dir):
    _driver().command_executor._commands["send_command"] = ("POST", '/session/$sessionId/chromium/send_command')
    params = {'cmd': 'Page.setDownloadBehavior', 'params': {'behavior': 'allow', 'downloadPath': download_dir}}
    return _driver().execute("send_command", params)

def move_to_element(locator):
        '''
                Focus to the element by locator.
        '''
        _findElem(locator, True, False).send_keys(Keys.NULL)


def select_list_option_by_label(locator, option):
        '''
                Select an option from a list by it's label.
        '''
        element = _findElem(locator, True, False)
        jsScript = "for (var i = 0; i < arguments[0].options.length; i++) {if (arguments[0].options[i].text ==='%s') {arguments[0].selectedIndex = i;break;}}" % option
        _driver().execute_script(jsScript, element)

def click_element_by_js(locator):
        '''
                Click on element by using js
        '''
        element = _findElem(locator, True, False)
        jsScript = "arguments[0].click();"
        _driver().execute_script(jsScript, element)
        
def input_value_by_js(locator_name, value):
        '''
                Click on element by using js
        '''
        jsScript = "document.getElementsByName('%s')[0].value = '%s';" % (str(locator_name), str(value))
        _driver().execute_script(jsScript)
		
def unfocus_element(locator):
        '''
                Un-focus from the element by locator.
        '''
        element = _findElem(locator, True, False)
        _driver().execute_script("arguments[0].blur();", element)
		
def set_element_attribute(locator, attribute, value):
        '''
                Update an element attribute with new value
        '''
        element = _findElem(locator, True, False)
        jsScript = "arguments[0].setAttribute('" + attribute + "','" + value + "')"
        print("Set element attribute " + attribute + " to: " + value)
        _driver().execute_script(jsScript, element)

def get_element_attribute(locator, attribute):
        '''
                Get an element attribute
        '''
        element = _findElem(locator, True, False)
        return element.get_attribute(attribute)

def set_element_text(locator, value):
        '''
                Update an element text with new value
        '''
        element = _findElem(locator, True, False)
        jsScript = "arguments[0].textContent = " + value + ";"
        print("Set element text to: " + value)
        _driver().execute_script(jsScript, element)

def set_element_value(locator, value):
        '''
                Update an element value with new value
        '''
        element = _findElem(locator, True, False)
        jsScript = "arguments[0].value = " + value + ";"
        print("Set element value to: " + value)
        _driver().execute_script(jsScript, element)
        
##################### Keyboard input ##################
#######################################################

def key_input(key, locator=None):
        '''
                Sends keys to element. If no element is specified then send key to focused element
        '''
        if locator != None: move_to_element(locator)
        _action().send_keys(key).perform()
                
def key_paste(locator=None):
        '''
                Perform Ctrl + V to paste from a clipboard value. If no element is specified then execute on focused element
        '''
        if locator != None: move_to_element(locator)
        _action().key_down(Keys.CONTROL).send_keys('v').key_up(Keys.CONTROL).perform()
        
def key_select_all(locator=None):
        '''
                Perform Ctrl + A to select all content of focused element. If no element is specified then execute on focused area
        '''
        if locator != None: move_to_element(locator)
        _action().key_down(Keys.CONTROL).send_keys('a').key_up(Keys.CONTROL).perform()
        
def key_copy(locator=None):
        '''
                Perform Ctrl + C to copy selected content of an element. If no element is specified then execute on focused element
        '''
        if locator != None: move_to_element(locator)
        _action().key_down(Keys.CONTROL).send_keys('c').key_up(Keys.CONTROL).perform()
