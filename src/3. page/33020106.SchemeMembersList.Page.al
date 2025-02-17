page 33020106 "Scheme Members List"
{
    CardPageID = "Membership Form";
    Editable = false;
    PageType = List;
    SourceTable = Table33019864;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Membership Card No."; "Membership Card No.")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Joined Date"; "Joined Date")
                {
                }
                field("Expiry Date"; "Expiry Date")
                {
                }
                field("Engine No."; "Engine No.")
                {
                }
                field("Scheme Code"; "Scheme Code")
                {
                }
                field(Status; Status)
                {
                }
                field("Vehicle Registration No."; "Vehicle Registration No.")
                {
                }
                field("Contact No."; "Contact No.")
                {
                }
                field("Assigned User ID"; "Assigned User ID")
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
        FilterOnRecord;
    end;

    [Scope('Internal')]
    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
    begin
        RespCenterFilter := UserMgt.GetServiceFilterEDMS();
        IF RespCenterFilter <> '' THEN BEGIN
            FILTERGROUP(2);
            SETRANGE("Accountability Center", RespCenterFilter);
            FILTERGROUP(0);
        END;
    end;
}

