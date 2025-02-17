page 33020281 "30th Post Sales Contact Sheet"
{
    PageType = Card;
    SourceTable = Table33019863;

    layout
    {
        area(content)
        {
            group(General)
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
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
            }
            group("Complaint History")
            {
                field("Is your Vehicle"; "Is your Vehicle")
                {
                }
                field("Any Concerns at Present"; "Any Concerns at Present")
                {

                    trigger OnValidate()
                    begin
                        AnyConcern := TRUE;
                        IF "Any Concerns at Present" = "Any Concerns at Present"::No THEN
                            AnyConcern := FALSE;
                    end;
                }
                field("Ride, Handling & Braking"; "Ride, Handling & Braking")
                {
                    Enabled = AnyConcern;
                }
                field(Seats; Seats)
                {
                    Enabled = AnyConcern;
                }
                field("Sound System"; "Sound System")
                {
                    Enabled = AnyConcern;
                }
                field("Vehicle Interior"; "Vehicle Interior")
                {
                    Enabled = AnyConcern;
                }
                field(Engine; Engine)
                {
                    Enabled = AnyConcern;
                }
                field("Features & Controls"; "Features & Controls")
                {
                    Enabled = AnyConcern;
                }
                field(HVAC; HVAC)
                {
                    Enabled = AnyConcern;
                }
                field("Vehicle Exterior"; "Vehicle Exterior")
                {
                    Enabled = AnyConcern;
                }
                field(Transmission; Transmission)
                {
                    Enabled = AnyConcern;
                }
                field(Others; Others)
                {
                    Enabled = AnyConcern;
                }
            }
            group("Level of Satisfaction")
            {
                field("Performance of Vehicle"; "Performance of Vehicle")
                {
                }
                field("Services of the dealer"; "Services of the dealer")
                {
                }
                field("Overall Satisfaction"; "Overall Satisfaction")
                {
                }
            }
            group(Appointment)
            {
                field("Appointment>"; Appointment)
                {
                    Caption = 'Appointment';
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
                field(Contacted; Contacted)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
            systempart(; MyNotes)
            {
            }
            systempart(; Links)
            {
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

    trigger OnOpenPage()
    begin
        IF "Any Concerns at Present" = "Any Concerns at Present"::No THEN
          AnyConcern := FALSE;
    end;

    var
        [InDataSet]
        AnyConcern: Boolean;
}

