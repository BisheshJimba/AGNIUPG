table 33019819 "Posted Vendor Comp. Line"
{
    Caption = 'Vendor Comparision Line';

    fields
    {
        field(1; "Fiscal Year"; Code[10])
        {
            TableRelation = "NCHL-NPI Approval Workflow".Code;
        }
        field(2; "Item Product Group"; Code[10])
        {
            TableRelation = "NCHL-NPI Approval Workflow".Description;
        }
        field(3; "Item No."; Code[20])
        {
            NotBlank = true;
            TableRelation = Item.No. WHERE(Item For=CONST(GPD));

            trigger OnValidate()
            begin
                CALCFIELDS("Item Name");

                GblItem.RESET;
                GblItem.SETRANGE("No.", "Item No.");
                IF GblItem.FIND('-') THEN
                    "Unit of Measure" := GblItem."Base Unit of Measure";
            end;
        }
        field(4; "Item Name"; Text[50])
        {
            CalcFormula = Lookup(Item.Description WHERE(No.=FIELD(Item No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5;"Vendor 1";Decimal)
        {
        }
        field(6;"Vendor 2";Decimal)
        {
        }
        field(7;"Vendor 3";Decimal)
        {
        }
        field(8;"Vendor 4";Decimal)
        {
        }
        field(9;"Vendor 5";Decimal)
        {
        }
        field(10;"Vendor 6";Decimal)
        {
            Description = 'Not used now';
        }
        field(11;"Vendor 7";Decimal)
        {
            Description = 'Not used now';
        }
        field(12;"Vendor 8";Decimal)
        {
            Description = 'Not used now';
        }
        field(13;"Vendor 9";Decimal)
        {
            Description = 'Not used now';
        }
        field(14;"Vendor 10";Decimal)
        {
            Description = 'Not used now';
        }
        field(15;"Unit of Measure";Code[10])
        {
            TableRelation = "Unit of Measure".Code;
        }
        field(16;"Chart No.";Integer)
        {
            TableRelation = "NCHL-NPI Approval Workflow"."Amount Filter";
        }
        field(17;"Vendor 1 Level";Code[10])
        {
            TableRelation = "NCHL-NPI Entry"."Entry No.";
        }
        field(18;"Vendor 2 Level";Code[10])
        {
            TableRelation = "NCHL-NPI Entry"."Entry No.";
        }
        field(19;"Vendor 3 Level";Code[10])
        {
            TableRelation = "NCHL-NPI Entry"."Entry No.";
        }
        field(20;"Vendor 4 Level";Code[10])
        {
            TableRelation = "NCHL-NPI Entry"."Entry No.";
        }
        field(21;"Vendor 5 Level";Code[10])
        {
            TableRelation = "NCHL-NPI Entry"."Entry No.";
        }
        field(22;"Vendor 6 Level";Code[10])
        {
            TableRelation = "NCHL-NPI Entry"."Entry No.";
        }
        field(23;"Vendor 7 Level";Code[10])
        {
            TableRelation = "NCHL-NPI Entry"."Entry No.";
        }
        field(24;"Vendor 8 Level";Code[10])
        {
            TableRelation = "NCHL-NPI Entry"."Entry No.";
        }
        field(25;"Vendor 9 Level";Code[10])
        {
            TableRelation = "NCHL-NPI Entry"."Entry No.";
        }
        field(26;"Vendor 10 Level";Code[10])
        {
            TableRelation = "NCHL-NPI Entry"."Entry No.";
        }
    }

    keys
    {
        key(Key1;"Fiscal Year","Item Product Group","Chart No.","Item No.")
        {
            Clustered = true;
            SumIndexFields = "Vendor 1","Vendor 2","Vendor 3","Vendor 4","Vendor 5","Vendor 6","Vendor 7","Vendor 8","Vendor 9","Vendor 10";
        }
    }

    fieldgroups
    {
    }

    var
        GblStplSysMngt: Codeunit "50000";
        GblItem: Record "27";
}

