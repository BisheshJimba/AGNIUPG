page 33020286 "Loan Processing Tracking Sheet"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Table33020084;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application No."; "Application No.")
                {
                    Editable = false;
                }
                field("Line No."; "Line No.")
                {
                    Editable = false;
                }
                field(Components; Components)
                {
                    Editable = false;
                }
                field("Components Description"; "Components Description")
                {
                    Editable = false;
                }
                field(Processed; Processed)
                {
                    Editable = IsEditable;

                    trigger OnValidate()
                    begin
                        GeneralMaster.RESET;
                        GeneralMaster.SETRANGE(Category, 'Vehicle Loan');
                        GeneralMaster.SETRANGE("Sub Category", 'Components');
                        GeneralMaster.SETRANGE(Code, Components);
                        IF GeneralMaster.FINDFIRST THEN
                            IF GeneralMaster."Auto Insert" THEN
                                ERROR('You cannot modify this record!');

                        IF Processed THEN
                            IsEditable := FALSE
                        ELSE
                            IsEditable := TRUE;

                        UserSetup.GET(USERID);
                        IF UserSetup."Can Wave VF Penalty" THEN
                            IsEditable := TRUE;

                        CurrPage.UPDATE;
                    end;
                }
                field(Date; Date)
                {
                    Editable = false;
                }
                field("Processing Time"; "Processing Time")
                {
                    Editable = false;
                }
                field("User Id"; "User Id")
                {
                    Editable = false;
                }
                field(Remarks; Remarks)
                {
                    Editable = IsEditable;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        IF Processed THEN
            IsEditable := FALSE
        ELSE
            IsEditable := TRUE;

        UserSetup.GET(USERID);
        IF UserSetup."Can Wave VF Penalty" THEN
            IsEditable := TRUE;
    end;

    var
        [InDataSet]
        IsEditable: Boolean;
        UserSetup: Record "91";
        GeneralMaster: Record "33020061";
}

