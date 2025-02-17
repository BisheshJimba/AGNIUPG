page 33020124 "Loan-Past Due List"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020062;
    SourceTableView = SORTING(Loan No.)
                      ORDER(Ascending)
                      WHERE(Approved = CONST(Yes),
                            Loan Disbursed=CONST(Yes),
                            Closed=CONST(No),
                            Due Days Crossed Maturity=FILTER(>0));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan No.";"Loan No.")
                {
                }
                field("Customer Name";"Customer Name")
                {
                }
                field("No of Due Days";"No of Due Days")
                {
                    Caption = 'No of Days since last clearance';
                }
                field("Due Days Crossed Maturity";"Due Days Crossed Maturity")
                {
                }
                field("Due Installment as of Today";"Due Installment as of Today")
                {
                    Caption = 'Due Installment as on Calc Date';
                }
                field("Due Principal";"Due Principal")
                {
                    Caption = 'Due Principal as on Calc Date';
                }
                field("Interest Due";"Interest Due")
                {
                    Caption = 'Interest Matured & Due as on Calc Date';
                }
                field("Penalty Due";"Penalty Due")
                {
                    Caption = 'Penalty Due as on Calc Date';
                }
                field("Insurance Due";"Insurance Due")
                {
                }
                field("Interest Due on Insurance";"Interest Due on Insurance")
                {
                }
                field("Other Amount Due";"Other Amount Due")
                {
                }
                field("Total Due as of Today";"Total Due as of Today")
                {
                    Caption = 'Total Due as on Calc Date';
                }
                field("Interest Due Defered";"Interest Due Defered")
                {
                    Caption = 'Add. Int. due to realize to clear loan as on Calc Date';
                }
                field("Total Int. Due to clear Loan";"Total Int. Due to clear Loan")
                {
                }
                field("Total Due";"Total Due")
                {
                    Caption = 'Total Due to clear loan';
                }
                field("Responsible Person Code";"Responsible Person Code")
                {
                    Caption = 'Credit Officer''s Code';
                }
                field("Responsible Person Name";"Responsible Person Name")
                {
                    Caption = 'Credit Officer''s Name';
                }
            }
        }
    }

    actions
    {
    }
}

