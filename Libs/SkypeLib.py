from datetime import datetime, timedelta
from SkypeHTTP import SkypeBot

ROBOT_LISTENER_API_VERSION = 3
ROBOT_LIBRARY_SCOPE = 'GLOBAL'
_iTC = []


def end_test(data, result):
    _iTC.append(TestResult(data.name, data.longname, result.status, result.elapsedtime, result.message))


def close():
    skyp = SkypeBot('lex.khuat@starixvn.com', 'starixIT')
    skyp.connect()
    recipients = skyp.group_chat('19:6878c95e38444c5e8fa2d7f56381a17b@thread.skype')
    recipients.sendMsg(build_report(_iTC))


def hms(seconds):
    h = seconds // 3600
    m = seconds % 3600 // 60
    s = seconds % 3600 % 60
    return '{:d}h{:d}m{:d}s'.format(h, m, s)


def build_report(data):
    created_time = datetime.utcnow() + timedelta(hours=7)
    header = f'================ ' \
             f'TGRS PRODUCTION - AUTOMATION REPORT ON {created_time.strftime("%m-%d-%Y %H:%M:%S")} ' \
             f'================ '
    footer = f'============================================================================='
    body = '\n'.join(['%s %s (%s)%s' % (item.status,
                                        item.name,
                                        hms(int(item.duration / 1000)),
                                        '' if item.status == 'PASS' else ' - ' + item.message) for item in data])
    return f'{header}\n{body}\n{footer}'


class TestResult:
    def __init__(self, name, longname, status, duration, message):
        self.name = name
        self.longname = longname
        self.status = status
        self.duration = duration
        self.message = message
