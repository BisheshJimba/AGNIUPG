table 25006171 "Serv. Comment Line Arch. EDMS"
{
    // 17.11.04 AB izveidota tabula

    Caption = 'Serv. Comment Line Arch. EDMS';
    DrillDownPageID = 25006188;
    LookupPageID = 25006188;

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Service Quote,Service Order,Symtom,Cause,Labor,External Service,Service Package,Service Packages Specification,Contract,Vehicle,Service Return Order';
            OptionMembers = "Service Quote","Service Order",Symtom,Cause,Labor,"External Service","Service Package","Service Package Specification",Contract,Vehicle,"Service Return Order";
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Date; Date)
        {
            Caption = 'Date';
        }
        field(5; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(6; Comment; Text[80])
        {
            Caption = 'Comment';
        }
        field(7; "User ID"; Code[50])
        {
            Caption = 'User ID';

            trigger OnLookup()
            var
                LoginMgt: Codeunit "418";
            begin
                LoginMgt.LookupUserID("User ID");
            end;
        }
        field(8; "Doc. No. Occurrence"; Integer)
        {
            Caption = 'Doc. No. Occurrence';
        }
        field(9; "Version No."; Integer)
        {
            Caption = 'Version No.';
        }
        field(10; "Comment Type Code"; Code[20])
        {
            Caption = 'Comment Type Code';
            TableRelation = "Service Comment Line Type";
        }
        field(25006100; Satisfaction; Integer)
        {
            BlankZero = true;
            Caption = 'Satisfaction';
        }
        field(33020235; Complaint; Text[200])
        {
        }
        field(33020236; "Immediate and Further Action"; Text[200])
        {
        }
        field(33020237; "Root Cause"; Text[200])
        {
        }
    }

    keys
    {
        key(Key1; Type, "No.", "Doc. No. Occurrence", "Version No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    [Scope('Internal')]
    procedure SetUpNewLine()
    var
        SalesCommentLine: Record "44";
    begin
        SalesCommentLine.SETRANGE("Document Type", Type);
        SalesCommentLine.SETRANGE("No.", "No.");

        IF SalesCommentLine.ISEMPTY THEN
            Date := WORKDATE;
    end;
}

