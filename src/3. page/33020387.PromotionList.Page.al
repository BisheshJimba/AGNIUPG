page 33020387 "Promotion List"
{
    CardPageID = "Promotion Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020361;
    SourceTableView = WHERE(Recommended For Promotion=CONST(Yes),
                            Promotion=CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee Code"; "Employee Code")
                {
                }
                field(Name; Name)
                {
                }
                field(Designation; Designation)
                {
                }
                field(Department; Department)
                {
                }
                field(Branch; Branch)
                {
                }
                field("Overall Rating"; "Overall Rating")
                {
                }
                field("Recommended For Promotion"; "Recommended For Promotion")
                {
                }
                field("Previous Appraisal Rating I"; "Previous Appraisal Rating I")
                {
                }
                field("Previous Appraisal Rating II"; "Previous Appraisal Rating II")
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
        Calendar.SETRANGE("English Date", TODAY);
        IF Calendar.FIND('-') THEN
            CurrFiscalYr := Calendar."Fiscal Year";
        SETFILTER("Fiscal Year", '%1', CurrFiscalYr);
    end;

    var
        Calendar: Record "33020302";
        CurrFiscalYr: Code[10];
        "Previous Appraisal Rating I": Text[30];
        "Previous Appraisal Rating II": Text[30];
}

