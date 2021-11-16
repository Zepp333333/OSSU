import smtplib
import pyzmail
import imapclient


# conn = smtplib.SMTP('smtp.gmail.com', 587)
# conn.ehlo()
# conn.starttls()
# conn.login('ssnewhome@gmail.com', 'PASSWORD')
# conn.sendmail('ssnewhome@gmail.com', 'sergesazonov@gmail.com', 'Subject: test subj \n\n body')
# conn.close()

conn = imapclient.IMAPClient('imap.gmail.com', ssl=True)
conn.login('ssnewhome@gmail.com', 'PASSWORD')
conn.select_folder('INBOX', readonly=True)
UIDs = conn.search(['UNSEEN'])
rawMessage = conn.fetch(UIDs[0], ['BODY[]', 'FLAGS'] )
message = pyzmail.PyzMessage.factory(rawMessage[UIDs[0]][b'BODY[]'])
text = message.text_part.get_payload().decode('ISO-8859-1')
print(text)

conn.logout()
