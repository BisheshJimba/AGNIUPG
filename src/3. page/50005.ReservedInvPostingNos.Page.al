page 50005 "Reserved Inv. Posting Nos."
{
    Editable = false;
    PageType = List;
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Posting No." = FILTER(<> ''));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                }
                field("Order Date"; Rec."Order Date")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field("Posting No."; Rec."Posting No.")
                {
                }
                field("Posting No. Series"; Rec."Posting No. Series")
                {
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                }
                field("Vehicle Regd. No."; Rec."Vehicle Regd. No.")
                {
                }
                field("Service Document No."; Rec."Service Document No.")
                {
                }
                field("Debit Note"; Rec."Debit Note")
                {
                }
            }
        }
    }

    actions
    {
    }
    var
        SaleHeader: Record "Sales Header"
}

