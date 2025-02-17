table 33020161 "SP Daily Visit Line"
{

    fields
    {
        field(1; "Salesperson Code"; Code[10])
        {
            TableRelation = "SP Daily Visit Header"."Salesperson Code";
        }
        field(2; Year; Integer)
        {
            TableRelation = "SP Daily Visit Header".Year;
        }
        field(3; "Week No"; Integer)
        {
            TableRelation = "SP Daily Visit Header"."Week No";
        }
        field(4; Date; Date)
        {
        }
        field(5; "No. of Visit"; Integer)
        {
        }
        field(6; "C0-C3 Contacted"; Integer)
        {
        }
        field(7; C1; Integer)
        {
        }
        field(8; C2; Integer)
        {
        }
        field(9; C3; Integer)
        {
        }
        field(10; "New/Followup"; Option)
        {
            OptionMembers = " ",New,Followup;

            trigger OnValidate()
            var
                recProspectPipelineHistory: Record "33020198";
                Noofline: Integer;
            begin
                IF "New/Followup" = "New/Followup"::New THEN BEGIN
                    recProspectPipelineHistory.SETRANGE(recProspectPipelineHistory."New Date", Date);
                    recProspectPipelineHistory.SETRANGE(recProspectPipelineHistory."Prospect Line No", 1);
                    "No. of Visit" := recProspectPipelineHistory.COUNT;
                    recProspectPipelineHistory.SETRANGE(recProspectPipelineHistory."New Pipeline Code", 'C1');
                    IF recProspectPipelineHistory.FINDFIRST THEN
                        REPEAT
                            Noofline += 1;
                        UNTIL recProspectPipelineHistory.NEXT = 0;
                    C1 := Noofline;
                    CLEAR(Noofline);
                    recProspectPipelineHistory.SETRANGE(recProspectPipelineHistory."New Pipeline Code", 'C2');
                    IF recProspectPipelineHistory.FINDFIRST THEN
                        REPEAT
                            Noofline += 1;
                        UNTIL recProspectPipelineHistory.NEXT = 0;
                    C2 := Noofline;
                    CLEAR(Noofline);
                    recProspectPipelineHistory.SETRANGE(recProspectPipelineHistory."New Pipeline Code", 'C3');
                    IF recProspectPipelineHistory.FINDFIRST THEN
                        REPEAT
                            Noofline += 1;
                        UNTIL recProspectPipelineHistory.NEXT = 0;
                    C3 := Noofline;
                    CLEAR(Noofline);
                    recProspectPipelineHistory.SETRANGE(recProspectPipelineHistory."New Pipeline Code", 'C0');
                    IF recProspectPipelineHistory.FINDFIRST THEN
                        REPEAT
                            Noofline += 1;
                        UNTIL recProspectPipelineHistory.NEXT = 0;
                    C0 := Noofline;
                    CLEAR(Noofline);
                    recProspectPipelineHistory.SETRANGE(recProspectPipelineHistory."New Pipeline Code", 'F001');
                    IF recProspectPipelineHistory.FINDFIRST THEN
                        REPEAT
                            Noofline += 1;
                        UNTIL recProspectPipelineHistory.NEXT = 0;
                    F001 := Noofline;
                    CLEAR(Noofline);


                END;
                IF "New/Followup" = "New/Followup"::Followup THEN BEGIN
                    recProspectPipelineHistory.SETRANGE(recProspectPipelineHistory."New Date", Date);
                    recProspectPipelineHistory.SETFILTER(recProspectPipelineHistory."Prospect Line No", '<>%1', 1);
                    "No. of Visit" := recProspectPipelineHistory.COUNT;
                    recProspectPipelineHistory.SETRANGE(recProspectPipelineHistory."New Pipeline Code", 'C1');
                    IF recProspectPipelineHistory.FINDFIRST THEN
                        REPEAT
                            Noofline += 1;
                        UNTIL recProspectPipelineHistory.NEXT = 0;
                    C1 := Noofline;
                    CLEAR(Noofline);
                    recProspectPipelineHistory.SETRANGE(recProspectPipelineHistory."New Pipeline Code", 'C2');
                    IF recProspectPipelineHistory.FINDFIRST THEN
                        REPEAT
                            Noofline += 1;
                        UNTIL recProspectPipelineHistory.NEXT = 0;
                    C2 := Noofline;
                    CLEAR(Noofline);
                    recProspectPipelineHistory.SETRANGE(recProspectPipelineHistory."New Pipeline Code", 'C3');
                    IF recProspectPipelineHistory.FINDFIRST THEN
                        REPEAT
                            Noofline += 1;
                        UNTIL recProspectPipelineHistory.NEXT = 0;
                    C3 := Noofline;
                    CLEAR(Noofline);
                    recProspectPipelineHistory.SETRANGE(recProspectPipelineHistory."New Pipeline Code", 'C0');
                    IF recProspectPipelineHistory.FINDFIRST THEN
                        REPEAT
                            Noofline += 1;
                        UNTIL recProspectPipelineHistory.NEXT = 0;
                    C0 := Noofline;
                    CLEAR(Noofline);
                    recProspectPipelineHistory.SETRANGE(recProspectPipelineHistory."New Pipeline Code", 'F001');
                    IF recProspectPipelineHistory.FINDFIRST THEN
                        REPEAT
                            Noofline += 1;
                        UNTIL recProspectPipelineHistory.NEXT = 0;
                    F001 := Noofline;
                    CLEAR(Noofline);

                END;
            end;
        }
        field(11; C0; Integer)
        {
        }
        field(12; F001; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Salesperson Code", Year, "Week No", Date, "New/Followup")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

