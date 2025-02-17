table 33019987 "Courier Tracking Header"
{
    Caption = 'Courier Track. Header';

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = 'Transfer,Return';
            OptionMembers = Transfer,Return;
        }
        field(2; "No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    GblAdminSetup.GET;
                    GblNoSeriesMngt.TestManual(GetNoSeries);
                    "No. Series" := '';
                END;
            end;
        }
        field(3; "Transfer From Code"; Code[10])
        {
            TableRelation = Location.Code;

            trigger OnValidate()
            begin
                //Code to populate Transfer From details.
                GblLocation.RESET;
                GblLocation.SETRANGE(Code, "Transfer From Code");
                IF GblLocation.FIND('-') THEN BEGIN
                    "Transfer From Name" := GblLocation.Name;
                    "Transfer From Address" := GblLocation.Address;
                    "Transfer From Address 2" := GblLocation."Address 2";
                    VALIDATE("Transfer From Post Code", GblLocation."Post Code");
                    "Transfer From Contact" := GblLocation.Contact;
                END;
            end;
        }
        field(4; "Transfer To Code"; Code[10])
        {
            TableRelation = Location.Code;

            trigger OnValidate()
            begin
                //Code to populate Transfer To details.
                GblLocation.RESET;
                GblLocation.SETRANGE(Code, "Transfer To Code");
                IF GblLocation.FIND('-') THEN BEGIN
                    "Transfer To Name" := GblLocation.Name;
                    "Transfer To Address" := GblLocation.Address;
                    "Transfer To Address 2" := GblLocation."Address 2";
                    VALIDATE("Transfer To Post Code", GblLocation."Post Code");
                    "Transfer To Contact" := GblLocation.Contact;
                END;
            end;
        }
        field(5; "Transfer From Department"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));
        }
        field(6; "Transfer To Department"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));
        }
        field(7; Status; Option)
        {
            Editable = false;
            OptionMembers = Open,Released;
        }
        field(8; "Posting Date"; Date)
        {
        }
        field(9; "Document Date"; Date)
        {
            Description = 'Internally used for change tracking';
            Editable = false;
        }
        field(10; "Transfer From Name"; Text[50])
        {
        }
        field(11; "Transfer From Address"; Text[50])
        {
        }
        field(12; "Transfer From Address 2"; Text[50])
        {
        }
        field(13; "Transfer From Post Code"; Code[10])
        {
            TableRelation = "Post Code".Code;

            trigger OnValidate()
            begin
                CALCFIELDS("Transfer From City");
            end;
        }
        field(14; "Transfer From City"; Text[30])
        {
            CalcFormula = Lookup("Post Code".City WHERE(Code = FIELD(Transfer From Post Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Transfer From Contact"; Text[30])
        {
        }
        field(16; "Shipment Date"; Date)
        {
        }
        field(17; "Shipment Method Code"; Code[10])
        {
            TableRelation = "Shipment Method";
        }
        field(18; "Shipping Agent Code"; Code[10])
        {
            TableRelation = "Shipping Agent";
        }
        field(19; "Shipping Time"; Time)
        {
        }
        field(20; "Transfer To Name"; Text[50])
        {
        }
        field(21; "Transfer To Address"; Text[50])
        {
        }
        field(22; "Transfer To Address 2"; Text[50])
        {
        }
        field(23; "Transfer To Post Code"; Code[10])
        {
            TableRelation = "Post Code".Code;

            trigger OnValidate()
            begin
                CALCFIELDS("Transfer To City");
            end;
        }
        field(24; "Transfer To City"; Text[30])
        {
            CalcFormula = Lookup("Post Code".City WHERE(Code = FIELD(Transfer To Post Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(25; "Transfer To Contact"; Text[30])
        {
        }
        field(26; "Receipt Date"; Date)
        {
        }
        field(27; "Transaction Type"; Code[10])
        {
            TableRelation = "Transaction Type";
        }
        field(28; "Transport Method"; Code[10])
        {
            TableRelation = "Transport Method";
        }
        field(29; "CT No."; Code[20])
        {
        }
        field(30; Insurance; Boolean)
        {
        }
        field(31; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(32; "User ID"; Code[50])
        {
        }
        field(33; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center".Code;
        }
        field(35; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";
        }
        field(36; Ship; Boolean)
        {
            Description = 'Used internally while posting';
        }
        field(37; Receive; Boolean)
        {
            Description = 'Used internally while posting';
        }
        field(38; Return; Boolean)
        {
            Description = 'Used internally while posting';
        }
        field(39; "Applies To Entry"; Code[20])
        {
            Description = 'Used for Return Courier Shipment';
        }
        field(40; Shipped; Boolean)
        {
            Description = 'To check while posting receipt for shipment used internally.';
        }
        field(41; "Return Reason Code"; Code[10])
        {
            TableRelation = "Return Reason";
        }
        field(42; "Returned Date"; Date)
        {
        }
        field(33019961; "Accountability Center"; Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Text33019961: Label 'You cannot delete released document. Please contact your system administrator or change status to open.';
    begin
        //Code to check for Status and delete record. if Status is Released then delete is not allowed.
        IF Status <> Status::Released THEN BEGIN
            GblCTrackLine.RESET;
            GblCTrackLine.SETRANGE("Document Type", "Document Type");
            GblCTrackLine.SETRANGE("Document No.", "No.");
            IF GblCTrackLine.FIND('-') THEN
                GblCTrackLine.DELETEALL;
        END ELSE
            ERROR(Text33019961);
    end;

    trigger OnInsert()
    begin
        GblAdminSetup.GET;
        GblUserSetup.GET(USERID);

        IF "No." = '' THEN BEGIN
            TestNoSeries;
            GblNoSeriesMngt.InitSeries(GetNoSeries, xRec."No. Series", 0D, "No.", "No. Series");
        END;

        //Inserting source code to track the entry on Ledgers and Registers.
        GblSourceCodeSetup.GET;
        "Source Code" := GblSourceCodeSetup."Courier Tracking";

        "Responsibility Center" := GblUserSetup."Default Responsibility Center";
        "Accountability Center" := GblUserSetup."Default Accountability Center";
        "Posting Date" := TODAY;
        "Document Date" := TODAY;
        "User ID" := USERID;
        "Shipment Date" := TODAY;
    end;

    trigger OnModify()
    var
        Text33019962: Label 'You cannot modify released document. Please contact your system administrator or change status to open.';
    begin
        //Code to check for status and allow to modify records. If status is released then modify is not allowed.
        IF Status = Status::Released THEN
            ERROR(Text33019962);
    end;

    trigger OnRename()
    var
        Text33019963: Label 'You cannot modify released document. Please contact your system administrator or change status to open.';
    begin
        //Code to check for status and allow to rename records. If status is released then rename is not allowed.
        IF Status = Status::Released THEN
            ERROR(Text33019963);
    end;

    var
        GblAdminSetup: Record "33019964";
        GblNoSeriesMngt: Codeunit "396";
        GblSourceCodeSetup: Record "242";
        GblCTrackLine: Record "33019988";
        GblLocation: Record "14";
        GblUserSetup: Record "91";

    [Scope('Internal')]
    procedure AssistEdit(xCourierTrack: Record "33019987"): Boolean
    begin
        GblAdminSetup.GET;
        TestNoSeries;
        IF GblNoSeriesMngt.SelectSeries(GetNoSeries, xCourierTrack."No. Series", "No. Series") THEN BEGIN
            GblAdminSetup.GET;
            TestNoSeries;
            GblNoSeriesMngt.SetSeries("No.");
            EXIT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure TestNoSeries(): Boolean
    begin
        CASE "Document Type" OF
            "Document Type"::Transfer:
                GblAdminSetup.TESTFIELD("Transfer No.");
            "Document Type"::Return:
                GblAdminSetup.TESTFIELD("Return No.");
        END;
    end;

    [Scope('Internal')]
    procedure GetNoSeries(): Code[20]
    begin
        CASE "Document Type" OF
            "Document Type"::Transfer:
                EXIT(GblAdminSetup."Transfer No.");
            "Document Type"::Return:
                EXIT(GblAdminSetup."Return No.");
        END;
    end;
}

