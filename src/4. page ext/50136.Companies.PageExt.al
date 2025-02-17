pageextension 50136 pageextension50136 extends Companies
{
    layout
    {
        addafter("Control 2")
        {
            field("Background Color Code"; Rec."Background Color Code")
            {
            }
            field("Font Color Code"; Rec."Font Color Code")
            {
            }
        }
    }
    actions
    {
        addfirst(CopyCompany)
        {
            action(UpdateleaveInAllCompanies)
            {
                Caption = 'Update Leave for All Companies';
                Image = UpdateXML;

                trigger OnAction()
                var
                    EarnedLeaveCalc: Codeunit "33020301";
                    Companies: Record "2000000006";
                begin
                    IF NOT CONFIRM('Do you want to update leave records in all companies?', FALSE) THEN
                        EXIT;
                    Companies.COPY(Rec);
                    CurrPage.SETSELECTIONFILTER(Companies);
                    IF Companies.FINDSET THEN
                        REPEAT
                            EarnedLeaveCalc.UpdateLeaveTypeInAllLeaveRelatedTables(Companies);
                        UNTIL Companies.NEXT = 0;
                end;
            }
        }
    }
}

