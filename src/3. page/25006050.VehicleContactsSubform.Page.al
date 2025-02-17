page 25006050 "Vehicle Contacts Subform"
{
    Caption = 'Vehicle Contacts Subform';
    DelayedInsert = true;
    PageType = ListPart;
    PopulateAllFields = true;
    SaveValues = true;
    SourceTable = Table25006013;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                    Visible = false;
                }
                field("Relationship Code"; "Relationship Code")
                {
                }
                field("Contact No."; "Contact No.")
                {
                }
                field("Contact Name"; "Contact Name")
                {
                }
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

