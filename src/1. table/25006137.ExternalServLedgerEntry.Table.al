table 25006137 "External Serv. Ledger Entry"
{
    // 15.07.2008. EDMS P2
    //   * Added key "Ext. Service No.,Ext. Service Tracking No.,Entry Type"

    Caption = 'External Serv. Ledger Entry';
    DrillDownPageID = 25006223;
    LookupPageID = 25006223;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "External Serv. No."; Code[20])
        {
            Caption = 'External Serv. No.';
            TableRelation = "External Service";
        }
        field(3; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Purchase,Sale';
            OptionMembers = Purchase,Sale;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(7; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(9; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(10; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(11; "External Serv. Tracking No."; Code[20])
        {
            Caption = 'External Serv. Tracking No.';
            TableRelation = "External Serv. Tracking No."."External Serv. Tracking No." WHERE(External Service No.=FIELD(External Serv. No.));
        }
        field(13;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;
        }
        field(28;"External Document No.";Code[20])
        {
            Caption = 'External Document No.';
        }
        field(30;"Source Type";Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Customer,Vendor';
            OptionMembers = " ",Customer,Vendor;
        }
        field(31;"Source No.";Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF (Source Type=CONST(Customer)) Customer.No.
                            ELSE IF (Source Type=CONST(Vendor)) Vendor.No.;
        }
        field(60;Amount;Decimal)
        {
            Caption = 'Amount';
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(33020235;"Service Order No.";Code[20])
        {
            Editable = false;
            TableRelation = "Service Header EDMS".No.;
        }
        field(33020236;VIN;Code[20])
        {
            CalcFormula = Lookup("Posted Serv. Order Header".VIN WHERE (Order No.=FIELD(Service Order No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020237;"Customer Name";Text[50])
        {
            CalcFormula = Lookup("Posted Serv. Order Header"."Bill-to Name" WHERE (Order No.=FIELD(Service Order No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020238;"SO for Sales";Code[20])
        {
            CalcFormula = Lookup("Sales Invoice Header"."Service Order No." WHERE (No.=FIELD(Document No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020239;"SO for Purchases";Code[20])
        {
            CalcFormula = Lookup("Purch. Inv. Header"."Service Order No." WHERE (No.=FIELD(Document No.)));
            Editable = false;
            FieldClass = FlowField;
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
        key(Key3;"External Serv. No.","Posting Date")
        {
        }
        key(Key4;"External Serv. No.","External Serv. Tracking No.","Entry Type")
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }

    [Scope('Internal')]
    procedure ShowDimensions()
    var
        DimMgt: Codeunit "408";
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
    end;
}

