table 25006407 "Warranty Reimbursment Entry"
{
    Caption = 'Warranty Reimbursment Entry';
    LookupPageID = 25006409;

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(14; "Document No."; Code[20])
        {
        }
        field(20; "Warranty Document No."; Code[20])
        {
            Caption = 'Warranty Document No.';
        }
        field(30; "Warranty Document Line No."; Integer)
        {
            Caption = 'Warranty Document Line No.';
        }
        field(40; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(50; "Debit Code"; Code[20])
        {
            Caption = 'Debit Code';
        }
        field(55; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Labor,External Service';
            OptionMembers = " ","G/L Account",Item,Labor,"External Service";

            trigger OnValidate()
            var
                ServiceHeader: Record "25006145";
                recMarkup: Record "25006741";
                recItemDisc: Record "7004";
                recLabTransl: Record "25006127";
                recItemTransl: Record "30";
            begin
            end;
        }
        field(60; "Debit Description"; Text[50])
        {
            Caption = 'Debit Description';
        }
        field(70; "Reject Code"; Code[20])
        {
            Caption = 'Reject Code';
        }
        field(80; "Reject Description"; Text[50])
        {
            Caption = 'Reject Description';
        }
        field(90; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Approved,Rejected;
        }
        field(100; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(110; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(140; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(145; VIN; Code[20])
        {
            Caption = 'VIN';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnLookup()
            var
                Vehicle: Record "25006005";
            begin
            end;
        }
        field(150; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(160; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            Editable = false;
            TableRelation = Make;
        }
        field(170; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make Code));
        }
        field(180;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item.No. WHERE (Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code),
                                            Item Type=CONST(Model Version));

            trigger OnLookup()
            var
                recItem: Record "27";
                LookupMgt: Codeunit "25006003";
            begin
            end;
        }
        field(190;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle";
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

