table 33020017 "LC Amend - Vehicle Tracking"
{

    fields
    {
        field(1; "Version No."; Code[10])
        {
            Description = 'Version No. from LC Amendment table.';
            TableRelation = "LC Amend. Details"."Version No.";
        }
        field(2; "No."; Code[20])
        {
            Description = 'No. from LC Amendment table.';
            TableRelation = "LC Amend. Details".No.;
        }
        field(4; "Profoma Invoice No."; Code[20])
        {
            Description = 'Order No. of Vehicle purchase in case of NAV.';
        }
        field(5; "VC No."; Code[20])
        {
            Caption = 'Vehicle Configuration No.';
            Description = 'VC No. received from TATA';
            TableRelation = "Item Variant".Code;
        }
        field(6; "No. of Vehicle"; Decimal)
        {
            Caption = 'Quantity';

            trigger OnValidate()
            begin
                "Total Amount" := "Unit Price" * "No. of Vehicle";
            end;
        }
        field(7; "No. of Vehicle Received"; Decimal)
        {
            Caption = 'Quantity Received';
            Editable = false;
        }
        field(8; "Model Description"; Code[50])
        {
        }
        field(9; "Unit Price"; Decimal)
        {

            trigger OnValidate()
            begin
                "Total Amount" := "Unit Price" * "No. of Vehicle";
            end;
        }
        field(10; "Total Amount"; Decimal)
        {
            Editable = false;
        }
        field(11; Description; Text[250])
        {
        }
        field(12; "VC Description"; Text[30])
        {
            CalcFormula = Lookup("Item Variant".Description WHERE(Code = FIELD(VC No.)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Version No.", "No.", "VC No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

