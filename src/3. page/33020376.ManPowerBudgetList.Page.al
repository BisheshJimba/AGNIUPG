page 33020376 "Man-Power Budget List"
{
    CardPageID = "Man-Power Budget Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020364;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Fiscal Year"; "Fiscal Year")
                {
                }
                field(Department; Department)
                {
                }
                field(Location; Location)
                {
                }
                field(Level; Level)
                {
                }
                field("No. Of Position"; "No. Of Position")
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        Managerlvl: Integer;
        officerlvl: Integer;
        TechAsstlvl: Integer;
        SuppDrvrlvl: Integer;
        Total: Integer;
}

