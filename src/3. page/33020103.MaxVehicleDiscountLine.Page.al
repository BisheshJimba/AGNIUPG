page 33020103 "Max Vehicle Discount Line"
{
    PageType = List;
    SourceTable = Table33019861;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID"; "User ID")
                {
                    Editable = false;
                }
                field("Model Version Filter"; "Model Version Filter")
                {
                    Editable = false;
                }
                field("Max. Discount Amount"; "Max. Discount Amount")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
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
        ShowDiscount := FALSE;
        User.RESET;
        User.SETRANGE("User Name", USERID);
        User.FINDFIRST;
        //User.GET(USERID);
        //SIDNo := SID(USERID);
        WindowsAccessControl.RESET;
        WindowsAccessControl.SETRANGE("User Security ID", User."User Security ID");
        IF WindowsAccessControl.FINDFIRST THEN BEGIN
            IF WindowsAccessControl."Role ID" = 'SUPER' THEN BEGIN
                //MESSAGE(SIDNo);
                ShowDiscount := TRUE;
            END;
        END;
    end;

    var
        UserSetup: Record "91";
        [InDataSet]
        ShowDiscount: Boolean;
        WindowsAccessControl: Record "2000000053";
        SIDNo: Text[200];
        User: Record "2000000120";
}

