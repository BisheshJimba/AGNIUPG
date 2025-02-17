table 25006140 "Service Plan Template"
{
    Caption = 'Service Plan Template';
    LookupPageID = 25006205;

    fields
    {
        field(10; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(20; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(50; "Service Plan Type"; Code[10])
        {
            Caption = 'Service Plan Type';
            TableRelation = "Service Plan Type";
        }
        field(60; "Service Date Formula"; DateFormula)
        {
        }
        field(190; Adjust; Boolean)
        {
            Caption = 'Replan At Service Post';
        }
        field(200; Recurring; Boolean)
        {
            Caption = 'Recurring';
            Description = 'Auto Assign Tewplate';
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

    trigger OnDelete()
    var
        ServPlanTemplateStage: Record "25006141";
        ServPlanTemplateUsage: Record "25006156";
        ServPlanComment: Record "25006173";
    begin
        ServPlanTemplateStage.RESET;
        ServPlanTemplateStage.SETRANGE("Template Code", Code);
        ServPlanTemplateStage.DELETEALL(TRUE);
        /*
        ServPlanTemplateUsage.RESET;
        ServPlanTemplateUsage.SETRANGE("Template Code", Code);
        ServPlanTemplateUsage.DELETEALL;
        
        ServPlanComment.RESET;
        ServPlanComment.SETRANGE(Type, ServPlanComment.Type::"Plan Template");
        ServPlanComment.SETRANGE("Plan No.", Code);
        ServPlanComment.DELETEALL;
        */

    end;
}

