page 25006385 "Service WIP Entries"
{
    PageType = List;
    SourceTable = Table25006194;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Service Order No."; "Service Order No.")
                {
                }
                field("Service Order Line No."; "Service Order Line No.")
                {
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Finished Qty."; "Finished Qty.")
                {
                }
                field("G/L Account No."; "G/L Account No.")
                {
                }
                field("G/L Bal. Account No."; "G/L Bal. Account No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("WIP Entry Amount"; "WIP Entry Amount")
                {
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                }
                field("Entry Type"; "Entry Type")
                {
                }
                field("WIP Method"; "WIP Method")
                {
                }
                field(Description; Description)
                {
                }
                field(Reversed; Reversed)
                {
                }
                field("Reverse Date"; "Reverse Date")
                {
                }
                field("Reverse Document No."; "Reverse Document No.")
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("Dimension Set ID"; "Dimension Set ID")
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
        SETRANGE(Reversed, FALSE);
    end;
}

