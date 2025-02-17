page 33020357 "Leave App/Dis Card"
{
    Editable = false;
    PageType = Card;
    SourceTable = Table33020346;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Middle Name"; "Middle Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
            }
            part(; 33020358)
            {
                SubPageLink = Employee No.=FIELD(Employee No.);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(List)
            {
                Caption = 'List';
                Image = ListPage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 33020356;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        /*
        //Applying URC.
        HRUP.GET(USERID);
        IF (HRUP."Employee Filter" <> '') THEN BEGIN
          IF NOT HRUP."Super Permission" THEN BEGIN
            FILTERGROUP(2);
            SETRANGE("No.",HRUP."Employee Filter");
            FILTERGROUP(0);
          END;
        END;
        */
        HRUP.GET(USERID);
        IF NOT HRUP."Aproval/Disaproval Auth. Leave" THEN
            ERROR(Text000);

    end;

    trigger OnOpenPage()
    begin
        /*
        //Applying URC.
        HRUP.GET(USERID);
        IF (HRUP."Employee Filter" <> '') THEN BEGIN
          IF NOT HRUP."Super Permission" THEN BEGIN
            FILTERGROUP(2);
            SETRANGE("No.",HRUP."Employee Filter");
            FILTERGROUP(0);
          END;
        END;
        */
        HRUP.GET(USERID);
        IF NOT HRUP."Aproval/Disaproval Auth. Leave" THEN
            ERROR(Text000);

    end;

    var
        HRUP: Record "33020304";
        LeaveAppDisRec: Record "33020346";
        Text000: Label 'Sorry, you donot have permission to use this Page! Please contact your system administrator.';
}

