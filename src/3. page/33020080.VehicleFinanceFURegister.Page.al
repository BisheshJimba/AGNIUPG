page 33020080 "Vehicle Finance FU Register"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    ShowFilter = true;
    SourceTable = Table33020075;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan No."; "Loan No.")
                {
                }
                field("Follow-Up Date"; "Follow-Up Date")
                {
                }
                field("Plan Type"; "Plan Type")
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field("Phone No. 2"; "Phone No. 2")
                {
                }
                field("Mobile No."; "Mobile No.")
                {
                }
                field(Remarks; Remarks)
                {
                }
                field("Responsible Person Code"; "Responsible Person Code")
                {
                    Visible = false;
                }
                field("Responsible Person Name"; "Responsible Person Name")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Due Installment as of Today"; "Due Installment as of Today")
                {
                }
                field("Total Due as of Today"; "Total Due as of Today")
                {
                }
                field("EMI Amount"; "EMI Amount")
                {
                }
                field("Next Follow Up Date"; "Next Follow Up Date")
                {
                }
                field("Payment Type"; "Payment Type")
                {
                }
                field("Bank Account No."; "Bank Account No.")
                {
                }
                field("Last Payment Date"; "Last Payment Date")
                {
                }
                field("Due Days"; "Due Days")
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
        FILTERGROUP(2);
        //SETRANGE("Follow-Up Date",TODAY);
        UserSetup.GET(USERID);
        IF UserSetup."Salespers./Purch. Code" <> '' THEN
            SETRANGE("Responsible Person Code", UserSetup."Salespers./Purch. Code");
        FILTERGROUP(0);
    end;

    var
        VehFURegister: Record "33020075";
        UserSetup: Record "91";
}

