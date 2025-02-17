page 33020222 "Posted Veh. Fuel Expense Card"
{
    Editable = false;
    PageType = Card;
    SourceTable = Table33020175;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE();
                    end;
                }
                field("Agent Code"; "Agent Code")
                {
                }
                field(Name; Name)
                {
                }
                field(Address; Address)
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Document Date"; "Document Date")
                {
                }
            }
            part(; 33020233)
            {
                SubPageLink = Document No=FIELD(No.);
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
    }
}

