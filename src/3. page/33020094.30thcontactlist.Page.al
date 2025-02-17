page 33020094 "30th contact list"
{
    CardPageID = "30th Post Sales Contact Sheet";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33019863;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Registration No."; "Registration No.")
                {
                }
                field(Model; Model)
                {
                }
                field(Odometer; Odometer)
                {
                }
                field(Dealer; Dealer)
                {
                }
                field(VIN; VIN)
                {
                }
                field("Engine No."; "Engine No.")
                {
                }
                field("Sales Date"; "Sales Date")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field(Name; Name)
                {
                }
                field(Address; Address)
                {
                }
                field("E-mail"; "E-mail")
                {
                }
                field("Fax No."; "Fax No.")
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field("Mobile No."; "Mobile No.")
                {
                }
                field("Is your Vehicle"; "Is your Vehicle")
                {
                }
                field("Any Concerns at Present"; "Any Concerns at Present")
                {
                }
                field("Ride, Handling & Braking"; "Ride, Handling & Braking")
                {
                }
                field(Seats; Seats)
                {
                }
                field("Sound System"; "Sound System")
                {
                }
                field("Vehicle Interior"; "Vehicle Interior")
                {
                }
                field(Engine; Engine)
                {
                }
                field("Features & Controls"; "Features & Controls")
                {
                }
                field(HVAC; HVAC)
                {
                }
                field("Vehicle Exterior"; "Vehicle Exterior")
                {
                }
                field(Transmission; Transmission)
                {
                }
                field(Others; Others)
                {
                }
                field("Performance of Vehicle"; "Performance of Vehicle")
                {
                }
                field("Services of the dealer"; "Services of the dealer")
                {
                }
                field("Overall Satisfaction"; "Overall Satisfaction")
                {
                }
                field(Appointment; Appointment)
                {
                }
                field("Appointment Date"; "Appointment Date")
                {
                }
                field("Appointment Time"; "Appointment Time")
                {
                }
                field(Remarks; Remarks)
                {
                }
                field("Contact By"; "Contact By")
                {
                }
                field("Contact Type"; "Contact Type")
                {
                }
                field("Accountability Center"; "Accountability Center")
                {
                }
                field(Contacted; Contacted)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000049>")
            {
                Caption = '7th Contact History';
                Image = SwitchCompany;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 33020092;
                RunPageLink = Vehicle Serial No.=FIELD(Vehicle Serial No.);
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF ("Sales Date" <> 0D) AND (WORKDATE > "Sales Date") THEN BEGIN
          IF (WORKDATE - "Sales Date") > 7 THEN
            DaysLimit := TRUE;
        END;
    end;

    var
        [InDataSet]
        DaysLimit: Boolean;
}

