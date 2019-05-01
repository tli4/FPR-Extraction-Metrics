"""
Title:: PDF Splitter - CSCE Department
Brief:: A simple application to read and extract the portion that contains CSCE and ENGR from TAMU grade distribution file
Author:: Khanh Nguyen
Date:: 04/30/2019
"""
'''
To create executable file for this app, the best way is to use pyinstaller:
pip install --upgrade setuptools
pip install pyinstaller
pyinstaller -F -w pdf_splitter.py
'''
from appJar import gui
from PyPDF2 import PdfFileWriter, PdfFileReader
from pathlib import Path
import progressbar
import time
import re
import os



# Define all the functions needed to process the files
def fnPDF_FindText(xFile):
    # xfile : the PDF file in which to look
    pageList = []
    progress_value = 0
    pdfDoc = PdfFileReader(open(xFile, "rb"))
    for i in range(0, pdfDoc.getNumPages()):
        content = pdfDoc.getPage(i).extractText()
        ResSearch = re.search('(ENGR-|CSCE)', content)
        progress_value += 100/(pdfDoc.getNumPages())
        app.setMeter("progress", value = progress_value)
        if ResSearch is not None:
            pageList.append(str(i+1)) # add 1 since page is indexed at 0
    rangeList= ','.join(pageList)
    return rangeList

def split_pages(input_file, page_range, out_file):
    """ Take a pdf file and copy a range of pages into a new pdf file

    Args:
        input_file: The source PDF file
        out_file: File name for the destination PDF
    """
    output = PdfFileWriter()
    input_pdf = PdfFileReader(open(input_file, "rb"))
    output_file = open(out_file, "wb")

    # https://stackoverflow.com/questions/5704931/parse-string-of-integer-sets-with-intervals-to-list
    page_ranges = (x.split("-") for x in page_range.split(","))
    range_list = [i for r in page_ranges for i in range(int(r[0]), int(r[-1]) + 1)]
    
    for p in range_list:
        # Need to subtract 1 because pages are 0 indexed
        try:
            output.addPage(input_pdf.getPage(p - 1))
        except IndexError:
            # Alert the user and stop adding pages
            app.infoBox("Info", "Range exceeded number of pages in input.\nFile will still be saved.")
            break
    output.write(output_file)

    if(app.questionBox("File Save", "Output PDF saved. Do you want to quit?")):
        app.stop()


def press(button):
    """ Process a button press

    Args:
        button: The name of the button. Either Process of Quit
    """
    if button == "Process":
        app.setMeter("progress", value = 0)

        src_file = app.getEntry("Input_File")
        if Path(src_file).suffix.upper() != ".PDF":
            app.infoBox("Error", "Invalid file type! Please select a PDF input file.")
            raise "Invalid file type!"

        dest_dir = app.getEntry("Output_Directory")
        if not dest_dir:
            app.infoBox("Error", "Please select an output directory")
            raise "No output directory!"

        page_range = fnPDF_FindText(src_file)
        out_file = ((os.path.basename(src_file))[:-4])+'_output.pdf'

        app.setMeter("progress", value = 100)
        split_pages(src_file, page_range, str(Path(dest_dir, out_file)))
            
    else:

        app.stop()            

# Create the GUI Window
app = gui("PDF Splitter - TAMU CSCE Department", useTtk=True, showIcon= False)
app.setTtkTheme("default")
app.setSize(400, 200)

# Add the interactive components
app.addLabel("This is an application to help extracting the portion \n that has 'CSCE' and 'ENGR' from TAMU grade distribution report.")
app.addLabel("Choose Source PDF File")
app.addFileEntry("Input_File")

app.addLabel("Select Output Directory")
app.addDirectoryEntry("Output_Directory")

# Progress bar
app.addLabel("")
app.addMeter("progress")
app.setMeterFill("progress", "blue")

# link the buttons to the function called press
app.addButtons(["Process", "Quit"], press)

# start the GUI
app.go()