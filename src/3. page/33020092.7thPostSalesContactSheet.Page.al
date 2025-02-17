page 33020092 "7th Post Sales Contact Sheet"
{
    PageType = Card;
    Permissions = TableData 32 = rm;
    SourceTable = Table33019858;

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
                field("Model Code"; "Model Code")
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
                field("Appointment "; Appointment)
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
            action("<Action1000000042>")
            {
                Caption = 'Create 30th Contact';
                Image = SwitchCompanies;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CLEAR(Already);
                    CLEAR("30thSalesContactSheet");
                    CLEAR("7thSalesContactSheet");

                    Already.RESET;
                    Already.SETRANGE(Already."Vehicle Serial No.", "Vehicle Serial No.");
                    IF NOT Already.FINDFIRST THEN BEGIN
                        "7thSalesContactSheet".RESET;
                        "7thSalesContactSheet".SETRANGE("7thSalesContactSheet"."Vehicle Serial No.", "Vehicle Serial No.");
                        IF "7thSalesContactSheet".FINDFIRST THEN BEGIN
                            "30thSalesContactSheet".INIT;
                            "30thSalesContactSheet"."Vehicle Serial No." := "7thSalesContactSheet"."Vehicle Serial No.";
                            "30thSalesContactSheet"."Registration No." := "7thSalesContactSheet"."Registration No.";
                            "30thSalesContactSheet".VIN := "7thSalesContactSheet".VIN;
                            "30thSalesContactSheet".Model := "7thSalesContactSheet"."Model Code";
                            "30thSalesContactSheet"."Engine No." := "7thSalesContactSheet"."Engine No.";
                            "30thSalesContactSheet"."Sales Date" := "7thSalesContactSheet"."Sales Date";
                            "30thSalesContactSheet"."Make Code" := "7thSalesContactSheet"."Make Code";
                            "30thSalesContactSheet"."Model Version No." := "7thSalesContactSheet"."Model Version No.";
                            "30thSalesContactSheet"."Contact Type" := "30thSalesContactSheet"."Contact Type"::"30th Contact";
                            "30thSalesContactSheet"."Customer No." := "7thSalesContactSheet"."Customer No.";
                            "30thSalesContactSheet".Name := "7thSalesContactSheet".Name;
                            "30thSalesContactSheet".Address := "7thSalesContactSheet".Address;
                            "30thSalesContactSheet"."E-mail" := "7thSalesContactSheet"."E-mail";
                            "30thSalesContactSheet"."Fax No." := "7thSalesContactSheet"."Fax No.";
                            "30thSalesContactSheet"."Phone No." := "7thSalesContactSheet"."Phone No.";
                            "30thSalesContactSheet"."Mobile No." := "7thSalesContactSheet"."Mobile No.";
                            "30thSalesContactSheet".Odometer := "30thSalesContactSheet".Odometer;
                            "30thSalesContactSheet".INSERT(TRUE);
                            MESSAGE('30th Sales Contact has been updated successfully');
                        END;
                    END ELSE
                        ERROR('This 7th Post Sales Contact has already been updated in 30th Post Sales Contact!!!');

                    Contacted := TRUE;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        IF "Any Concerns at Present" = "Any Concerns at Present"::No THEN
            AnyConcern := FALSE;
    end;

    var
        "30thSalesContactSheet": Record "33019863";
        "7thSalesContactSheet": Record "33019858";
        Already: Record "33019863";
        [InDataSet]
        AnyConcern: Boolean;
}

