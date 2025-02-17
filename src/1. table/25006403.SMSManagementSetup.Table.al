table 25006403 "SMS Management Setup"
{

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
        }
        field(20; "SMS Provider Username"; Text[30])
        {
        }
        field(30; "SMS Provider Password"; Text[30])
        {
        }
        field(50; "Sms Batch Queue Expire Period"; Option)
        {
            OptionMembers = "2 Days","7 Days","14 Days";
        }
        field(70; "Sms Batch Queue Arch. Period"; Option)
        {
            OptionMembers = "30 Days","60 Days","90 Days";
        }
        field(80; "Enable Repliable SMS"; Boolean)
        {

            trigger OnValidate()
            begin
                IF "Enable Repliable SMS" <> FALSE THEN
                    IF "SMS Sender Id" <> '' THEN
                        ERROR(CantFillBothErr, FIELDCAPTION("Enable Repliable SMS"), FIELDCAPTION("SMS Sender Id"));
            end;
        }
        field(90; "SMS Sender Id"; Text[11])
        {

            trigger OnValidate()
            begin
                IF "SMS Sender Id" <> '' THEN
                    IF "Enable Repliable SMS" <> FALSE THEN
                        ERROR(CantFillBothErr, FIELDCAPTION("Enable Repliable SMS"), FIELDCAPTION("SMS Sender Id"));
            end;
        }
        field(100; "Provider URL"; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        CantFillBothErr: Label 'Fill only one field of %1 and %2';
}

