page 33020108 "Posted Sales Shipment Vehicles"
{
    Editable = false;
    PageType = List;
    SourceTable = Table111;
    SourceTableView = SORTING(Document No., Line No.)
                      WHERE(Line Type=FILTER(Vehicle));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                }
                field("Document No.";"Document No.")
                {
                }
                field("No.";"No.")
                {
                }
                field("Location Code";"Location Code")
                {
                }
                field("Posting Group";"Posting Group")
                {
                }
                field("Shipment Date";"Shipment Date")
                {
                }
                field(Description;Description)
                {
                }
                field(Quantity;Quantity)
                {
                }
                field("Unit Price";"Unit Price")
                {
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                }
                field("Purchase Order No.";"Purchase Order No.")
                {
                }
                field("Model Version No.";"Model Version No.")
                {
                }
                field(VIN;VIN)
                {
                }
                field("Model Code";"Model Code")
                {
                }
                field("Make Code";"Make Code")
                {
                }
                field("Sales Invoiced";"Sales Invoiced")
                {
                }
                field("Vehicle Status Code";"Vehicle Status Code")
                {
                }
                field("Accountability Center";"Accountability Center")
                {
                }
                field("Vehicle Serial No.";"Vehicle Serial No.")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(;Notes)
            {
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("<Action1000000012>")
            {
                Caption = 'Count Records';
                Image = CalculatePlan;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CountRec := COUNT;
                    MESSAGE('No. of records are %1 ',CountRec);
                end;
            }
            action("Open Sales Order")
            {
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesHdr: Record "36";
                    ShipmentHdr: Record "110";
                begin
                    ShipmentHdr.RESET;
                    ShipmentHdr.SETRANGE("No.","Document No.");
                    IF ShipmentHdr.FINDFIRST THEN BEGIN
                      SalesHdr.RESET;
                      SalesHdr.SETRANGE("No.",ShipmentHdr."Order No.");
                      IF SalesHdr.FINDFIRST THEN
                        PAGE.RUNMODAL(42,SalesHdr);
                    END;
                end;
            }
        }
    }

    var
        CountRec: Integer;
}

