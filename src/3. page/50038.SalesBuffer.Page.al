page 50038 "Sales Buffer"
{
    CardPageID = "Sales Buffer Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table50021;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Sales Order Created"; "Sales Order Created")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group()
            {
                action("<Action14>")
                {
                    Caption = 'Create Sales Orders';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Salesbuffer: Record "50021";
                    begin
                        CurrPage.SETSELECTIONFILTER(Salesbuffer);
                        IF Salesbuffer.FINDFIRST THEN
                            REPEAT
                                //IF NOT Salesbuffer."Sales Order Created" THEN
                                VehAllotmentMgt.CreateSalesOrders(Salesbuffer);
                            UNTIL Salesbuffer.NEXT = 0;
                        MESSAGE('Sales orders are created successfully');
                    end;
                }
            }
        }
    }

    var
        VehAllotmentMgt: Codeunit "50009";
}

