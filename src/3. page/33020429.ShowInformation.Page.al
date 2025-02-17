page 33020429 "Show Information"
{
    SourceTable = Table33020382;

    layout
    {
        area(content)
        {
            field(Opening; Opening)
            {
                Caption = 'Total No. of Openings';
            }
            field(TotalEmployed; TotalEmployed)
            {
                Caption = 'No. of Employee';
            }
            field(Remaining; Remaining)
            {
                Caption = 'Remaining No.';
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        VacancyLines.SETRANGE(VacancyLines."Vacancy No", "Vacancy No.");
        VacancyLines.SETRANGE(VacancyLines."Vacancy SubCode", xRec."Vacancy Code");
        IF VacancyLines.FINDFIRST THEN BEGIN
            Opening := VacancyLines."No. of Opening";
        END;
        //----------------------------
        ApplicationNew.SETRANGE(ApplicationNew."Vacancy No.", "Vacancy No.");
        ApplicationNew.SETRANGE(ApplicationNew."Vacancy Code", "Vacancy Code");
        IF ApplicationNew.FINDSET THEN BEGIN
            REPEAT
                IF ApplicationNew.Employed = TRUE THEN BEGIN
                    TotalEmployed := TotalEmployed + 1;
                END;
            UNTIL ApplicationNew.NEXT = 0;
        END;

        Remaining := Opening - TotalEmployed;
    end;

    trigger OnOpenPage()
    begin
        TotalEmployed := 0;
    end;

    var
        Opening: Integer;
        TotalEmployed: Integer;
        Remaining: Integer;
        VacancyLines: Record "33020381";
        ApplicationNew: Record "33020382";
}

