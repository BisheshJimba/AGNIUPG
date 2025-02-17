page 25006460 "Vehicle Order Promissing"
{
    Caption = 'Vehicle Order Promissing';
    Editable = false;
    PageType = Card;
    SourceTable = Table37;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        VehOrderPromising: Codeunit "25006324";
    begin
        IF CloseAction IN [ACTION::OK, ACTION::LookupOK] THEN BEGIN
            SalesHeader.GET("Document Type", "Document No.");
            CALCFIELDS(Reserved);
            IF NOT ((SalesHeader.Status = SalesHeader.Status::Open) AND NOT Reserved) THEN
                ERROR(Text001);
            VehOrderPromising.CreateReqLine(Rec);
        END;
    end;

    var
        SalesHeader: Record "36";
        Text001: Label 'Either the document is not opened or vehicle had promised already.';
}

