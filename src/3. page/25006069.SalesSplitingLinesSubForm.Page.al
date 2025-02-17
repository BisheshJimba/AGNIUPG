page 25006069 "Sales Spliting Lines SubForm"
{
    Caption = 'Sales Spliting Lines SubForm';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = Table25006042;
    SourceTableView = SORTING(Document Type, Document No., Temp. Document No., Line, Temp. Line No.)
                      ORDER(Ascending)
                      WHERE(Line = CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Temp. Line No."; "Temp. Line No.")
                {
                    Visible = false;
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("Location Code"; "Location Code")
                {
                }
                field(Description; Description)
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                }
                field(Amount; Amount)
                {
                    Editable = false;
                }
                field("Quantity Share %"; "Quantity Share %")
                {
                }
                field("New Quantity"; "New Quantity")
                {
                }
                field("Amount Share %"; "Amount Share %")
                {
                    Editable = false;
                    Visible = false;
                }
                field("New Amount"; "New Amount")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Include; Include)
                {
                }
            }
        }
    }

    actions
    {
    }
}

