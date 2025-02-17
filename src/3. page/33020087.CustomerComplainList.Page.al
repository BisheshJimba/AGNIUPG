page 33020087 "Customer Complain List"
{
    Caption = 'Post Service Calls';
    CardPageID = "Customer Complain Card";
    Editable = false;
    PageType = List;
    RefreshOnActivate = false;
    SourceTable = Table33019847;
    SourceTableView = WHERE(Status = FILTER(Open));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Service Order No."; "Service Order No.")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field(Address; Address)
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field(City; City)
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field(Status; Status)
                {
                }
                field(VIN; VIN)
                {
                }
                field("Vehicle Registration No."; "Vehicle Registration No.")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                    Visible = false;
                }
                field("Model Commercial Name"; "Model Commercial Name")
                {
                    Visible = false;
                }
                field("Service Order No. "; "Service Order No.")
                {
                }
                field("Delivery Date"; "Delivery Date")
                {
                }
                field("Contact Date"; "Contact Date")
                {
                }
                field("Accountability Center"; "Accountability Center")
                {
                }
                field("Complain Type"; "Complain Type")
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

