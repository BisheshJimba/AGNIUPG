table 25006148 "Service Comment Line EDMS"
{
    // 04.04.2013 EDMS P8
    //   * Is extended options of field Type
    // 
    // 17.11.04 AB izveidota tabula

    Caption = 'Service Comment Line EDMS';
    DrillDownPageID = 25006188;
    LookupPageID = 25006188;

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Service Quote,Service Order,Symtom,Recall Campaign,Labor,External Service,Service Package,Service Package Specification,Contract,Vehicle,Service Return Order,Posted Service Order,Posted Service Return Order';
            OptionMembers = "Service Quote","Service Order",Symtom,"Recall Campaign",Labor,"External Service","Service Package","Service Package Specification",Contract,Vehicle,"Service Return Order","Posted Service Order","Posted Service Return Order";
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
        field(10; "Comment Type Code"; Code[20])
        {
            Caption = 'Comment Type Code';
            TableRelation = "Service Comment Line Type";
        }
        field(33020235; "Customer Complaint"; Text[200])
        {
        }
        field(33020236; "Immediate and Further Action"; Text[200])
        {
        }
        field(33020237; "Root Cause"; Text[200])
        {
        }
        field(33020238; "Warranty Complaint Code"; Code[10])
        {
            // TableRelation = "Customer Complain Master".No.;
            TableRelation = "Customer Complain Master"."No.";
        }
        field(33020239; "Warranty Complaint Description"; Text[250])
        {
            Editable = false;
            FieldClass = FlowField;
            //  CalcFormula = Lookup("Customer Complain Master".Description WHERE(No.=FIELD(Warranty Complaint Code)));
            CalcFormula = lookup("Customer Complain Master".Description where("No." = field("Warranty Complaint Code")));

        }
        field(33020240; "Jobs Done"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; Type, "No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        ServiceStepsChecking.CheckSteps("No.", Steps::CheckChecklist);
        "User ID" := USERID;
        ServiceMgtSetup.GET;
        IF "Comment Type Code" = '' THEN
            VALIDATE("Comment Type Code", ServiceMgtSetup."Service Comment Line Type");
    end;

    trigger OnModify()
    begin
        "User ID" := USERID;
    end;

    var
        ServiceMgtSetup: Record "25006120";
        ServiceStepsChecking: Codeunit "33020236";
        Steps: Option CheckBay,CheckChecklist,CheckDiagnosis;

    [Scope('Internal')]
    procedure SetUpNewLine()
    var
        SalesCommentLine: Record "44";
    begin
        SalesCommentLine.SETRANGE("Document Type", Type);
        SalesCommentLine.SETRANGE("No.", "No.");
        IF SalesCommentLine.ISEMPTY THEN
            Date := WORKDATE;
        ServiceMgtSetup.GET;
        IF "Comment Type Code" = '' THEN
            VALIDATE("Comment Type Code", ServiceMgtSetup."Service Comment Line Type");
    end;
}

