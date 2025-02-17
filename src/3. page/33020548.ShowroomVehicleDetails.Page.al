page 33020548 "Showroom Vehicle Details"
{
    Editable = false;
    PageType = List;
    SourceTable = Table33020523;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Engine No."; "Engine No.")
                {
                }
                field("Registration No."; "Registration No.")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("System Allocated"; "System Allocated")
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
        UserSetup.GET(USERID);
        FILTERGROUP(2);
        SETRANGE("Location Code", UserSetup."Default Location");
        FILTERGROUP(0);
    end;

    var
        UserSetup: Record "91";
}

