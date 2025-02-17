page 25006229 "Ext. Service Tracking No. Card"
{
    // 15.07.2008. EDMS P2
    //   * Add code Form - OnOpenForm
    //   * Opened fields "Purchase Amount", "Sale Amount"

    Caption = 'External Serv. Tracking No. Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Table25006153;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("External Serv. Tracking No."; "External Serv. Tracking No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Purchase Amount"; "Purchase Amount")
                {
                }
                field("Sales Amount"; "Sales Amount")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SETRANGE("External Service No.", "External Service No.");
        SETRANGE("External Serv. Tracking No.");
    end;

    trigger OnOpenPage()
    begin
        SETRANGE("External Serv. Tracking No.");
    end;
}

