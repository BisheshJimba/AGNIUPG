page 33020039 "Inward Gate Entry List"
{
    Caption = 'Inward Gate Entry List';
    CardPageID = "Inward Gate Entry";
    PageType = List;
    SourceTable = Table33020035;

    layout
    {
        area(content)
        {
            repeater()
            {
                Editable = false;
                field("Entry Type"; "Entry Type")
                {
                }
                field("No."; "No.")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Document Time"; "Document Time")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field(Description; Description)
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field("LR/RR No."; "LR/RR No.")
                {
                }
                field("LR/RR Date"; "LR/RR Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

