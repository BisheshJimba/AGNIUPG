page 33020076 "Vehicle Finance Payment List"
{
    PageType = List;
    SourceTable = Table33020072;
    SourceTableView = SORTING(Payment Date)
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("G/L Posting Date"; "G/L Posting Date")
                {
                }
                field("Posting Type"; "Posting Type")
                {
                }
                field("Payment Date"; "Payment Date")
                {
                }
                field("Payment Description"; "Payment Description")
                {
                }
                field("Installment No."; "Installment No.")
                {
                }
                field("G/L Receipt No."; "G/L Receipt No.")
                {
                }
                field("Duration of days fr Prev. Mnth"; "Duration of days fr Prev. Mnth")
                {
                }
                field("Delay by No. of Days"; "Delay by No. of Days")
                {
                }
                field("Principal Paid"; "Principal Paid")
                {
                }
                field("Interest Paid"; "Interest Paid")
                {
                }
                field("Calculated Penalty"; "Calculated Penalty")
                {
                }
                field("Penalty Paid"; "Penalty Paid")
                {
                }
                field("Insurance Paid"; "Insurance Paid")
                {
                }
                field("Insurance Interest Paid"; "Insurance Interest Paid")
                {
                }
                field("CAD Interest Paid"; "CAD Interest Paid")
                {
                }
                field("Prepayment Paid"; "Prepayment Paid")
                {
                }
                field("Other Charges Paid"; "Other Charges Paid")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Navigate: Page "344";
                begin
                    Navigate.SetDoc("G/L Posting Date", "G/L Receipt No.");
                    Navigate.RUN;
                end;
            }
        }
    }

    var
        Navigate: Page "344";
}

