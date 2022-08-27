--------------------CREATE DIRECTORY------------------------------------
CREATE DIRECTORY test_dir AS 'C:\My Folder';
/
-------------------GET ALL THE EXISTING DIRECTORIES--------------------
SELECT * FROM all_directories;
/
-------------------READ FROM A FILE------------------------------------
SET SERVEROUTPUT ON;
DECLARE
    v_file UTL_FILE.FILE_TYPE;
    v_line VARCHAR2(32767);
BEGIN
    v_file := UTL_FILE.FOPEN('TEST_DIR', 'temp file.txt', 'R', 32767);
    LOOP
        UTL_FILE.GET_LINE(v_file, v_line);
        dbms_output.put_line (v_line);
    END LOOP;
    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('The whole file is read!');
            UTL_FILE.FCLOSE(v_file);
END;
/
-------------------GRANT OR REVOKE READ-WRITE PRIVILEGES---------------
GRANT READ, WRITE ON DIRECTORY test_dir TO hr;
REVOKE READ, WRITE ON DIRECTORY test_dir FROM hr;
/
-------------------WRITE TO A FILE USING PUT_LINE PROCEDURE-------------
DECLARE
    v_file UTL_FILE.FILE_TYPE;
BEGIN
    v_file := UTL_FILE.FOPEN('TEST_DIR', 'temp file.txt', 'w', 32767);
    FOR r_emp IN (select * from employees) LOOP
        UTL_FILE.PUT_LINE(v_file, r_emp.first_name||' '||r_emp.last_name);
    END LOOP;
    UTL_FILE.FCLOSE(v_file);
END;
/
-------------------WRITE TO A FILE USING PUT AND NEW_LINE---------------
DECLARE
    v_file UTL_FILE.FILE_TYPE;
BEGIN
    v_file := UTL_FILE.FOPEN('TEST_DIR', 'temp file.txt', 'w', 32767);
    FOR r_emp IN (select * from employees) LOOP
        UTL_FILE.PUT(v_file, r_emp.first_name||' '||r_emp.last_name);
        UTL_FILE.NEW_LINE(v_file);
    END LOOP;
    UTL_FILE.FCLOSE(v_file);
END;
/
-------------------WRITE TO A FILE USING PUTF---------------------------
DECLARE
    v_file UTL_FILE.FILE_TYPE;
BEGIN
    v_file := UTL_FILE.FOPEN('TEST_DIR', 'temp file.txt', 'w', 32767);
    FOR r_emp IN (select * from employees) LOOP
        UTL_FILE.PUTF(v_file, '--> %s %s',r_emp.first_name,r_emp.last_name);
        --UTL_FILE.NEW_LINE(v_file);
        --UTL_FILE.PUTF(v_file, '--> %s %s\n',r_emp.first_name,r_emp.last_name);
    END LOOP;
    UTL_FILE.FCLOSE(v_file);
END;
/
-------------------USING FFLUSH TO WRITE IMMEDIATELY-------------------
DECLARE
    v_file UTL_FILE.FILE_TYPE;
BEGIN
    v_file := UTL_FILE.FOPEN('TEST_DIR', 'temp file.txt', 'w', 32767);
    FOR r_emp IN (select * from employees) LOOP
        UTL_FILE.PUT_LINE(v_file,r_emp.first_name||' '||r_emp.last_name);
        --UTL_FILE.FFLUSH(v_file);
        --UTL_FILE.PUT_LINE(v_file,r_emp.first_name||' '||r_emp.last_name,true);
        DBMS_SESSION.SLEEP(1);
    END LOOP;
    UTL_FILE.FCLOSE(v_file);
END;
/
-------------------CHECK FILE ATTRIBUTES-----------------------------
DECLARE
    v_fexists       BOOLEAN;
    v_file_length   NUMBER;
    v_block_size    BINARY_INTEGER;
BEGIN
    UTL_FILE.FGETATTR('TEST_DIR','temp file.txt',v_fexists,v_file_length,v_block_size);
    IF v_fexists THEN
        DBMS_OUTPUT.PUT_LINE('The file exists');
        DBMS_OUTPUT.PUT_LINE('Its length is     :'||v_file_length);
        DBMS_OUTPUT.PUT_LINE('Its block size is :'||v_block_size);
    ELSE
        DBMS_OUTPUT.PUT_LINE('The file does not exist!');
    END IF;
END;
/
-------------------COPY THE FILE---------------------------------------
EXECUTE UTL_FILE.FCOPY('TEST_DIR','temp file.txt','TEST_DIR','temp file copy.txt');
/
-------------------COPY THE FILE EX2-----------------------------------
EXECUTE UTL_FILE.FCOPY('TEST_DIR','temp file.txt','TEST_DIR','temp file copy2.txt',1,5);
/
-------------------RENAME THE FILE-------------------------------------
EXECUTE UTL_FILE.FRENAME('TEST_DIR','temp file copy2.txt','TEST_DIR','temp file renamed.txt');
/
-------------------REMOVE THE FILE-------------------------------------
EXECUTE UTL_FILE.FREMOVE('TEST_DIR','temp file renamed.txt');
EXECUTE UTL_FILE.FREMOVE('TEST_DIR','temp file copy.txt');
EXECUTE UTL_FILE.FREMOVE('TEST_DIR','temp file.txt');
/
-------------------DROP THE DIRECTORY-----------------------------------
DROP DIRECTORY test_dir;