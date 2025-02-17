page 33020203 "SP Daily Visit Lines"
{
    Caption = 'Daily Visit Details';
    PageType = ListPart;
    SourceTable = Table33020161;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; Date)
                {
                }
                field("New/Followup"; "New/Followup")
                {
                }
                field("No. of Visit"; "No. of Visit")
                {
                }
                field("C0-C3 Contacted"; "C0-C3 Contacted")
                {
                }
                field(F001; F001)
                {
                }
                field(C0; C0)
                {
                }
                field(C1; C1)
                {
                }
                field(C2; C2)
                {
                }
                field(C3; C3)
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        gblCRMMngt: Codeunit "33020142";
        gblSPDailyVisitDetails: Record "33020201";
        gblNoOfVisit: Integer;
}

