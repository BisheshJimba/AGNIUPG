table 33020202 "Salesperson Tgt - Model Wise"
{
    Caption = 'Salesperson Target';

    fields
    {
        field(1; "Salesperson Code"; Code[10])
        {
            TableRelation = "Salesperson Target"."Salesperson Code";
        }
        field(2; Year; Integer)
        {
            TableRelation = "Salesperson Target".Year;
        }
        field(3; "Week No"; Integer)
        {
            TableRelation = "Salesperson Target".Month;
        }
        field(4; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(5; Make; Code[20])
        {
            TableRelation = Make;
        }
        field(6; "Model No."; Code[20])
        {
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make));
        }
        field(7;"Model Version No.";Code[20])
        {

            trigger OnLookup()
            begin
                //Lookup Model Version.
                GblItem.RESET;
                IF GblLookupMgt.LookUpModelVersion(GblItem,"Model Version No.",Make,"Model No.") THEN
                 VALIDATE("Model Version No.",GblItem."No.");
            end;

            trigger OnValidate()
            begin
                //Code to bring model version name.
                GblItem.RESET;
                GblItem.SETRANGE("No.","Model Version No.");
                IF GblItem.FIND('-') THEN
                  "Model Version Name" := GblItem.Description;
            end;
        }
        field(8;"Model Version Name";Text[50])
        {
        }
        field(9;"Pipeline Code";Code[10])
        {
            Caption = 'Pipeline Code';
        }
        field(10;Quantity;Integer)
        {
        }
    }

    keys
    {
        key(Key1;"Salesperson Code",Year,"Week No","Line No.","Pipeline Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        GblLookupMgt: Codeunit "25006003";
        GblItem: Record "27";
}

