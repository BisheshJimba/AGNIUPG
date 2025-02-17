table 33019817 "Vendor Selection Setup"
{

    fields
    {
        field(1; "Table No."; Integer)
        {
            NotBlank = true;
            TableRelation = "Table Information"."Table No.";

            trigger OnLookup()
            var
                TableInfoRec: Record "2000000028";
            begin
                IF PAGE.RUNMODAL(33020343, TableInfoRec) = ACTION::LookupOK THEN
                    "Table No." := TableInfoRec."Table No.";
            end;
        }
        field(2; "Field No."; Integer)
        {
            NotBlank = true;
            TableRelation = Field.No. WHERE(TableNo = FIELD(Table No.));

            trigger OnLookup()
            var
                FieldInfoRec: Record "2000000041";
            begin
                FieldInfoRec.RESET;
                FieldInfoRec.SETRANGE(TableNo, "Table No.");
                IF PAGE.RUNMODAL(33020344, FieldInfoRec) = ACTION::LookupOK THEN
                    "Field No." := FieldInfoRec."No.";
            end;
        }
        field(3; "Vendor No."; Code[20])
        {
            TableRelation = Vendor.No.;

            trigger OnValidate()
            begin
                GblVendor.RESET;
                GblVendor.SETRANGE("No.", "Vendor No.");
                IF GblVendor.FIND('-') THEN
                    "Vendor Name" := GblVendor.Name;
            end;
        }
        field(4; "Vendor Name"; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Table No.", "Field No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        GblVendor: Record "23";
}

