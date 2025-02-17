page 33019812 "NCHL-NPI Category Purpose"
{
    PageType = List;
    SourceTable = Table33019812;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Category Code"; "Category Code")
                {
                }
                field(Description; Description)
                {
                }
                field("Charge Bearer"; "Charge Bearer")
                {
                    ToolTip = 'For recognizing charge bearer ie. if sender then debtor will be charged and vice-versa';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        TESTFIELD("Charge Bearer");
    end;
}

