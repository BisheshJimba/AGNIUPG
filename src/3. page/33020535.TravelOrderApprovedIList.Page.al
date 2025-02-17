page 33020535 "Travel Order Approved I List"
{
    CardPageID = "Travel Order Approved I Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020425;
    SourceTableView = SORTING(Travel Order No., Traveler's ID)
                      ORDER(Ascending)
                      WHERE(Posted = CONST(Yes),
                            Approved = CONST(Yes),
                            Approved II=CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Travel Order No."; "Travel Order No.")
                {
                }
                field("Travel Type"; "Travel Type")
                {
                }
                field("Traveler's ID"; "Traveler's ID")
                {
                }
                field("Traveler's Name"; "Traveler's Name")
                {
                }
                field(Designation; Designation)
                {
                    Visible = false;
                }
                field(Department; Department)
                {
                }
                field(ManagerID; ManagerID)
                {
                }
                field("Manager's Name"; "Manager's Name")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Invalid Document")
            {
                Caption = 'Invalid Document';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    InvalidOrder("Travel Order No.");
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        /*HRPermission.GET(USERID);
        IF HRPermission."Leave Date Adjust" = FALSE THEN
            ERROR('You Do Not Have Permisssion to Fill the Travel Order Form!');
         */

    end;

    var
        HRPermission: Record "33020304";
}

