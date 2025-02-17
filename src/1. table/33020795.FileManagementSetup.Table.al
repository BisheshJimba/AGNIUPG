table 33020795 "File Management Setup"
{
    Caption = 'FIle Management Setup';

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
            Caption = 'Resp Center / Jour Temp';
            TableRelation = IF (Document Type=FILTER(Sales Invoice|Sales Return Receipt|Sales Credit Memo|Purchase Invoice|Purchase Return Shipment|Purchase Credit Memo|Service Invoice|Service Credit Memo|Loan)) "Responsibility Center".Code
                            ELSE IF (Document Type=FILTER(Gen Jnl|Cash Rcpt Jnl|Payment Jnl|Recurring Gnl Jnl|LC Jnl)) "Gen. Journal Template".Name;

            trigger OnValidate()
            begin
                IF "Document Type" <> "Document Type" :: Others THEN BEGIN
                  FileSetup_G.RESET;
                  FileSetup_G.SETRANGE("Document Type","Document Type");
                  FileSetup_G.SETRANGE("Resp Center / Jou Temp","Resp Center / Jou Temp");
                  IF FileSetup_G.FINDFIRST THEN
                    ERROR('Record already exists with the %1 code',"Resp Center / Jou Temp");
                END;
            end;
        }
        field(10;"Line No.";Integer)
        {
        }
        field(12;"File No. Series";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(19;"Default Rack Location";Code[20])
        {
            TableRelation = Location;
        }
        field(20;"Default Room No.";Code[10])
        {
            TableRelation = "Room - File Mgmt"."Room Code";
        }
        field(21;"Default Rack No.";Code[10])
        {
            TableRelation = "Rack - File Mgmt"."Rack Code";
        }
        field(22;"Default Sub Rack No.";Code[10])
        {
            TableRelation = "SubRack - File Mgmt"."Sub Rack Code";
        }
        field(23;"Header Text 1";Text[30])
        {
        }
        field(24;"Header Text 2";Text[30])
        {
        }
        field(25;"Header Text 3";Text[30])
        {
        }
    }

    keys
    {
        key(Key1;"Document Type","Resp Center / Jou Temp","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        FileSetup_G: Record "33020795";
        NoseriesMgt: Codeunit "396";
        VehicleFinHdr: Record "33020062";

    [Scope('Internal')]
    procedure CloseFile()
    var
        FileDetails: Record "33020798";
        FileTrackingCard: Page "33020794";
                              CompInfo: Record "79";
    begin
        FileDetails.RESET;
        FileDetails.SETRANGE("Document Type","Document Type");
        FileDetails.SETRANGE("Resp Center / Jou Temp","Resp Center / Jou Temp");
        FileDetails.SETRANGE(Close,FALSE);
        IF NOT FileDetails.FINDFIRST THEN BEGIN
          IF CONFIRM('There are no files to be closed so it will create a new file. Do you want to proceed?',FALSE) THEN BEGIN
            FileDetails.INIT;
            FileDetails."Document Type" := "Document Type";
            FileDetails."Resp Center / Jou Temp" := "Resp Center / Jou Temp";
            FileDetails."File No."      := NoseriesMgt.GetNextNo("File No. Series",WORKDATE,TRUE);
            FileDetails."Creation Date" := WORKDATE;
            FileDetails.INSERT;
            COMMIT;

            FileTrackingCard.SetSource(FileDetails,Rec);
            FileTrackingCard.RUNMODAL;

          END;
          //ERROR('Nothing to close the file.')
        END ELSE BEGIN
          FileTrackingCard.SetSource(FileDetails,Rec);
          FileTrackingCard.RUNMODAL;

        END;
    end;
}

