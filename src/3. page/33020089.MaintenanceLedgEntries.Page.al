page 33020089 "Maintenance Ledg. Entries"
{
    Editable = false;
    PageType = List;
    SourceTable = Table17;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("G/L Account No."; "G/L Account No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document Type"; "Document Type")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field(Description; Description)
                {
                }
                field(Amount; Amount)
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("VAT Amount"; "VAT Amount")
                {
                }
                field("External Document No."; "External Document No.")
                {
                }
                field("FA Entry Type"; "FA Entry Type")
                {
                }
                field("FA Entry No."; "FA Entry No.")
                {
                }
                field("Document Class"; "Document Class")
                {
                }
                field("Document Subclass"; "Document Subclass")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        FAsset.RESET;
        FILTERGROUP(3);
        FAsset.SETRANGE("No.", "Document Subclass");
        SETRANGE("Document Class", "Document Class"::"Fixed Assets");
    end;

    var
        FAsset: Record "5600";
}

