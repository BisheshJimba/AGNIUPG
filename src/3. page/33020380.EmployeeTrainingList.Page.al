page 33020380 "Employee Training List"
{
    Editable = false;
    PageType = List;
    SourceTable = Table33020369;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee Code"; "Employee Code")
                {
                    Visible = true;
                }
                field("Request No."; "Request No.")
                {
                }
                field("Training Code"; "Training Code")
                {
                    Visible = true;
                }
                field("Training Topic"; "Training Topic")
                {
                }
                field("Request Date"; "Request Date")
                {
                }
                field("Completed Date"; "Completed Date")
                {
                }
                field(Completed; Completed)
                {
                }
                field("Fiscal Year"; "Fiscal Year")
                {
                }
                field("To Date"; "To Date")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        /* TrainingHeader.SETRANGE(Approved,TRUE);
         TrainingHeader.FIND('-');
         REPEAT
           MESSAGE(FORMAT(TrainingHeader."Tr. Req. No."));
           SETRANGE("Tr. Req. No.",TrainingHeader."Tr. Req. No.");
         UNTIL TrainingHeader.NEXT = 0;
          // MESSAGE(FORMAT(TrainingHeader."Tr. Req. No."));
         */

    end;

    var
        TrainingHeader: Record "33020359";
}

