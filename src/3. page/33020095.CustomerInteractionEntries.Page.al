page 33020095 "Customer Interaction Entries"
{
    PageType = List;
    SourceTable = Table33019859;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                    Visible = true;
                }
                field("Contact No."; "Contact No.")
                {
                }
                field(Name; Name)
                {
                }
                field("Line No."; "Line No.")
                {
                    Visible = false;
                }
                field("Pipeline Code"; "Pipeline Code")
                {
                }
                field("Date of Interaction"; "Date of Interaction")
                {
                }
                field("Next Date of Interaction"; "Next Date of Interaction")
                {
                }
                field("Interaction Type"; "Interaction Type")
                {
                }
                field("Interaction Details"; "Interaction Details")
                {
                }
                field(Remarks; Remarks)
                {
                }
                field("User ID"; "User ID")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
            systempart(; MyNotes)
            {
            }
            systempart(; Links)
            {
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        //SETFILTER("Contact No.","Contact No.");
    end;
}

