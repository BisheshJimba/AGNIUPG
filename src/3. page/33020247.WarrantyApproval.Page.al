page 33020247 "Warranty Approval"
{
    InsertAllowed = false;
    PageType = List;
    SourceTable = Table33020237;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Status; Status)
                {
                }
                field("Claim No."; "Claim No.")
                {
                }
                field("Serv. Order No."; "Serv. Order No.")
                {
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
                field("Sell to Customer No."; "Sell to Customer No.")
                {
                }
                field("Bill to Customer No."; "Bill to Customer No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Item Name"; "Item Name")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field(Amount; Amount)
                {
                }
                field("Job Type"; "Job Type")
                {
                }
                field("Requested By"; "Requested By")
                {
                }
                field("Reason Code"; "Reason Code")
                {
                }
                field("Warranty Code"; "Warranty Code")
                {
                }
                field("Warranty Description"; "Warranty Description")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("Global Dimension 2 Code "; "Global Dimension 2 Code")
                {
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                    Visible = false;
                }
                field("Accountability Center"; "Accountability Center")
                {
                }
                field(Location; Location)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action75>")
            {
                Caption = 'P&ost';
                Ellipsis = true;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'F9';

                trigger OnAction()
                begin
                    ApproveWarranty;
                end;
            }
        }
    }
}

