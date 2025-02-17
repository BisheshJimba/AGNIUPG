table 33020061 "General Master"
{
    DrillDownPageID = 33020295;
    LookupPageID = 33020295;

    fields
    {
        field(1; Category; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Sub Category"; Code[30])
        {
            NotBlank = true;
        }
        field(3; "Code"; Code[35])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                IF Category = 'WARD NO' THEN
                    IF STRLEN(Code) > 10 THEN
                        ERROR('Code should not be more than 10 character if Category is WARD NO');
            end;
        }
        field(4; Description; Text[150])
        {

            trigger OnValidate()
            begin
                IF Category = 'WARD NO' THEN
                    IF STRLEN(Description) > 50 THEN
                        ERROR('Description should not be more than 50 character if Category is WARD NO');
            end;
        }
        field(5; Disable; Boolean)
        {
        }
        field(10; "Sequence No."; Integer)
        {
        }
        field(11; "Auto Insert"; Boolean)
        {
        }
        field(100; "Document Type"; Option)
        {
            OptionCaption = ' ,Vehicle Transfer,Vehicle Service,Spares,General Procurement,Battery,Lube,Material,Vehicle Demo,Home UPS,Battery Scrap,Vehicle Dispatch,Vehicle Trial,Direct Vehicle,Rental Vehicle,Tyre Demo,Vehicle Maintainence,Test Drive,FA Transfer,Vehicle BodyBuild,Solar Project,Pravidik,Office Vehicle,Fuel Dispatch';
            OptionMembers = " ","Vehicle Transfer","Vehicle Service",Spares,"General Procurement",Battery,Lube,Material,"Vehicle Demo","Home UPS","Battery Scrap","Vehicle Dispatch","Vehicle Trial","Direct Vehicle","Rental Vehicle","Tyre Demo","Vehicle Maintainence","Test Drive","FA Transfer","Vehicle BodyBuild","Solar Project",Pravidik,"Office Vehicle","Fuel Dispatch";
        }
        field(50000; "Complaint Type"; Option)
        {
            OptionMembers = " ",Complaint;
        }
        field(50001; Section; Code[50])
        {
        }
        field(50002; "Approval Not Required"; Boolean)
        {
        }
        field(50003; "Last Modified Date"; Date)
        {
            Description = 'for integration with dealer purpose (SRT)';
        }
    }

    keys
    {
        key(Key1; Category, "Sub Category", "Code")
        {
            Clustered = true;
        }
        key(Key2; Description)
        {
        }
        key(Key3; "Code", Description)
        {
        }
        key(Key4; "Sequence No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }

    trigger OnInsert()
    begin
        "Last Modified Date" := TODAY;
    end;

    trigger OnModify()
    begin
        "Last Modified Date" := TODAY;
    end;

    trigger OnRename()
    begin
        "Last Modified Date" := TODAY;
    end;
}

