table 453 "Approval Code"
{
    Caption = 'Approval Code';
    // DrillDownPageID = 657;
    // LookupPageID = 657;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Linked To Table Name"; Text[50])
        {
            Caption = 'Linked To Table Name';
        }
        field(4; "Linked To Table No."; Integer)
        {
            Caption = 'Linked To Table No.';
            //TableRelation = Object.ID WHERE (Type = CONST (Table));
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Page));

            // trigger OnValidate()
            // begin
            //     Objects.SETRANGE(Type, Objects.Type::Table);
            //     Objects.SETRANGE(ID, "Linked To Table No.");
            //     IF Objects.FINDFIRST THEN
            //         "Linked To Table Name" := Objects.Name
            //     ELSE
            //         "Linked To Table Name" := '';
            // end;
            trigger OnValidate()

            begin
                AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."Object Type"::Table);
                AllObjWithCaption.SetRange("Object ID", "Linked To Table No.");
                if AllObjWithCaption.FindFirst() then
                    "Linked To Table Name" := AllObjWithCaption."Object Name"
                else
                    "Linked To Table Name" := '';
            end;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        // Objects: Record "2000000001";
        AllObjWithCaption: Record AllObjWithCaption;
}

