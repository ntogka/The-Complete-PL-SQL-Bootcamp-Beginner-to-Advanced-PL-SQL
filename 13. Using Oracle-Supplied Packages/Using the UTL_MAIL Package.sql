--Sending an email with the least number of parameters
BEGIN
    UTL_MAIL.send(
                  sender     => 'somebody@somedomain.com', 
                  recipients => 'oraclemaster@outlook.com',
                  subject    => 'Example 1: Test Email Subject',
                  message    => 'This is a test email from someone.'
                 );
END;
/
--Sending an email with specific names to the sender and recipients
BEGIN
    UTL_MAIL.send(
                  sender     => 'Some Person <somebody@somedomain.com>', 
                  recipients => 'Oracle Masters <oraclemaster@outlook.com>',
                  subject    => 'Example 2: Test Email Subject',
                  message    => 'This is a test email from someone.'
                 );
END;
/
--Sending an email with using all of the parameters
BEGIN
    UTL_MAIL.send(
                  sender     => 'somebody@somedomain.com', 
                  recipients => 'oraclemaster@outlook.com',
                  cc         => 'somemanager@somedomain.something,someotherperson@somedomain.something',
                  bcc        => 'someothermanager@somedomain.com',
                  subject    => 'Example 3: Test Email Subject',
                  message    => 'This is a test email from someone.',
                  mime_type  => 'text/plain; charset=us-ascii',
                  priority   => 1,
                  replyto    => 'somereplyaddress@somedomain.com'
                 );
END;
/
--Sending an email by dynamically filling the message body
DECLARE
    cursor cur_top_earning_emps is 
                    select employee_id, first_name, last_name, salary 
                    from hr.employees
                    where salary > 10000 
                    order by salary desc;
    v_message varchar2(32767);
BEGIN
    v_message := 'EMPLOYEE ID'||CHR(9)||'FIRST NAME'||CHR(9)||'LAST NAME'||CHR(9)||'EMPLOYEE ID'||CHR(13);
    for r_top in cur_top_earning_emps loop
        v_message := v_message||r_top.employee_id||CHR(9)||r_top.first_name||CHR(9)||r_top.last_name||CHR(9)||r_top.salary||CHR(13);
    end loop;
    
    UTL_MAIL.send(
                  sender     => 'topearnings@somedns.com', 
                  recipients => 'oraclemaster@outlook.com',
                  subject    => 'Example 4: The Employees Earning More Than $10000',
                  message    => v_message
                 );
END;
/
--Sending an HTTP mail
DECLARE
    cursor cur_top_earning_emps is 
                    select employee_id, first_name, last_name, salary 
                    from hr.employees
                    where salary > 10000 
                    order by salary desc;
    v_message varchar2(32767);
BEGIN
    v_message := '<!DOCTYPE html>
                    <html>
                       <head>
                          <meta charset=''Cp1252''>
                          <title>Top Earning Employees</title>
                          <meta name="viewport" content="width=device-width, initial-scale=1.0">
                          <style>
                             * {
                             margin: 0;
                             padding: 0;
                             }
                             body {
                             font: 14px/1.4 Georgia, Serif;
                             }
                             /*
                             Generic Styling, for Desktops/Laptops
                             */
                             table {
                             width: 100%;
                             border-collapse: collapse;
                             }
                             /* Zebra striping */
                             tr:nth-of-type(odd) {
                             background: #eee;
                             }
                             th {
                             background: #333;
                             color: white;
                             font-weight: bold;
                             }
                             td, th {
                             padding: 6px;
                             border: 1px solid #9B9B9B;
                             text-align: left;
                             }
                             @media
                             only screen and (max-width: 760px),
                             (min-device-width: 768px) and (max-device-width: 1024px)  {
                             table, thead, tbody, th, td, tr { display: block; }
                             thead tr { position: absolute;top: -9999px;left: -9999px;}
                             tr { border: 1px solid #9B9B9B; }
                             td { border: none;border-bottom: 1px solid #9B9B9B; position: relative;padding-left: 50%; }
                             td:before { position: absolute;top: 6px;left: 6px;width: 45%; padding-right: 10px; white-space: nowrap;}
                             /*
                             Label the data
                             */
                             td:nth-of-type(0):before { content: "EMPLOYEE_ID"; }
                             td:nth-of-type(1):before { content: "FIRST_NAME"; }
                             td:nth-of-type(2):before { content: "LAST_NAME"; }
                             td:nth-of-type(3):before { content: "SALARY"; }
                             }
                             }
                          </style>
                          <!--<![endif]-->
                       </head>
                       <body>
                          <h1 style = ''text-align :center; color:green;''>Employees Earning more than $10.000 Per/month</h1>
                          <br>
                          <table>
                             <thead>
                                <tr>
                                   <th>EMPLOYEE_ID</th>
                                   <th>FIRST_NAME</th>
                                   <th>LAST_NAME</th>
                                   <th>SALARY</th>
                                </tr>
                             </thead>
                             <tbody id="data">';
    for r_top in cur_top_earning_emps loop
        v_message := v_message|| '<tr>'||
                                     '<td align="right">'||r_top.employee_id||'</td>'||
                                     '<td>'||r_top.first_name||'</td>'||
                                     '<td>'||r_top.last_name||'</td>'||
                                     '<td align="right">'||r_top.salary||'</td>'||
                                 '</tr>';
                     
    end loop;
    v_message := v_message||'           </tbody>
                                      </table>
                                   </body>
                                </html>';
    UTL_MAIL.send(
                  sender     => 'topearnings@somedns.com', 
                  recipients => 'oraclemaster@outlook.com',
                  subject    => 'Example 5: The Employees Earning More Than $10000 (HTML Formatted)',
                  message    => v_message,
                  mime_type  => 'text/html'
                 );
END;
/
------------------SEND ATTACH RAW------------
--Create a temp table
CREATE TABLE temp_table(
  id        NUMBER,
  blob_data BLOB
);
/
--2) Create a directory object
CREATE OR REPLACE DIRECTORY BLOB_DIR AS 'C:\blob_directory\';
/
--3)Write a PL/SQL Block to load your external file into a BLOB/CLOB column.
DECLARE
  v_bfile       BFILE;
  v_blob        BLOB;
  v_dest_offset INTEGER := 1;
  v_src_offset  INTEGER := 1;
BEGIN
  INSERT INTO temp_table (id, blob_data)
      VALUES (222,  empty_blob())
          RETURNING blob_data INTO v_blob;
 
  v_bfile := BFILENAME('BLOB_DIR', 'test_file.jpeg'); 
  DBMS_LOB.fileopen(v_bfile, DBMS_LOB.file_readonly);
  DBMS_LOB.loadblobfromfile (
             dest_lob    => v_blob,              -- Destination lob
             src_bfile   => v_bfile,             -- Source file path and name in the OS
             amount      => DBMS_LOB.lobmaxsize, -- Maximum LOB size.
             dest_offset => v_dest_offset,       -- Destination offset.
             src_offset  => v_src_offset);       -- Source offset.
  DBMS_LOB.fileclose(v_bfile);
  COMMIT;
END;
/
--4) Check the table to see if we could insert the blob file or not
SELECT * FROM temp_table;
/
--5) Send email with an attachment
DECLARE
    v_file BLOB;
    v_rawbuf RAW(32767);
BEGIN
    select blob_data into v_file from temp_table where rownum = 1;
    v_rawbuf := dbms_lob.substr(v_file);
    UTL_MAIL.send_attach_raw
    (
        sender => 'somebody@somedomain.com',
        recipients => 'oraclemaster@outlook.com',
        subject => 'Example 6: Attachment Test',
        message => 'This is a raw data',
        attachment => v_rawbuf,
        att_inline => TRUE,
        att_filename => 'testImage.jpeg'
    );
END;
/
DROP DIRECTORY blob_dir;
DROP TABLE temp_table;
/
--5) Send email with a text attachment
BEGIN
    UTL_MAIL.send_attach_varchar2
    (
        sender => 'somebody@somedomain.com',
        recipients => 'oraclemaster@outlook.com',
        subject => 'Example 7: Text Attachment Test',
        message => 'This is a text data',
        attachment => 'This is the text that will be written inside of the text file.',
        att_inline => TRUE,
        att_filename => 'testTextFile.txt'
    );
END;