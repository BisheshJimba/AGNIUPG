table 33020798 "File Detail"
{
    Caption = 'File Detail';

    fields
    {
        field(5; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Sales Invoice,Sales Return Receipt,Sales Credit Memo,Purchase Invoice,Purchase Return Shipment,Purchase Credit Memo,Service Invoice,Service Credit Memo,Gen Jnl,Cash Rcpt Jnl,Payment Jnl,Recurring Gnl Jnl,LC Jnl,Others,Loan';
            OptionMembers = " ","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo","Service Invoice","Service Credit Memo","Gen Jnl","Cash Rcpt Jnl","Payment Jnl","Recurring Gnl Jnl","LC Jnl",Others,Loan;
        }
        field(8; "Resp Center / Jou Temp"; Code[10])
        {
            TableRelation = IF (Document Type=FILTER(Sales Invoice|Sales Return Receipt|Sales Credit Memo|Purchase Invoice|Purchase Return Shipment|Purchase Credit Memo|Service Invoice|Service Credit Memo)) "Responsibility Center".Code
                            ELSE IF (Document Type=FILTER(Gen Jnl|Cash Rcpt Jnl|Payment Jnl|Recurring Gnl Jnl|LC Jnl)) "Gen. Journal Template".Name;
        }
        field(12;"File No.";Code[20])
        {
        }
        field(13;"From Document No.";Code[20])
        {
        }
        field(14;"To Document No.";Code[20])
        {
        }
        field(15;"Creation Date";Date)
        {
        }
        field(17;"Closing Date";Date)
        {
        }
        field(18;Close;Boolean)
        {
        }
        field(19;"Location Code";Code[20])
        {
            TableRelation = Location;

            trigger OnValidate()
            begin
                UserSetup.GET(USERID);
                DefaultLocation := UserSetup."Default Location";
            end;
        }
        field(20;"Room No.";Code[10])
        {
            TableRelation = "Room - File Mgmt"."Room Code" WHERE (Location Code=FIELD(Location Code));
        }
        field(21;"Rack No.";Code[10])
        {
            TableRelation = "Rack - File Mgmt"."Rack Code" WHERE (Location Code=FIELD(Location Code),
                                                                  Room Code=FIELD(Room No.));
        }
        field(22;"Sub Rack No.";Code[10])
        {
            TableRelation = "SubRack - File Mgmt"."Sub Rack Code" WHERE (Location Code=FIELD(Location Code),
                                                                         Room Code=FIELD(Room No.),
                                                                         Rack Code=FIELD(Rack No.));
        }
        field(23;"Loan No.";Code[20])
        {
            TableRelation = "Vehicle Finance Header"."Loan No." WHERE (Approved=CONST(Yes));
        }
        field(24;"Responsible Person";Code[50])
        {
            TableRelation = Employee;
        }
        field(25;"External Transfer";Boolean)
        {
        }
        field(26;"Customer No.";Code[20])
        {
        }
        field(27;"Customer Name";Text[100])
        {
        }
        field(28;"Fiscal Year";Text[10])
        {
        }
    }

    keys
    {
        key(Key1;"Document Type","Resp Center / Jou Temp","File No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Document Type","File No.","Loan No.")
        {
        }
    }

    var
        LastEntryNo: Integer;
        FileLedgerEntry: Record "33020797";
        LedgerCreated: Boolean;
        FromDocNo: Code[20];
        ToDocNo: Code[20];
        UserSetup: Record "91";
        DefaultLocation: Code[100];
        CompInfo: Record "79";

    [Scope('Internal')]
    procedure CloseFileDetails(var TempFileDetail: Record "33020798" temporary;var FileDetail: Record "33020798";FileMgtSetup: Record "33020795"): Boolean
    var
        ClosedFile: Code[20];
        NoseriesMgt: Codeunit "396";
        FileLedgerEntry: Record "33020797";
        SourceCodeSetup: Record "242";
    begin
        TempFileDetail.TESTFIELD("Document Type");
        //TempFileDetail.TESTFIELD("Resp Center / Jou Temp");
        TempFileDetail.TESTFIELD("File No.");
        TempFileDetail.TESTFIELD(Close,FALSE);
        TempFileDetail.TESTFIELD("Location Code");
        TempFileDetail.TESTFIELD("Room No.");
        TempFileDetail.TESTFIELD("Rack No.");
        TempFileDetail.TESTFIELD("Sub Rack No.");
        TempFileDetail.TESTFIELD("From Document No.");
        TempFileDetail.TESTFIELD("To Document No.");
        TempFileDetail.TESTFIELD("Responsible Person");
        
        GetLastEntryNo;
        SourceCodeSetup.GET;
        CASE FileMgtSetup."Document Type" OF
         FileMgtSetup."Document Type"::"Sales Invoice": BEGIN
          ProcessDocuments(SourceCodeSetup.Sales,TempFileDetail,FileMgtSetup);
         END;
         FileMgtSetup."Document Type"::"Sales Credit Memo": BEGIN
          ProcessDocuments(SourceCodeSetup.Sales,TempFileDetail,FileMgtSetup);
         END;
         FileMgtSetup."Document Type"::"Purchase Invoice": BEGIN
          ProcessDocuments(SourceCodeSetup.Purchases,TempFileDetail,FileMgtSetup);
         END;
         FileMgtSetup."Document Type"::"Purchase Credit Memo": BEGIN
          ProcessDocuments(SourceCodeSetup.Purchases,TempFileDetail,FileMgtSetup);
         END;
         FileMgtSetup."Document Type"::"Gen Jnl": BEGIN
          ProcessDocuments(SourceCodeSetup."General Journal",TempFileDetail,FileMgtSetup);
         END;
         FileMgtSetup."Document Type"::"Cash Rcpt Jnl": BEGIN
          ProcessDocuments(SourceCodeSetup."Cash Receipt Journal",TempFileDetail,FileMgtSetup);
         END;
         FileMgtSetup."Document Type"::"Payment Jnl": BEGIN
          ProcessDocuments(SourceCodeSetup."Payment Journal",TempFileDetail,FileMgtSetup);
         END;
         FileMgtSetup."Document Type"::"Recurring Gnl Jnl": BEGIN
          ProcessDocuments(SourceCodeSetup."General Journal",TempFileDetail,FileMgtSetup);
         END;
         FileMgtSetup."Document Type"::"LC Jnl": BEGIN
          ProcessDocuments(SourceCodeSetup."Payment Journal",TempFileDetail,FileMgtSetup);
         END;
          FileMgtSetup."Document Type"::Loan: BEGIN
          ProcessDocuments(SourceCodeSetup."Payment Journal",TempFileDetail,FileMgtSetup);
         END;
        
        END;
        
        IF LedgerCreated THEN BEGIN
          FileDetail."Closing Date" := WORKDATE;
          FileDetail.Close := TRUE;
          FileDetail."From Document No." := FromDocNo;
          FileDetail."To Document No." := ToDocNo;
          FileDetail."Location Code" := TempFileDetail."Location Code";
          FileDetail."Room No." := TempFileDetail."Room No.";
          FileDetail."Rack No." := TempFileDetail."Rack No.";
          FileDetail."Sub Rack No." := TempFileDetail."Sub Rack No.";
          FileDetail."Loan No." := TempFileDetail."Loan No.";
          FileDetail."Responsible Person" := TempFileDetail."Responsible Person";
          FileDetail.MODIFY;
          ClosedFile := FileDetail."File No.";
          //THis function has been moved to close file function of file management setup 19 Aug 2015
          /*
          CLEAR(FileDetail);
          FileDetail.INIT;
          FileDetail."Document Type" := "Document Type";
          FileDetail."Resp Center / Jou Temp" := "Resp Center / Jou Temp";
          FileDetail."File No."      := NoseriesMgt.GetNextNo(FileMgtSetup."File No. Series",TODAY,TRUE);
          FileDetail."Creation Date" := TODAY;
          FileDetail.INSERT;
          */
          //THis function has been moved to close file function of file management setup 19 Aug 2015
          EXIT(TRUE);
        END;

    end;

    [Scope('Internal')]
    procedure InsertFileLedgerEntry(var TempFileDetail: Record "33020798" temporary;FileMgtSetup: Record "33020795";RecentDocNo: Code[20];var GLEntry: Record "17")
    var
        GLEntryRec: Record "17";
    begin
        FileLedgerEntry.INIT;
        FileLedgerEntry."Entry No."     := LastEntryNo + 1;
        FileLedgerEntry."Posting Date"  := WORKDATE;
        FileLedgerEntry."Document Type" := TempFileDetail."Document Type";
        FileLedgerEntry."Document No."  := RecentDocNo;
        FileLedgerEntry."File No."      := TempFileDetail."File No.";
        FileLedgerEntry."User ID"       := USERID;
        FileLedgerEntry."Entry Type"    := FileLedgerEntry."Entry Type" :: Initial;
        FileLedgerEntry.Open            := TRUE;
        FileLedgerEntry."Resp Center / Jou Temp" := TempFileDetail."Resp Center / Jou Temp";
        FileLedgerEntry."Rack Location" := TempFileDetail."Location Code";
        FileLedgerEntry."Room No." := TempFileDetail."Room No.";
        FileLedgerEntry."Rack No." := TempFileDetail."Rack No.";
        FileLedgerEntry."Sub Rack No." := TempFileDetail."Sub Rack No.";
        //utkrista for inserting loan no into the file ledger entry
        FileLedgerEntry."Loan No.":=TempFileDetail."Loan No.";
        FileLedgerEntry."G/L Posting Date" := TODAY;
        FileLedgerEntry."Responsible Person" := "Responsible Person";
        FileLedgerEntry.INSERT;
        LastEntryNo += 1;
        LedgerCreated := TRUE;
    end;

    [Scope('Internal')]
    procedure GetLastEntryNo()
    begin
        FileLedgerEntry.RESET;
        IF FileLedgerEntry.FINDLAST THEN
          LastEntryNo := FileLedgerEntry."Entry No."
        ELSE
          LastEntryNo := 0;
    end;

    [Scope('Internal')]
    procedure ProcessDocuments(SourceCode: Code[10];var TempFileDetail: Record "33020798";FileMgtSetup: Record "33020795")
    var
        GLEntry: Record "17";
        PreviousDocNo: Code[20];
        RecentDocNo: Code[20];
        LastRecord: Boolean;
    begin
        
          RecentDocNo := TempFileDetail."From Document No.";
          FromDocNo := TempFileDetail."From Document No.";
          ToDocNo :=  TempFileDetail."To Document No.";
        
         // REPEAT
         CompInfo.GET;
         IF CompInfo."Is Logistic" THEN BEGIN
             CheckFileStatus(TempFileDetail,FileMgtSetup,RecentDocNo);
             InsertFileLedgerEntry(TempFileDetail,FileMgtSetup,RecentDocNo,GLEntry);
           END ELSE BEGIN
            GLEntry.RESET;
            GLEntry.SETCURRENTKEY("Document No.","Posting Date");
            GLEntry.SETRANGE("Document No.",RecentDocNo);
            //GLEntry.SETRANGE("Source Code",SourceCode);
            IF NOT GLEntry.ISEMPTY THEN BEGIN
              CheckFileStatus(TempFileDetail,FileMgtSetup,RecentDocNo);
              InsertFileLedgerEntry(TempFileDetail,FileMgtSetup,RecentDocNo,GLEntry);
            END;
            IF RecentDocNo = TempFileDetail."To Document No." THEN
              LastRecord := TRUE
            ELSE
              RecentDocNo := INCSTR(RecentDocNo);
          END;
          //UNTIL LastRecord = TRUE;
        /*
        REPEAT
          GLEntry.RESET;
          GLEntry.SETCURRENTKEY("Document No.","Posting Date");
          GLEntry.SETRANGE("Document No.",RecentDocNo);
          //GLEntry.SETRANGE("Source Code",SourceCode);
          IF NOT GLEntry.ISEMPTY THEN BEGIN
            CheckFileStatus(TempFileDetail,FileMgtSetup,RecentDocNo);
            InsertFileLedgerEntry(TempFileDetail,FileMgtSetup,RecentDocNo,GLEntry);
            PreviousDocNo := RecentDocNo;
            IF NOT LastRecord THEN
              RecentDocNo := INCSTR(RecentDocNo)
            ELSE
              RecentDocNo := '';
          END ELSE BEGIN
            RecentDocNo := '';
          END;
          IF RecentDocNo = TempFileDetail."To Document No." THEN
            LastRecord := TRUE;
          ToDocNo := PreviousDocNo;
        UNTIL RecentDocNo = '';
        */

    end;

    [Scope('Internal')]
    procedure ProcessStdDocuments()
    begin
    end;

    [Scope('Internal')]
    procedure CheckFileStatus(var TempFileDetail: Record "33020798" temporary;FileMgtSetup: Record "33020795";RecentDocNo: Code[20])
    var
        FileLedgerEntry: Record "33020797";
    begin
        FileLedgerEntry.RESET;
        FileLedgerEntry.SETCURRENTKEY("Document Type","Resp Center / Jou Temp","File No.","Document No.",Open);
        FileLedgerEntry.SETRANGE("Document Type",TempFileDetail."Document Type");
        FileLedgerEntry.SETRANGE("Resp Center / Jou Temp",TempFileDetail."Resp Center / Jou Temp");
        FileLedgerEntry.SETRANGE("Document No.",RecentDocNo);
        IF FileLedgerEntry.FINDLAST THEN BEGIN
          ERROR('Document %1 of type %2 and %3 has already been allocated in following location.\' +
                  '--------------------------------------------------------------------------\' +
                  'Rack Location  : %4 \'+
                  'Room No.        : %5\'+
                  'Rack No.         : %6\'+
                  'Sub Rack No.  : %7',RecentDocNo,TempFileDetail."Document Type",TempFileDetail."Resp Center / Jou Temp",
                                    FileLedgerEntry."Rack Location",
                                    FileLedgerEntry."Room No.",
                                    FileLedgerEntry."Rack No.",
                                    FileLedgerEntry."Sub Rack No.");
        END;
    end;

    [Scope('Internal')]
    procedure InsertFileLedgerEntryForHirePurchase(var TempFileDetail: Record "33020798" temporary;FileMgtSetup: Record "33020795")
    var
        GLEntryRec: Record "17";
        VehicleFinHdr: Record "33020062";
    begin
        FileLedgerEntry.INIT;
        FileLedgerEntry."Entry No."     := LastEntryNo + 1;
        FileLedgerEntry."Posting Date"  := WORKDATE;
        FileLedgerEntry."Document Type" := TempFileDetail."Document Type";
        FileLedgerEntry."Loan No."      :=  TempFileDetail."Loan No.";
        FileLedgerEntry."File No."      := TempFileDetail."File No.";
        FileLedgerEntry."User ID"       := USERID;
        FileLedgerEntry."Entry Type"    := FileLedgerEntry."Entry Type" :: Initial;
        FileLedgerEntry.Open            := TRUE;
        FileLedgerEntry."Resp Center / Jou Temp" := TempFileDetail."Resp Center / Jou Temp";
        FileLedgerEntry."Rack Location" := TempFileDetail."Location Code";
        FileLedgerEntry."Room No." := TempFileDetail."Room No.";
        FileLedgerEntry."Rack No." := TempFileDetail."Rack No.";
        FileLedgerEntry."Sub Rack No." := TempFileDetail."Sub Rack No.";
        FileLedgerEntry.INSERT;
        LastEntryNo += 1;
        LedgerCreated := TRUE;
    end;
}

