page 33019895 "Posted Job Card List"
{
    CardPageID = "Posted Job Card";
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33019894;
    SourceTableView = SORTING(Job Card No.)
                      WHERE(Exide Claim=CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job Card No."; "Job Card No.")
                {
                }
                field("Battery Part No."; "Battery Part No.")
                {
                }
                field(MFG; MFG)
                {
                }
                field("Battery Serial No."; "Battery Serial No.")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Rep. Batt. Serial"; "Rep. Batt. Serial")
                {
                    TableRelation = "Exide Claim"."Issued Serial No." WHERE(Job Card No.=FIELD(Job Card No.));
                }
                field("Claim No."; "Claim No.")
                {
                }
                field(Date; Date)
                {
                    Caption = 'Claim Date';
                }
            }
        }
        area(factboxes)
        {
            part("Posted Job Card Detail"; 33019897)
            {
                Caption = 'Posted Job Card Detail';
                SubPageLink = Job Card No.=FIELD(Job Card No.);
            }
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
    }
}

