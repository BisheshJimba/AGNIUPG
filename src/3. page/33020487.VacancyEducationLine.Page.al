page 33020487 "Vacancy Education Line"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = Table33020417;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Degree; Degree)
                {
                }
                field(Faculty; Faculty)
                {
                }
                field("College/ Institution"; "College/ Institution")
                {
                }
                field(University; University)
                {
                }
                field("Percentage/ GPA"; "Percentage/ GPA")
                {
                }
                field("Passed Year"; "Passed Year")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        educationLine.RESET;
        educationLine.SETRANGE("Employee Code", "Employee Code");
        IF educationLine.FINDFIRST THEN BEGIN
            REPEAT
                "Line No." := educationLine."Line No.";
                Degree := educationLine.Degree;
                Faculty := educationLine.Faculty;
            UNTIL educationLine.NEXT = 0;
        END;
    end;

    var
        educationLine: Record "33020420";
}

