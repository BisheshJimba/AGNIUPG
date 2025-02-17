table 25006141 "Service Plan Template Stage"
{
    Caption = 'Service Plan Template Stage';
    LookupPageID = 25006218;

    fields
    {
        field(10; "Template Code"; Code[10])
        {
            Caption = 'Template Code';
            TableRelation = "Service Plan Template";
        }
        field(20; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(36; Kilometrage; Integer)
        {
            CaptionClass = '7,25006141,36';
        }
        field(50; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(70; "Service Interval"; DateFormula)
        {
            Caption = 'Service Interval';
            Description = 'how to estimate current record starting from previous stage';
        }
        field(240; "Package No."; Code[20])
        {
            Caption = 'Package No.';
            TableRelation = "Service Package";
        }
        field(250; "Variable Field Run 2"; Decimal)
        {
            CaptionClass = '7,25006141,250';
        }
        field(260; "Variable Field Run 3"; Decimal)
        {
            CaptionClass = '7,25006141,260';
        }
    }

    keys
    {
        key(Key1; "Template Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ServPlanComment: Record "25006173";
    begin
        ServPlanComment.RESET;
        ServPlanComment.SETRANGE(Type, ServPlanComment.Type::"Plan Template Stage");
        ServPlanComment.SETRANGE("Plan No.", "Template Code");
        ServPlanComment.SETRANGE("Stage Code", Code);
        ServPlanComment.DELETEALL;
    end;

    var
        ServicePlanTemplate: Record "25006140";
}

