page 25006410 "Warranty Pstd. Service Line"
{
    PageType = List;
    SourceTable = Table25006150;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Amount Including VAT"; "Amount Including VAT")
                {
                }
            }
        }
    }

    actions
    {
    }

    [Scope('Internal')]
    procedure SetSelected(var PstdServiceOrderLine: Record "25006150")
    begin
        CurrPage.SETSELECTIONFILTER(PstdServiceOrderLine);
    end;
}

