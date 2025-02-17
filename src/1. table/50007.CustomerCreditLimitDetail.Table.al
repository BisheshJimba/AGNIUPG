table 50007 "Customer Credit Limit Detail"
{

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(2; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center";
        }
        field(3; "Credit Limit (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Credit Limit (LCY)';
        }
        field(4; "Created By"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(5; "Last Modified By"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(6; "Created Date"; Date)
        {
            Editable = false;
        }
        field(7; "Last Modified Date"; Date)
        {
            Editable = false;
        }
        field(8; "Customer Name"; Text[100])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No.")));
        }
        field(9; Reason; Text[250])
        {
        }
        field(12; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(13; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(14; "Accountability Center"; Code[10])
        {
            TableRelation = "Accountability Center";
        }
    }

    keys
    {
        key(Key1; "Customer No.", "Global Dimension 1 Code", "Global Dimension 2 Code")
        {
            Clustered = true;
            SumIndexFields = "Credit Limit (LCY)";
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        Text000: Label 'Responsibility Center Cannot be Blank.';
        Text001: Label 'Accountability Center Cannot be Blank.';
    begin
        GLSetup.GET;
        "Created By" := USERID;
        "Created Date" := TODAY;
        "Last Modified By" := USERID;
        "Last Modified Date" := TODAY;
        IF NOT GLSetup."Use Accountability Center" THEN BEGIN
            IF "Responsibility Center" = '' THEN
                ERROR(Text000);
        END
        ELSE BEGIN
            IF "Accountability Center" = '' THEN
                ERROR(Text000);
        END;

        TESTFIELD("Global Dimension 1 Code");
        TESTFIELD("Global Dimension 2 Code");
    end;

    trigger OnModify()
    begin
        GLSetup.GET;
        "Last Modified By" := USERID;
        "Last Modified Date" := TODAY;
        TESTFIELD("Global Dimension 1 Code");
        TESTFIELD("Global Dimension 2 Code");
        IF NOT GLSetup."Use Accountability Center" THEN
            TESTFIELD("Responsibility Center")
        ELSE
            TESTFIELD("Accountability Center");
    end;

    var
        GLSetup: Record "General Ledger Setup";
}

