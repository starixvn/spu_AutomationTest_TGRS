from skpy import Skype, SkypeMsg, SkypeChats
from skpy import SkypeAuthException


class SkypeBot(object):
    """
    Skype bot for http skype chat
    """

    # Private #
    def __init__(self, username, password):
        self.bot = Skype(connect=False)
        self.bot.conn.setUserPwd(username, password)

    # Public
    def connect(self):
        if not self.bot.conn.connected:
            self.bot.conn.getSkypeToken()

    def expose(self):
        print(f"{self.bot.user}")
        print(f"Connected: {self.bot.conn.connected}")
        print(f"Token: {self.bot.conn.tokens.get('skype')}")
        print(f"Expire date: {self.bot.conn.tokenExpiry.get('skype')}")

    def single_chat(self, contact):
        return self.bot.contacts[contact].chat

    def group_chat(self, groupid):
        return self.bot.chats[groupid]
