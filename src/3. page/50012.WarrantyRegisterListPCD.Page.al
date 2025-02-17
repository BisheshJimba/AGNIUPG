page 50012 "Warranty Register List PCD"
{
    Caption = 'Warranty Register List PCD';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Table33020238;
    SourceTableView = WHERE(Make Code=FILTER(TATA PCD));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Claim No.";"Claim No.")
                {
                    Editable = false;
                }
                field(VIN;VIN)
                {
                }
                field("Model Code";"Model Code")
                {
                }
                field("Model Version No.";"Model Version No.")
                {
                }
                field("Complaint Description";"Complaint Description")
                {
                }
                field(Kilometrage;Kilometrage)
                {
                }
                field("Serv. Order No.";"Serv. Order No.")
                {
                }
                field("Posting Date";"Posting Date")
                {
                }
                field("Item No.";"Item No.")
                {
                }
                field("Item Description";"Item Description")
                {
                }
                field(Quantity;Quantity)
                {
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                }
                field("Posting Date2";"Posting Date")
                {
                    Caption = 'Submitted Date';
                }
                field("Tata Claim No.";"Tata Claim No.")
                {
                }
                field("Credit Note No.";"Credit Note No.")
                {
                }
                field(Remarks;Remarks)
                {
                }
            }
        }
    }

    actions
    {
    }
}

