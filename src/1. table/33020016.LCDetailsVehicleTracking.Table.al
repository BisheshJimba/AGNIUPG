table 33020016 "LC Details - Vehicle Tracking"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Description = 'No. from LC Details table.';
            TableRelation = "LC Details".No.;
        }
        field(3; "Profoma Invoice No."; Code[20])
        {
            Description = 'Order No. of Vehicle purchase in case of NAV.';
        }
        field(4; "VC No."; Code[20])
        {
            Caption = 'Vehicle Configuration No.';
            Description = 'VC No. received from TATA';

            trigger OnLookup()
            begin
                IF PAGE.RUNMODAL(5401, RecVariant) = ACTION::LookupOK THEN BEGIN
                    "VC No." := RecVariant.Code;
                    "Model Description" := RecVariant.Description;
                    Description := RecVariant."Description 2";
                END;
            end;
        }
        field(5; "No. of Vehicle"; Decimal)
        {
            Caption = 'Quantity';

            trigger OnValidate()
            begin
                "Total Amount" := "Unit Price" * "No. of Vehicle";
            end;
        }
        field(6; "No. of Vehicle Received"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE(System LC No.=FIELD(No.),
                                                                  Variant Code=FIELD(VC No.)));
            Caption = 'Quantity Received';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7;"Model Description";Code[50])
        {
        }
        field(8;"Unit Price";Decimal)
        {

            trigger OnValidate()
            begin
                "Total Amount" := "Unit Price" * "No. of Vehicle";
            end;
        }
        field(9;"Total Amount";Decimal)
        {
            Editable = false;
        }
        field(10;Description;Text[250])
        {
        }
        field(11;"VC Description";Text[30])
        {
            CalcFormula = Lookup("Item Variant".Description WHERE (Code=FIELD(VC No.)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"No.","VC No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        RecVariant: Record "5401";
}

