table 25006011 "Document Report"
{
    // 28.09.2007. EDMS P2
    //   * Added field Take From Lines

    Caption = 'Document Report';

    fields
    {
        field(5; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(10; "Document Functional Type"; Option)
        {
            Caption = 'Document Functional Type';
            OptionCaption = ' ,Sale,Purchase,Service,Transfer';
            OptionMembers = " ",Sale,Purchase,Service,Transfer;
        }
        field(20; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Shipment,Transfer,Posted Order,Posted Invoice,Posted Credit Memo,Posted Return Order,Posted Shipment,Contract,Process Checklist,Receipt';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Shipment,Transfer,"Posted Order","Posted Invoice","Posted Credit Memo","Posted Return Order","Posted Shipment",Contract,"Process Checklist",Receipt;
        }
        field(30; Sequence; Code[10])
        {
            Caption = 'Sequence';
            Numeric = true;
        }
        field(40; "Report ID"; Integer)
        {
            Caption = 'Report ID';
            TableRelation = Object.ID WHERE(Type = CONST(Report));

            trigger OnLookup()
            var
                ReportID: Integer;
            begin
                ReportID := 0;
                LookUpMgt.LookUpReport(ReportID);
                IF ReportID <> 0 THEN
                    VALIDATE("Report ID", ReportID);
            end;

            trigger OnValidate()
            begin
                //CALCFIELDS("Report Name");
            end;
        }
        field(50; "Custom Name"; Text[80])
        {
            Caption = 'Custom Name';
        }
        field(60; "Take From Lines"; Boolean)
        {
            Caption = 'Take From Lines';
        }
        field(70; "Customer Signature"; Boolean)
        {
            Caption = 'Customer Signature';
        }
        field(80; "Employee Signature"; Boolean)
        {
            Caption = 'Employee Signature';
        }
    }

    keys
    {
        key(Key1; "Document Profile", "Document Functional Type", "Document Type", Sequence)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        ReportSelection2: Record "Document Report";
        LookUpMgt: Codeunit 25006003;

    [Scope('Internal')]
    procedure NewRecord()
    begin
        ReportSelection2.SETRANGE("Document Profile", "Document Profile");
        ReportSelection2.SETRANGE("Document Functional Type", "Document Functional Type");
        ReportSelection2.SETRANGE("Document Type", "Document Type");
        IF ReportSelection2.FINDLAST AND (ReportSelection2.Sequence <> '') THEN
            Sequence := INCSTR(ReportSelection2.Sequence)
        ELSE
            Sequence := '1';
    end;

    [Scope('Internal')]
    procedure ShowReportName(): Text[80]
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        IF "Custom Name" <> '' THEN
            EXIT("Custom Name");

        AllObjWithCaption.RESET;
        AllObjWithCaption.SETRANGE("Object Type", AllObjWithCaption."Object Type"::Report);
        AllObjWithCaption.SETRANGE("Object ID", "Report ID");
        IF AllObjWithCaption.FINDFIRST THEN
            EXIT(AllObjWithCaption."Object Caption");

        EXIT('');
    end;
}

