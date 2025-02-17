page 25006036 "Vehicle Contacts"
{
    Caption = 'Vehicle Contact';
    DataCaptionFields = "Vehicle Serial No.";
    Editable = false;
    PageType = List;
    SourceTable = Table25006013;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                    Visible = true;
                }
                field(VIN; VIN)
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Customer No"; "Customer No")
                {
                }
                field("Contact No."; "Contact No.")
                {
                }
                field("Contact Name"; "Contact Name")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action103>")
            {
                Caption = '&General';
                action("Customer Card")
                {
                    Caption = 'Customer Card';
                    Image = Customer;

                    trigger OnAction()
                    var
                        Contact: Record "5050";
                        Customer: Record "18";
                        ContBusinessRel: Record "5054";
                    begin
                        IF "Contact No." <> '' THEN
                            IF ContBusinessRel.GET("Contact No.", 'CUST') THEN
                                IF Customer.GET(ContBusinessRel."No.") THEN BEGIN
                                    PAGE.RUN(PAGE::"Customer Card", Customer);
                                    EXIT;
                                END;
                        MESSAGE(Text001);
                    end;
                }
                action("Contact Card")
                {
                    Caption = 'Contact Card';
                    Image = ContactPerson;
                    RunObject = Page 5050;
                    RunPageLink = No.=FIELD(Contact No.);
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Transfer Date" := TODAY;
    end;

    var
        Text001: Label 'No Customer found.';
}

