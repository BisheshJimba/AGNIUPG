page 50062 "Budget Analysis"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = Table2000000;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    Editable = false;
                }
                field("G/L Account No."; "G/L Account No.")
                {
                    Editable = false;
                }
                field("G/L Account Name"; "G/L Account Name")
                {
                }
                field("Actual till date"; "Budget Till Date")
                {
                    Caption = 'Actual till date';
                }
                field("Yearly Budget"; "Yearly Budget")
                {
                }
                field("New Reccomendation"; "New Reccomendation")
                {
                }
                field(Balance; Balance)
                {
                }
            }
        }
    }

    actions
    {
    }
}

