table 33019814 "NCHL-NPI Entry"
{
    Caption = 'NCHL-NPI Entry';
    DrillDownPageID = 33019814;
    LookupPageID = 33019814;

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Posting Date"; Date)
        {
        }
        field(3; "Document No."; Code[20])
        {
        }
        field(4; "Line No."; Integer)
        {
        }
        field(5; Type; Option)
        {
            OptionCaption = ' ,Debtor,Creditor';
            OptionMembers = " ",Debtor,Creditor;
        }
        field(6; "End to End ID"; Code[30])
        {
        }
        field(7; "Debit Amount"; Decimal)
        {
        }
        field(8; "Credit Amount"; Decimal)
        {
        }
        field(9; "Batch Count"; Integer)
        {
            CalcFormula = Count("NCHL-NPI Entry" WHERE(Batch ID=FIELD(Batch ID),
                                                        Type=CONST(Creditor)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(10;"Batch Currency";Code[10])
        {
        }
        field(11;"Category Purpose";Code[30])
        {
            TableRelation = "NCHL-NPI Category Purpose";
        }
        field(12;Agent;Code[20])
        {
        }
        field(13;Branch;Text[30])
        {
        }
        field(14;Name;Text[200])
        {
        }
        field(15;"Account Type";Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        }
        field(16;"Account No.";Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF (Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting),
                                                                                      Blocked=CONST(No))
                                                                                      ELSE IF (Account Type=CONST(Customer)) Customer
                                                                                      ELSE IF (Account Type=CONST(Vendor)) Vendor
                                                                                      ELSE IF (Account Type=CONST(Bank Account)) "Bank Account"
                                                                                      ELSE IF (Account Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                                      ELSE IF (Account Type=CONST(IC Partner)) "IC Partner";
        }
        field(17;"Bank Account No.";Code[30])
        {
        }
        field(18;"ID Type";Code[10])
        {
        }
        field(19;"ID Value";Text[20])
        {
        }
        field(20;Address;Text[250])
        {
        }
        field(21;Phone;Text[30])
        {
        }
        field(22;Mobile;Text[30])
        {
        }
        field(23;Email;Text[50])
        {
        }
        field(24;"Addenda 1";Integer)
        {
        }
        field(25;"Addenda 2";Date)
        {
        }
        field(26;"Addenda 3";Text[35])
        {
        }
        field(27;"Addenda 4";Text[35])
        {
        }
        field(28;"Free Code 1";Text[20])
        {
        }
        field(29;"Free Code 2";Text[20])
        {
        }
        field(30;"Free Text 1";Text[100])
        {
        }
        field(31;"Free Text 2";Text[100])
        {
        }
        field(32;"Transaction Type";Option)
        {
            OptionCaption = ' ,Real Time,Non-Real Time';
            OptionMembers = " ","Real Time","Non-Real Time";
        }
        field(33;"Status Code";Text[250])
        {
            Description = 'Status Code';
        }
        field(34;"Sync. Status";Option)
        {
            OptionCaption = ' ,Sync In Progress,Completed,Cancelled';
            OptionMembers = " ","Sync In Progress",Completed,Cancelled;
        }
        field(35;"Batch ID";Code[20])
        {
        }
        field(36;"Batch ID Series";Code[20])
        {
            Editable = false;
        }
        field(37;"Status Description";Text[250])
        {
        }
        field(38;"Transaction Charge Amount";Decimal)
        {
        }
        field(39;"Transaction Response";Text[250])
        {
        }
        field(40;"Voucher Count";Integer)
        {
            CalcFormula = Count("NCHL-NPI Entry" WHERE (Document No.=FIELD(Document No.),
                                                        Type=CONST(Creditor)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(41;"Instruction ID";Code[30])
        {
        }
        field(42;"Created By";Code[50])
        {
        }
        field(43;"Created Time";Time)
        {
        }
        field(44;"Last Modified By";Code[50])
        {
        }
        field(45;"Last Modified Time";Time)
        {
        }
        field(46;"Source Code";Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(47;"NCHL-NPI Batch ID";Code[30])
        {
        }
        field(48;"NCHL-NPI Txn ID";Code[30])
        {
        }
        field(49;"Bank Name";Text[100])
        {
        }
        field(50;"Account Name";Text[100])
        {
        }
        field(51;"Last Modified Date";Date)
        {
        }
        field(52;"Created Date";Date)
        {
        }
        field(53;"OTP Code";Code[10])
        {
            ExtendedDatatype = Masked;
        }
        field(54;"OTP Generated Date Time";DateTime)
        {
        }
        field(55;"Balance Transfer Notified";Boolean)
        {
            Description = 'to recognize the entries whose mail or sms sent to receiver';
        }
        field(56;"Payment Date";Date)
        {
        }
        field(57;"Transaction Date";Date)
        {
        }
        field(58;"Transaction Time";Time)
        {
        }
        field(10000;"App ID";Code[20])
        {
            Description = 'NPI-DOCS1.00';
        }
        field(10002;"App ID Group";Option)
        {
            Description = 'NPI-DOCS1.00';
            OptionCaption = ' ,167,2';
            OptionMembers = " ","167","2";
        }
        field(10003;"Registration No.";Code[35])
        {
            Description = 'NPI-DOCS1.00';
        }
        field(10004;"Registration Year";Code[4])
        {
            Description = 'NPI-DOCS1.00';
            Numeric = true;
        }
        field(10005;"Instance IDs";Code[10])
        {
        }
        field(10006;"Company Codes";Code[15])
        {
        }
        field(10009;"Payment Types";Option)
        {
            OptionMembers = " ",IRD,CIT,Custom;
        }
        field(10010;"Registration Serial";Code[5])
        {
            Description = 'PAY1.0';
        }
        field(10011;"App Group";Code[20])
        {
        }
        field(10012;"Custom Office";Code[20])
        {
            Description = 'PAY1.0';
        }
        field(10013;"Company Code";Code[50])
        {
        }
        field(10014;"Instance Id";Code[10])
        {
        }
        field(10015;"Company Name";Text[50])
        {
        }
        field(10016;"Office Code";Code[20])
        {
        }
        field(10017;"Amount To Be Paid";Code[20])
        {
            Description = 'PAY1.0';
        }
        field(10018;"ID Tax";Code[20])
        {
        }
        field(10019;"VAT Amount";Code[20])
        {
        }
        field(10020;"CSF Amount";Code[20])
        {
        }
        field(10021;"VAT 2 Amount";Code[20])
        {
            Description = 'PAY1.0';
        }
        field(10022;Lodge;Boolean)
        {
        }
        field(10023;Confirmed;Boolean)
        {
        }
        field(10024;"Ref Id";Text[50])
        {
            Description = 'IRD,CIT Submission';
        }
        field(10026;"CIT Office Code";Text[50])
        {
            Description = 'CIT';
        }
        field(10027;"Original Amount";Decimal)
        {
        }
        field(10028;"API Status";Text[30])
        {
        }
        field(10029;"Response App Id";Text[30])
        {
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
        key(Key2;"Document No.","Posting Date")
        {
        }
        key(Key3;"Batch ID Series")
        {
        }
        key(Key4;"Document No.","Batch ID","Posting Date")
        {
        }
        key(Key5;Agent,"Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF "Sync. Status" IN ["Sync. Status"::Completed,"Sync. Status"::"Sync In Progress"] THEN
          ERROR('Unable to Delete')
    end;

    trigger OnInsert()
    begin
        "Created By" := USERID;
        "Created Time" := TIME;
        "Created Date" := WORKDATE;
    end;

    trigger OnModify()
    begin
        "Last Modified By" := USERID;
        "Last Modified Time" := TIME;
        "Last Modified Date" := WORKDATE;
    end;
}

