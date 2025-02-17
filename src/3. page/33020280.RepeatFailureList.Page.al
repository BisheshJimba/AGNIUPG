page 33020280 "Repeat Failure List"
{
    Editable = false;
    PageType = List;
    SourceTable = Table33020238;
    SourceTableView = SORTING(Claim No.)
                      ORDER(Ascending)
                      WHERE(Job Type=FILTER(REPEAT FAILURE));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Claim No.";"Claim No.")
                {
                }
                field("Serv. Order No.";"Serv. Order No.")
                {
                }
                field(VIN;VIN)
                {
                }
                field("Make Code";"Make Code")
                {
                }
                field("Model Code";"Model Code")
                {
                }
                field("Model Version No.";"Model Version No.")
                {
                }
                field("Sell to Customer No.";"Sell to Customer No.")
                {
                }
                field("Bill to Customer No.";"Bill to Customer No.")
                {
                }
                field(Type;Type)
                {
                }
                field("Item No.";"Item No.")
                {
                }
                field("Item Name";"Item Name")
                {
                }
                field("Job Type";"Job Type")
                {
                }
                field(Status;Status)
                {
                }
                field("Approved By";"Approved By")
                {
                }
                field("Requested By";"Requested By")
                {
                }
                field("Approved Date";"Approved Date")
                {
                }
                field("Reason Code";"Reason Code")
                {
                }
                field("Warranty Code";"Warranty Code")
                {
                }
                field("Warranty Description";"Warranty Description")
                {
                }
                field("Complain Date";"Complain Date")
                {
                }
                field(Quantity;Quantity)
                {
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                }
                field(Amount;Amount)
                {
                }
                field(Location;Location)
                {
                }
                field(Exported;Exported)
                {
                }
                field("No.";"No.")
                {
                }
                field(Kilometrage;Kilometrage)
                {
                }
                field("Vehicle Sales Date";"Vehicle Sales Date")
                {
                }
                field("Veh. Regd. No.";"Veh. Regd. No.")
                {
                }
                field("Customer Name";"Customer Name")
                {
                }
                field("Job Date";"Job Date")
                {
                }
                field("Unit Price";"Unit Price")
                {
                }
                field("Status Code";"Status Code")
                {
                }
                field("Claim Category";"Claim Category")
                {
                }
                field("Action Taken";"Action Taken")
                {
                }
                field(Remarks;Remarks)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

