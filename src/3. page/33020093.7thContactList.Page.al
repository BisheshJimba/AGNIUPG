page 33020093 "7th Contact List"
{
    CardPageID = "7th Post Sales Contact Sheet";
    Editable = false;
    PageType = List;
    SourceTable = Table33019858;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    Style = StrongAccent;
                    StyleExpr = DaysLimit;
                }
                field("Registration No."; "Registration No.")
                {
                    Style = StrongAccent;
                    StyleExpr = DaysLimit;
                }
                field("Model Code"; "Model Code")
                {
                    Style = StrongAccent;
                    StyleExpr = DaysLimit;
                }
                field(Odometer; Odometer)
                {
                    Style = StrongAccent;
                    StyleExpr = DaysLimit;
                }
                field(Dealer; Dealer)
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field(VIN; VIN)
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field("Engine No."; "Engine No.")
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field("Sales Date"; "Sales Date")
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field("Customer No."; "Customer No.")
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field(Name; Name)
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field(Address; Address)
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field("E-mail"; "E-mail")
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field("Fax No."; "Fax No.")
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field("Phone No."; "Phone No.")
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field("Mobile No."; "Mobile No.")
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field("Is your Vehicle"; "Is your Vehicle")
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field("Any Concerns at Present"; "Any Concerns at Present")
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field("Ride, Handling & Braking"; "Ride, Handling & Braking")
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field(Seats; Seats)
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field("Sound System"; "Sound System")
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field("Vehicle Interior"; "Vehicle Interior")
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field(Engine; Engine)
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field("Features & Controls"; "Features & Controls")
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field(HVAC; HVAC)
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field("Vehicle Exterior"; "Vehicle Exterior")
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field(Transmission; Transmission)
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field(Others; Others)
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field("Performance of Vehicle"; "Performance of Vehicle")
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field("Services of the dealer"; "Services of the dealer")
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field("Overall Satisfaction"; "Overall Satisfaction")
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field(Appointment; Appointment)
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field("Appointment Date"; "Appointment Date")
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field("Appointment Time"; "Appointment Time")
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field(Remarks; Remarks)
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field("Contact By"; "Contact By")
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field("Contact Type"; "Contact Type")
                {
                    Style = StrongAccent;
                    StyleExpr = dayslimit;
                }
                field(Contacted; Contacted)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        DaysLimit := FALSE;

        IF ("Sales Date" <> 0D) AND (WORKDATE > "Sales Date") THEN BEGIN
            IF (WORKDATE - "Sales Date") > 7 THEN
                DaysLimit := TRUE;
        END;
    end;

    var
        [InDataSet]
        DaysLimit: Boolean;
        CheckDate: Date;
        PostSalesCont: Record "33019858";
}

