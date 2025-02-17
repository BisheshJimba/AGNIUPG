table 33020196 "CRM Attachment"
{
    Caption = 'CRM Attachment';

    fields
    {
        field(1; "Prospect No."; Code[20])
        {
            TableRelation = "SSI Header"."Prospect No.";
        }
        field(2; Attachment; BLOB)
        {
        }
        field(3; "File Name"; Text[100])
        {
        }
        field(4; "File Extension"; Text[20])
        {
        }
        field(5; "Attachment Type"; Option)
        {
            OptionCaption = ' ,SSI,TestDrive,DealFinal';
            OptionMembers = " ",SSI,TestDrive,DealFinal;
        }
    }

    keys
    {
        key(Key1; "Attachment Type", "Prospect No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

