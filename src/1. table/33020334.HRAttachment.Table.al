table 33020334 "HR Attachment"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Table Name"; Option)
        {
            OptionMembers = " ",Application,Employee;
        }
        field(3; "Code"; Code[20])
        {
        }
        field(4; Attachment; BLOB)
        {
        }
        field(5; "File Extension"; Text[30])
        {
        }
        field(6; "Storage Option"; Option)
        {
            OptionMembers = Embedded,"Disk File";
        }
        field(7; Name; Text[100])
        {
        }
        field(8; "File Name"; Text[250])
        {
        }
        field(9; "No."; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        CommonDialogMngt: Codeunit "412";
        WordManagement: Codeunit "5054";
        AttachmentMngt: Codeunit "5052";
        FileName: Text[1024];
        HRSetup: Record "5218";
}

