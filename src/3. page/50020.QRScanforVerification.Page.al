page 50020 "QR Scan for Verification"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = Table33019975;

    layout
    {
        area(content)
        {
            repeater()
            {
                Editable = false;
                Enabled = false;
                field("Location Code"; "Location Code")
                {
                    Editable = false;
                    StyleExpr = LineStatus;
                }
                field("QR Code Text"; "QR Code Text")
                {
                    Editable = false;
                    StyleExpr = LineStatus;
                }
                field("Item No."; "Item No.")
                {
                    Editable = false;
                    StyleExpr = LineStatus;
                }
                field("Item Description"; "Item Description")
                {
                    Editable = false;
                    StyleExpr = LineStatus;
                }
                field("Lot No."; "Lot No.")
                {
                }
                field(Inventory; Inventory)
                {
                    Editable = false;
                    StyleExpr = LineStatus;
                }
                field("QR Status"; "QR Status")
                {
                    StyleExpr = LineStatus;
                }
                field("Entry No."; "Entry No.")
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
        CLEAR(LineStatus);
        IF "QR Status" = "QR Status"::Verified THEN
            LineStatus := Verified
        ELSE
            IF "QR Status" = "QR Status"::Lost THEN
                LineStatus := Lost
    end;

    trigger OnOpenPage()
    begin
        FilterData;
    end;

    var
        QRText: Text[250];
        Verified: Label 'Standard';
        Lost: Label 'Unfavorable';
        LineStatus: Text;
}

