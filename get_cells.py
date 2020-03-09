#!/usr/bin/python
import csv
import re
import sys



file_to_search = sys.argv[1]
file_to_write = sys.argv[2]
print(sys.argv)
s =  []
with open(file_to_search, mode='r') as f:
    reader = csv.DictReader(f, dialect='excel-tab')
    print(reader.fieldnames)
    
    if 'NoteText ' in reader.fieldnames:
        print("here")
        with open(file_to_write, 'w') as wf:
            print("here")
            writer = csv.writer(wf)
            for row in reader:
                 row['NoteText '] = re.sub('Pass \d:', '', row['NoteText '])
                 phone = re.search('[\d]{3}.?[\d]{3}.?[\d]{4}', row['NoteText '])
                 if phone:
                    print(row['NoteText '])
                    writer.writerow((row['Voter File VANID'], re.sub('\D', '', phone.group(0))))

    elif 'Notes' in reader.fieldnames:
        with open(file_to_write, 'w') as wf:
            writer = csv.writer(wf)
            for row in reader:
                 row['Notes'] = re.sub('Pass \d:', '', row['Notes'])
                 #row['Notes'] = re.sub('\D', '', row['Notes'])
                 #row['Notes'] = re.sub('[A-Za-z]', '', row['Notes'])
                 phone = re.search('[\d]{3}.?[\d]{3}.?[\d]{4}', row['Notes'])
                 if phone:
                    writer.writerow((row['VAN ID'], re.sub('\D', '', phone.group(0))))


