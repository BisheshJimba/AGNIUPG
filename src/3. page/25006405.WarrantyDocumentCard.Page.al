page 25006405 "Warranty Document Card"
{
    Caption = 'Warranty Document Card';
    SourceTable = Table25006405;

    layout
    {
        area(content)
        {
            group()
            {
                field("No."; "No.")
                {

                    trigger OnValidate()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Service Order No."; "Service Order No.")
                {
                }
                field("Service Order Sequence No."; "Service Order Sequence No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Vehicle Registration No."; "Vehicle Registration No.")
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field("Vehicle Status Code"; "Vehicle Status Code")
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
                }
                field("Variable Field Run 1"; "Variable Field Run 1")
                {
                }
                field("Variable Field Run 2"; "Variable Field Run 2")
                {
                }
                field("Variable Field Run 3"; "Variable Field Run 3")
                {
                }
                field("Claim Job Type"; "Claim Job Type")
                {
                }
                field("Symptom Code"; "Symptom Code")
                {
                }
                field("Recal Campaign Code"; "Recal Campaign Code")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field(Status; Status)
                {
                }
            }
            part(; 25006407)
            {
                SubPageLink = Document No.=FIELD(No.);
            }
        }
        area(factboxes)
        {
            part(; 25006252)
            {
                SubPageLink = Serial No.=FIELD(Vehicle Serial No.);
                    Visible = true;
            }
            part(; 25006262)
            {
                SubPageLink = Serial No.=FIELD(Vehicle Serial No.);
            }
            part("Vehicle Pictures"; 25006047)
            {
                Caption = 'Vehicle Pictures';
                SubPageLink = Source Type=CONST(25006005),
                              Source Subtype=CONST(0),
                              Source ID=FIELD(Vehicle Serial No.),
                              Source Ref. No.=CONST(0);
                                            SubPageView = SORTING(Source Type,Source Subtype,Source ID,Source Ref. No.,No.);
            }
            systempart(; Links)
            {
                Visible = true;
            }
            systempart(; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Warranty Reimbursement Entries")
            {
                Caption = 'Warranty Reimbursement Entries';
                Image = AllLines;
                RunObject = Page 25006409;
                RunPageLink = Warranty Document No.=FIELD(No.);
            }
        }
    }
}

