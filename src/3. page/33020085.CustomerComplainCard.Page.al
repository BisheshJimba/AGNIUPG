page 33020085 "Customer Complain Card"
{
    Caption = 'Customer Complain Card';
    PageType = Card;
    SourceTable = Table33019847;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    Caption = 'No.';

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Customer No."; "Customer No.")
                {
                    Caption = 'Customer No.';
                }
                field("Customer Name"; "Customer Name")
                {
                    Caption = 'Customer Name';
                }
                field(Address; Address)
                {
                    Caption = 'Address';
                }
                field("Address 2"; "Address 2")
                {
                    Caption = 'Address 2';
                }
                field(City; City)
                {
                    Caption = 'City';
                }
                field("Phone No."; "Phone No.")
                {
                }
                field(Contact; Contact)
                {
                    Caption = 'Contact';
                    Visible = false;
                }
                field(Country; Country)
                {
                    Caption = 'County';
                    Visible = false;
                }
                field(VIN; VIN)
                {
                    Caption = 'VIN';
                }
                field("Vehicle Registration No."; "Vehicle Registration No.")
                {
                    Caption = 'Vehicle Registration No.';
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                    Caption = 'Vehicle Serial No.';
                    Visible = false;
                }
                field("Make Code"; "Make Code")
                {
                    Caption = 'Make Code';
                }
                field("Model Code"; "Model Code")
                {
                    Caption = 'Model Code';
                }
                field("Model Version No."; "Model Version No.")
                {
                    Caption = 'Model Version No.';
                    Visible = false;
                }
                field("Service Order No."; "Service Order No.")
                {
                    Visible = true;
                }
                field(Kilometrage; Kilometrage)
                {
                }
                field("Service Type"; "Service Type")
                {
                    Visible = false;
                }
                field("Delivery Date"; "Delivery Date")
                {
                    Visible = false;
                }
                field("Contact Date"; "Contact Date")
                {
                }
                field(Status; Status)
                {
                    Caption = 'Status';
                }
            }
            group(Questions)
            {
                Caption = 'Questions';
                field("Timely Delivery"; "Timely Delivery")
                {
                }
                field(Cost; Cost)
                {
                }
                field("Quality of Service"; "Quality of Service")
                {
                }
                field("Behavior of Staff"; "Behavior of Staff")
                {
                }
                field(Sum; Sum)
                {
                }
                field("Repeat Problem"; "Repeat Problem")
                {
                }
                field("Complain Type"; "Complain Type")
                {
                }
            }
            part(Diagnosis; 25006187)
            {
                Caption = 'Diagnosis';
                SubPageLink = No.=FIELD(Service Order No.);
            }
            part(ComplainLines; 33020086)
            {
                SubPageLink = Complain No.=FIELD(No.);
            }
        }
        area(factboxes)
        {
            part(; 9080)
            {
                SubPageLink = No.=FIELD(Customer No.);
                    Visible = true;
            }
            part(; 9082)
            {
                SubPageLink = No.=FIELD(Customer No.);
                    Visible = false;
            }
            part(; 9084)
            {
                SubPageLink = No.=FIELD(Customer No.);
                    Visible = false;
            }
            systempart(; Links)
            {
                Visible = false;
            }
            systempart(; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Close Complain")
            {
                Caption = 'Close Complain';

                trigger OnAction()
                begin
                    "Close Job"();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        IF Status = Status::Closed THEN
            CurrPage.EDITABLE := FALSE;
    end;

    [Scope('Internal')]
    procedure "Close Job"()
    var
        CloseJobWithReason: Label 'Do you want to close this complain for vehicle with Registration No : %1, VIN : %2 ?';
    begin
        IF CONFIRM(CloseJobWithReason, FALSE, "Vehicle Registration No.", VIN) THEN BEGIN
            Status := Status::Closed;
            "Complain Closed" := TRUE;
            MODIFY;
        END;
    end;
}

