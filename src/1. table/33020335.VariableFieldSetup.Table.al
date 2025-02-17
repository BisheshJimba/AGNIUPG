table 33020335 "Variable Field Setup"
{

    fields
    {
        field(1; "Table No."; Integer)
        {

            trigger OnLookup()
            begin
                /*LookUpMgt.LookUpVariableUsageObject("Table No.");
                VALIDATE("Table No.");
                */

            end;
        }
        field(2; "Field No."; Integer)
        {

            trigger OnLookup()
            begin
                /*
                FieldInfo.RESET;
                FieldInfo.SETRANGE(TableNo,"Table No.");
                IF FORM.RUNMODAL(33020301,FieldInfo) = ACTION::LookupOK THEN
                  "Field No." := FieldInfo."No.";
                 */

            end;

            trigger OnValidate()
            begin
                FieldInfo.RESET;
                FieldInfo.SETRANGE(TableNo, "Table No.");
                FieldInfo.SETRANGE("No.", "Field No.");
                IF FieldInfo.FIND('-') THEN
                    // "Field No." := FieldInfo."No.";
                    "Original Field Name" := FieldInfo.FieldName;
            end;
        }
        field(3; "Field Name"; Text[80])
        {
        }
        field(4; "Original Field Name"; Text[80])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Table No.", "Field No.", "Field Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        TableInfo: Record "2000000028";
        FieldInfo: Record "2000000041";
        TableInfoForm: Page "33020343";
        FieldInfoForm: Page "33020344";
        ObjectRec: Record "2000000001";
        LookUpMgt: Codeunit "25006003";
}

