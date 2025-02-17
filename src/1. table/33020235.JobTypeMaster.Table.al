table 33020235 "Job Type Master"
{

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Job Type Description"; Text[50])
        {
        }
        field(3; "Bill to Customer"; Code[20])
        {
            TableRelation = Customer;
        }
        field(4; Type; Option)
        {
            OptionMembers = Service,Job;
        }
        field(5; "Fixed Price"; Boolean)
        {
            Description = 'Use for services like ''Sanjivani''';
        }
        field(6; AMC; Boolean)
        {
        }
        field(7; "Needs Warranty Approval"; Boolean)
        {
        }
        field(8; "Needs Approval"; Boolean)
        {
        }
        field(9; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));

            trigger OnValidate()
            begin
                IF "Shortcut Dimension 2 Code" <> '' THEN
                    TESTFIELD(Type, Type::Job);
            end;
        }
        field(50000; "Mobile No. Required"; Boolean)
        {
        }
        field(50001; Scheme; Boolean)
        {
        }
        field(55000; "Under Warranty"; Boolean)
        {
        }
        field(55001; "Post Warranty"; Boolean)
        {
        }
        field(55002; "Accidental Repair"; Boolean)
        {
        }
        field(55003; PDI; Boolean)
        {
        }
        field(55004; DSS; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "No.", Type)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Job Type Description")
        {
        }
    }
}

