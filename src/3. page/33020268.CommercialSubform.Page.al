page 33020268 "Commercial Subform"
{
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = ListPart;
    SourceTable = Table33020186;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; "Document No.")
                {
                    Editable = false;
                }
                field("Line No."; "Line No.")
                {
                    Visible = false;
                }
                field("Sales Invoice No."; "Sales Invoice No.")
                {
                    Editable = false;
                }
                field("Proforma No."; "Proforma No.")
                {
                }
                field("Proforma Date"; "Proforma Date")
                {
                }
                field("Proforma No. Second"; "Proforma No. Second")
                {
                    Visible = ProformaVisible;
                }
                field("Proforma Date Second"; "Proforma Date Second")
                {
                    Visible = ProformaVisible;
                }
                field("Desc. of Goods/Services in LC"; "Desc. of Goods/Services in LC")
                {
                    Visible = false;
                }
                field(Amount; Amount)
                {
                }
            }
            group()
            {
                fixed()
                {
                    group("Total Amount")
                    {
                        Caption = 'Total Amount';
                        field(TotalAmount; TotalAmount)
                        {
                        }
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        GetTotalAmount;
    end;

    trigger OnAfterGetRecord()
    begin
        IF COMPANYNAME = 'BALAJU AUTO WORKS PVT. LTD.' THEN
            ProformaVisible := TRUE
        ELSE
            ProformaVisible := FALSE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        GetTotalAmount;
    end;

    var
        Visible: Boolean;
        ProformaVisible: Boolean;
        TotalAmount: Decimal;
        CommercialInvLine: Record "33020186";

    local procedure GetTotalAmount()
    begin
        //ratan 4.27.2021
        CommercialInvLine.COPYFILTERS(Rec);
        CommercialInvLine.CALCSUMS(Amount);
        TotalAmount := CommercialInvLine.Amount;
    end;
}

