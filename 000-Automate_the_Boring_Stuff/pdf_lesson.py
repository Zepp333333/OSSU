import PyPDF2
import os


# pdfFile = open('meetingminutes1.pdf', 'rb')
# reader = PyPDF2.PdfFileReader(pdfFile)
# print(reader.numPages)
# page = reader.getPage(0)
# text = page.extractText()

'''for pageNum in range(reader.numPages):
    print(reader.getPage(pageNum).extractText())'''


pdfFile1 = open('meetingminutes1.pdf', 'rb')
pdfFile2 = open('meetingminutes2.pdf', 'rb')

reader1 = PyPDF2.PdfFileReader(pdfFile1)
reader2 = PyPDF2.PdfFileReader(pdfFile2)

writer = PyPDF2.PdfFileWriter()
for pageNum in range(reader1.numPages):
    page = reader1.getPage(pageNum)
    writer.addPage(page)
for pageNum in range(reader2.numPages):
    page = reader2.getPage(pageNum)
    writer.addPage(page)

outputFile = open('combined_minutes.pdf', 'wb')
writer.write(outputFile)
outputFile.close()
pdfFile1.close()
pdfFile2.close()

